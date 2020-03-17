export interface Book {
  id: string;
  title: string;
  author: string;
  downloadLink: string;
  cover: string | undefined;
  coverType: string | undefined;
}
