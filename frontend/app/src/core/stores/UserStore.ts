import { observable, action, computed } from "mobx";
import RootStore from "./RootStore";
import { User } from "../models";
import FirebaseService from "./FirebaseService";
import { autobind } from "core-decorators";
import { Location } from "../../reader/stores/BookReaderStore";
import migrator from '../models/migrations/user';

@autobind
class UserStore {
  rootStore: RootStore;
  firebaseService: FirebaseService;
  constructor(rootStore: RootStore) {
    this.rootStore = rootStore;
    this.firebaseService = rootStore.firebaseService;
  }

  fireId(): string | undefined {
    return this.firebaseService.auth.currentUser?.uid;
  }

  userId: string | null = null;

  @observable user: User | null = null;

  @computed get hasReview() {
    if (!this.user) {
      return false;
    }
    if (!this.user.review) {
      return false;
    }
    return this.user.review.end > (this.user.lastReviewEnd || 0);
  }

  @action async loadUser() {
    try {
      if (!this.fireId()) throw new Error("no current user");
      if (!this.userId) {
        const user = await this.firebaseService.fuserDoc().get();
        this.userId = user.data()!.userId;
      }
      const user2 = await this.firebaseService.userDoc(this.userId!).get();
      const data = user2.data()!;
      data['review'] = "https://gorani-reader-generated-reviews.s3.ap-northeast-2.amazonaws.com/8ACCQYz8NMc4Lc9Nze3R-1586678078.json";
      data['lastReviewEnd'] = 0;
      if (data["review"] && typeof data["review"] === "string") {
        const review = await fetch(data["review"]).then(x => x.json());
        data["review"] = review;
      }
      this.user = data as User;
      await this.firebaseService
        .userDoc(this.userId!)
        .update({ fireId: this.fireId()! });
      this.user = migrator.migrate(this.user);
    } catch (e) {
      this.userId = null;
      this.user = null;
      throw e;
    }
  }

  @action async login(word: string, word2: string, number: string) {
    if (!this.fireId()) throw new Error("no current user");
    const users = await this.firebaseService
      .users()
      .where("secretCode", "==", `${word}-${word2}-${number}`)
      .get();
    if (users.size === 0) {
      throw new Error("invalid secret code");
    }
    const user = users.docs[0];
    await this.firebaseService.fuserDoc().set({ userId: user.id });
    await this.loadUser();
    await this.firebaseService
      .userDoc(this.userId!)
      .update({ fireId: this.fireId()! });
    return Promise.resolve();
  }

  getLocation(bookId: string): Location {
    if (!this.user?.locations) {
      return {
        chapterId: "",
        sentenceId: ""
      };
    }
    if (!(bookId in this.user!.locations)) {
      return {
        chapterId: "",
        sentenceId: ""
      };
    }
    return this.user!.locations[bookId];
  }

  @action async saveLocation(bookId: string, location: Location) {
    if (!this.user!.locations) {
      this.user!.locations = {};
    }
    this.user!.locations[bookId] = location;
    await this.firebaseService
      .userDoc(this.userId!)
      .update({ locations: this.user!.locations });
    await this.loadUser();
    return Promise.resolve();
  }

  async saveLastReviewEnd(end: number) {
    await this.firebaseService
      .userDoc(this.userId!)
      .update({ lastReviewEnd: end });
    await this.loadUser();
  }
}

export default UserStore;
