import enData from './data/en.json';
import { removeSuffix } from './util';

export interface Words {
  normalizedForms(word: string): string[];
}

export class EnglishWords {
  constructor() {

  }

  normalizedForms(word_:string): string[] {
    const oword = word_.toLowerCase();
    const arr = [oword];
    const iregularPasts = enData.iregularPasts as any;
    const irregularCompletes = enData.irregularCompletes as any;
    if (iregularPasts.hasOwnProperty(oword)){
      arr.push(iregularPasts[oword]);
    }
    if (irregularCompletes.hasOwnProperty(oword)) {
      arr.push(irregularCompletes[oword]);
    }

    let suffixes = enData.suffixes;
    suffixes.forEach(suffix => {
      removeSuffix(oword, 'y' + suffixes, word => {
        arr.push(word + 'ie');
      });

      removeSuffix(oword, 'i' + suffix, word => {
        arr.push(word + 'y');
      });

      removeSuffix(oword, 'al' + suffixes, word => {
        arr.push(word);
      });

      removeSuffix(oword, suffix, word => {
        arr.push(word + "e");
        if (word.length >= 2 && word.slice(-1) === word.slice(-2)) {
          // get -> getting
          arr.push(word.slice(0, -1));
        }
        arr.push(word);
        arr.push(word + "le");
        arr.push(word + "y");
      });
    });
    return arr.filter((value, index, self) => self.indexOf(value) === index);
  }
}
