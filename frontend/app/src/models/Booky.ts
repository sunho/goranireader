export interface BookyBook {

}

export interface Sentence {
  id: string;
  content: string;
  start: boolean;
}

export interface SelectedWord {
  id: string;
  sentenceId: string;
  wordIndex: number;
  word: string;
  up: boolean;
}

export interface SelectedSentence {
  id: string;
  sentenceId: string;
  top: number;
  bottom: number;
  up: boolean;
}

export interface DictSearchResult {
  words: DictWord[];
  addable: boolean;
}

export interface DictWord {
  word: string;
  pron: string;
  defs: DictDefinition[];
}

export interface DictDefinition {
  id: number;
  def: string;
  pos?: string;
}

export interface WordQuestion {
  type: 'word';
  id: string;
  sentence: string;
  wordIndex: number;
  options: string[];
  answer: number;
}

export interface SummaryQuestion {
  type: 'summary';
  id: string;
  options: string[];
  answer: number;
}

export type Question = WordQuestion | SummaryQuestion;
