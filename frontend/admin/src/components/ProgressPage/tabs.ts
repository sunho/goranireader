import { UserInsight } from "../../model";
import { ClassInfo } from "../Auth/withClass";

export enum TabState {
  Book = 0,
  Chapter,
  BookQuiz,
  ChapterQuiz
}

interface TabDef {
  minValue?: number;
  maxValue?: number;
  percent: boolean;
  getLabels?(
    data: UserInsight[],
    cals: ClassInfo
  ): { name: string; value: any }[];
  getData(
    data: UserInsight[],
    clas: ClassInfo,
    label?: any
  ): { username: string; value: number }[];
}

export const TabToTabDef: TabDef[] = [
  {
    minValue: 0,
    maxValue: 1,
    percent: true,
    getData: (data, clas, label) => {
      if (!clas.currentClass) {
        return [];
      }
      if (!clas.currentClass.mission) {
        return [];
      }
      if (!clas.currentClass.mission.bookId) {
        return [];
      }
      return data.flatMap(user => {
        if (!user.bookReads) {
          return [];
        }
        const out = user.bookReads[clas.currentClass!.mission!.bookId!];
        if (!out) {
          return [];
        }
        return [{ username: user.username, value: out }];
      });
    }
  },
  {
    minValue: 0,
    maxValue: 1,
    percent: true,
    getLabels: (data, clas) => {
      const out = new Set<string>();
      if (!clas.currentClass) {
        return [];
      }
      if (!clas.currentClass.mission) {
        return [];
      }
      if (!clas.currentClass.mission.bookId) {
        return [];
      }
      data.forEach(user => {
        if (!user.chapterReads) {
          return;
        }
        if (!user.chapterReads[clas.currentClass!.mission!.bookId!]) {
          return;
        }
        Object.keys(
          user.chapterReads[clas.currentClass!.mission!.bookId!]
        ).forEach(key => {
          out.add(key);
        });
      });
      return Array.from(out).map(item => ({ name: item, value: item }));
    },
    getData: (data, clas, label) => {
      if (!label) {
        return [];
      }
      if (!clas.currentClass) {
        return [];
      }
      if (!clas.currentClass.mission) {
        return [];
      }
      if (!clas.currentClass.mission.bookId) {
        return [];
      }
      return data.flatMap(user => {
        if (!user.chapterReads) {
          return [];
        }
        if (!user.chapterReads[clas.currentClass!.mission!.bookId!]) {
          return [];
        }
        const out =
          user.chapterReads[clas.currentClass!.mission!.bookId!][label];
        if (!out) {
          return [];
        }
        return [{ username: user.username, value: out }];
      });
    }
  },
  {
    minValue: 0,
    percent: false,
    getData: (data, clas, label) => {
      if (!clas.currentClass) {
        return [];
      }
      if (!clas.currentClass.mission) {
        return [];
      }
      if (!clas.currentClass.mission.bookId) {
        return [];
      }
      return data.flatMap(user => {
        if (!user.bookReadTimes) {
          return [];
        }
        const out = user.bookReadTimes[clas.currentClass!.mission!.bookId!];
        if (!out) {
          return [];
        }
        return [{ username: user.username, value: out / (60*1000) }];
      });
    }
  },
  {
    minValue: 0,
    percent: false,
    getLabels: (data, clas) => {
      const out = new Set<string>();
      if (!clas.currentClass) {
        return [];
      }
      if (!clas.currentClass.mission) {
        return [];
      }
      if (!clas.currentClass.mission.bookId) {
        return [];
      }
      data.forEach(user => {
        if (!user.chapterReadTimes) {
          return;
        }
        if (!user.chapterReadTimes[clas.currentClass!.mission!.bookId!]) {
          return;
        }
        Object.keys(
          user.chapterReadTimes[clas.currentClass!.mission!.bookId!]
        ).forEach(key => {
          out.add(key);
        });
      });
      return Array.from(out).map(item => ({ name: item, value: item }));
    },
    getData: (data, clas, label) => {
      if (!label) {
        return [];
      }
      if (!clas.currentClass) {
        return [];
      }
      if (!clas.currentClass.mission) {
        return [];
      }
      if (!clas.currentClass.mission.bookId) {
        return [];
      }
      return data.flatMap(user => {
        if (!user.chapterReadTimes) {
          return [];
        }
        if (!user.chapterReadTimes[clas.currentClass!.mission!.bookId!]) {
          return [];
        }
        const out =
          user.chapterReadTimes[clas.currentClass!.mission!.bookId!][label];
        if (!out) {
          return [];
        }
        return [{ username: user.username, value: out / (60*1000) }];
      });
    }
  },
  {
    minValue: 0,
    maxValue: 1,
    percent: true,
    getData: (data, clas, label) => {
      if (!clas.currentClass) {
        return [];
      }
      if (!clas.currentClass.mission) {
        return [];
      }
      if (!clas.currentClass.mission.bookId) {
        return [];
      }
      return data.flatMap(user => {
        if (!user.bookQuizSolved) {
          return [];
        }
        const out = user.bookQuizSolved[clas.currentClass!.mission!.bookId!];
        if (!out) {
          return [];
        }
        return [{ username: user.username, value: out }];
      });
    }
  },
  {
    minValue: 0,
    percent: false,
    getData: (data, clas, label) => {
      if (!clas.currentClass) {
        return [];
      }
      if (!clas.currentClass.mission) {
        return [];
      }
      if (!clas.currentClass.mission.bookId) {
        return [];
      }
      return data.flatMap(user => {
        if (!user.bookQuizScores) {
          return [];
        }
        const out = user.bookQuizScores[clas.currentClass!.mission!.bookId!];
        if (!out) {
          return [];
        }
        return [{ username: user.username, value: out }];
      });
    }
  }
];
