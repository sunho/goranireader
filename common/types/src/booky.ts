/** 북키: 고라니 리더 책 파일 포맷 */

/** 북키 파일 하나를 표현하는 구조체입니다.  */
interface BookyBook {
  chapters: Chapter[];
  meta: Meta;
}

/** 책에 대한 간략한 정보를 담고 있습니다. */
interface Meta {
  /** uuid 형태 입니다. */
  id: string;
  title: string;
  author: string;
  /** base64 형태 입니다. */
  cover: string;
  /** 표지 이미지의 mime-type입니다. */
  coverType: string;
}

/** 챕터를 나타내는 구조체 입니다. */
interface Chapter {
  /** uuid 형태 입니다. */
  id: string;
  title: string;
  /** 본문을 나타냅니다. */
  items: Item[];
}

/** 본문의 구성요소를 나타냅니다. */
type Item = Sentence | Image;

/** 문장을 나타냅니다. */
interface Sentence {
  /** uuid 형태 입니다. */
  id: string;
  content: string;
  /** true일 경우 이 문장을 시작하기 전에 줄바꿈을 해야합니다. */
  start: boolean;
  kind: "sentence";
}

/** 사진을 나타냅니다. */
interface Image {
  /** uuid 형태 입니다. */
  id: string;
  /** base64 형태 입니다. */
  image: string;
  /** 이미지의 mime-type입니다. */
  imageType: string;
  kind: "image";
}
