import enData from './data/en.json';
import { removeSuffix } from './util';

export interface Words {
  normalizedForms(word: string): string[];
}

export class EnglishWords {
  constructor() {

  }

  normalizedForms(word:string): string[] {
    word = word.toLowerCase();
    const arr = [word];
    const iregularPasts = enData.iregularPasts as any;
    const irregularCompletes = enData.irregularCompletes as any;
    if (iregularPasts.hasOwnProperty(word)){
      arr.push(iregularPasts[word]);
    }
    if (irregularCompletes.hasOwnProperty(word)) {
      arr.push(irregularCompletes[word]);
    }

    let suffixes = enData.suffixes;
    suffixes.forEach(suffix => {
      removeSuffix(word, 'y' + suffixes, word => {
        arr.push(word + 'ie');
      });

      removeSuffix(word, 'i' + suffix, word => {
        arr.push(word + 'y');
      });

      removeSuffix(word, 'al' + suffixes, word => {
        arr.push(word);
      });

      removeSuffix(word, suffix, word => {
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
