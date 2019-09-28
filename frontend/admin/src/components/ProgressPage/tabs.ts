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
  type: string;
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

export const msToString = (t: number) => {
  let time = t;
  let hours = Math.floor(time / (3600*1000));
  time = time % (3600*1000)
  let minutes = Math.floor(time / (60*1000));
  time = time % (60*1000)
  let seconds = Math.floor(time / (1000));
  return `${hours} h ${minutes} m ${seconds} s`
}

export const TabToTabDef: TabDef[] = [
  {
    minValue: 0,
    maxValue: 1,
    type: 'percent',
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
    type: 'percent',
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
    type: 'days',
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
        return [{ username: user.username, value: out}];
      });
    }
  },
  {
    minValue: 0,
    type: 'days',
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
        return [{ username: user.username, value: out }];
      });
    }
  },
  {
    minValue: 0,
    maxValue: 1,
    type: 'percent',
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
    type: 'number',
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
