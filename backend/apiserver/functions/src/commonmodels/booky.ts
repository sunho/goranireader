// To parse this data:
//
//   import { Convert, BookyBook, Meta, Chapter, Item, Sentence, Image } from "./file";
//
//   const bookyBook = Convert.toBookyBook(json);
//   const meta = Convert.toMeta(json);
//   const chapter = Convert.toChapter(json);
//   const item = Convert.toItem(json);
//   const sentence = Convert.toSentence(json);
//   const image = Convert.toImage(json);
//
// These functions will throw an error if the JSON doesn't
// match the expected interface, even if the JSON is valid.

/**
 * 북키: 고라니 리더 독자 책 파일 포맷
 * 북키(고라니 리더 책 파일 포맷) 파일 하나를 표현하는 구조체입니다.
 */
export interface BookyBook {
    chapters: Chapter[];
    meta:     Meta;
}

/**
 * 챕터를 나타내는 구조체 입니다.
 */
export interface Chapter {
    /**
     * uuid 형태 입니다.
     */
    id: string;
    /**
     * 본문을 나타냅니다.
     */
    items: Item[];
    title: string;
}

/**
 * 문장을 나타냅니다.
 *
 * 사진을 나타냅니다.
 */
export interface Item {
    content?: string;
    /**
     * uuid 형태 입니다.
     */
    id:   string;
    kind: ItemKind;
    /**
     * true일 경우 이 문장을 시작하기 전에 줄바꿈을 해야합니다.
     */
    start?: boolean;
    /**
     * base64 형태 입니다.
     */
    image?: string;
    /**
     * 이미지의 mime-type입니다.
     */
    imageType?: string;
}

export enum ItemKind {
    Image = "image",
    Sentence = "sentence",
}

/**
 * 책에 대한 간략한 정보를 담고 있습니다.
 */
export interface Meta {
    author: string;
    /**
     * base64 형태 입니다.
     */
    cover: string;
    /**
     * 표지 이미지의 mime-type입니다.
     */
    coverType: string;
    /**
     * uuid 형태 입니다.
     */
    id:    string;
    title: string;
}

/**
 * 문장을 나타냅니다.
 */
export interface Sentence {
    content: string;
    /**
     * uuid 형태 입니다.
     */
    id:   string;
    kind: SentenceKind;
    /**
     * true일 경우 이 문장을 시작하기 전에 줄바꿈을 해야합니다.
     */
    start: boolean;
}

export enum SentenceKind {
    Sentence = "sentence",
}

/**
 * 사진을 나타냅니다.
 */
export interface Image {
    /**
     * uuid 형태 입니다.
     */
    id: string;
    /**
     * base64 형태 입니다.
     */
    image: string;
    /**
     * 이미지의 mime-type입니다.
     */
    imageType: string;
    kind:      ImageKind;
}

export enum ImageKind {
    Image = "image",
}

// Converts JSON strings to/from your types
// and asserts the results of JSON.parse at runtime
export class Convert {
    public static toBookyBook(json: string): BookyBook {
        return cast(JSON.parse(json), r("BookyBook"));
    }

    public static bookyBookToJson(value: BookyBook): string {
        return JSON.stringify(uncast(value, r("BookyBook")), null, 2);
    }

    public static toMeta(json: string): Meta {
        return cast(JSON.parse(json), r("Meta"));
    }

    public static metaToJson(value: Meta): string {
        return JSON.stringify(uncast(value, r("Meta")), null, 2);
    }

    public static toChapter(json: string): Chapter {
        return cast(JSON.parse(json), r("Chapter"));
    }

    public static chapterToJson(value: Chapter): string {
        return JSON.stringify(uncast(value, r("Chapter")), null, 2);
    }

    public static toItem(json: string): Item {
        return cast(JSON.parse(json), r("Item"));
    }

    public static itemToJson(value: Item): string {
        return JSON.stringify(uncast(value, r("Item")), null, 2);
    }

    public static toSentence(json: string): Sentence {
        return cast(JSON.parse(json), r("Sentence"));
    }

    public static sentenceToJson(value: Sentence): string {
        return JSON.stringify(uncast(value, r("Sentence")), null, 2);
    }

    public static toImage(json: string): Image {
        return cast(JSON.parse(json), r("Image"));
    }

    public static imageToJson(value: Image): string {
        return JSON.stringify(uncast(value, r("Image")), null, 2);
    }
}

function invalidValue(typ: any, val: any): never {
    throw Error(`Invalid value ${JSON.stringify(val)} for type ${JSON.stringify(typ)}`);
}

function jsonToJSProps(typ: any): any {
    if (typ.jsonToJS === undefined) {
        var map: any = {};
        typ.props.forEach((p: any) => map[p.json] = { key: p.js, typ: p.typ });
        typ.jsonToJS = map;
    }
    return typ.jsonToJS;
}

function jsToJSONProps(typ: any): any {
    if (typ.jsToJSON === undefined) {
        var map: any = {};
        typ.props.forEach((p: any) => map[p.js] = { key: p.json, typ: p.typ });
        typ.jsToJSON = map;
    }
    return typ.jsToJSON;
}

function transform(val: any, typ: any, getProps: any): any {
    function transformPrimitive(typ: string, val: any): any {
        if (typeof typ === typeof val) return val;
        return invalidValue(typ, val);
    }

    function transformUnion(typs: any[], val: any): any {
        // val must validate against one typ in typs
        var l = typs.length;
        for (var i = 0; i < l; i++) {
            var typ = typs[i];
            try {
                return transform(val, typ, getProps);
            } catch (_) {}
        }
        return invalidValue(typs, val);
    }

    function transformEnum(cases: string[], val: any): any {
        if (cases.indexOf(val) !== -1) return val;
        return invalidValue(cases, val);
    }

    function transformArray(typ: any, val: any): any {
        // val must be an array with no invalid elements
        if (!Array.isArray(val)) return invalidValue("array", val);
        return val.map(el => transform(el, typ, getProps));
    }

    function transformDate(typ: any, val: any): any {
        if (val === null) {
            return null;
        }
        const d = new Date(val);
        if (isNaN(d.valueOf())) {
            return invalidValue("Date", val);
        }
        return d;
    }

    function transformObject(props: { [k: string]: any }, additional: any, val: any): any {
        if (val === null || typeof val !== "object" || Array.isArray(val)) {
            return invalidValue("object", val);
        }
        var result: any = {};
        Object.getOwnPropertyNames(props).forEach(key => {
            const prop = props[key];
            const v = Object.prototype.hasOwnProperty.call(val, key) ? val[key] : undefined;
            result[prop.key] = transform(v, prop.typ, getProps);
        });
        Object.getOwnPropertyNames(val).forEach(key => {
            if (!Object.prototype.hasOwnProperty.call(props, key)) {
                result[key] = transform(val[key], additional, getProps);
            }
        });
        return result;
    }

    if (typ === "any") return val;
    if (typ === null) {
        if (val === null) return val;
        return invalidValue(typ, val);
    }
    if (typ === false) return invalidValue(typ, val);
    while (typeof typ === "object" && typ.ref !== undefined) {
        typ = typeMap[typ.ref];
    }
    if (Array.isArray(typ)) return transformEnum(typ, val);
    if (typeof typ === "object") {
        return typ.hasOwnProperty("unionMembers") ? transformUnion(typ.unionMembers, val)
            : typ.hasOwnProperty("arrayItems")    ? transformArray(typ.arrayItems, val)
            : typ.hasOwnProperty("props")         ? transformObject(getProps(typ), typ.additional, val)
            : invalidValue(typ, val);
    }
    // Numbers can be parsed by Date but shouldn't be.
    if (typ === Date && typeof val !== "number") return transformDate(typ, val);
    return transformPrimitive(typ, val);
}

function cast<T>(val: any, typ: any): T {
    return transform(val, typ, jsonToJSProps);
}

function uncast<T>(val: T, typ: any): any {
    return transform(val, typ, jsToJSONProps);
}

function a(typ: any) {
    return { arrayItems: typ };
}

function u(...typs: any[]) {
    return { unionMembers: typs };
}

function o(props: any[], additional: any) {
    return { props, additional };
}

function m(additional: any) {
    return { props: [], additional };
}

function r(name: string) {
    return { ref: name };
}

const typeMap: any = {
    "BookyBook": o([
        { json: "chapters", js: "chapters", typ: a(r("Chapter")) },
        { json: "meta", js: "meta", typ: r("Meta") },
    ], "any"),
    "Chapter": o([
        { json: "id", js: "id", typ: "" },
        { json: "items", js: "items", typ: a(r("Item")) },
        { json: "title", js: "title", typ: "" },
    ], "any"),
    "Item": o([
        { json: "content", js: "content", typ: u(undefined, "") },
        { json: "id", js: "id", typ: "" },
        { json: "kind", js: "kind", typ: r("ItemKind") },
        { json: "start", js: "start", typ: u(undefined, true) },
        { json: "image", js: "image", typ: u(undefined, "") },
        { json: "imageType", js: "imageType", typ: u(undefined, "") },
    ], "any"),
    "Meta": o([
        { json: "author", js: "author", typ: "" },
        { json: "cover", js: "cover", typ: "" },
        { json: "coverType", js: "coverType", typ: "" },
        { json: "id", js: "id", typ: "" },
        { json: "title", js: "title", typ: "" },
    ], "any"),
    "Sentence": o([
        { json: "content", js: "content", typ: "" },
        { json: "id", js: "id", typ: "" },
        { json: "kind", js: "kind", typ: r("SentenceKind") },
        { json: "start", js: "start", typ: true },
    ], "any"),
    "Image": o([
        { json: "id", js: "id", typ: "" },
        { json: "image", js: "image", typ: "" },
        { json: "imageType", js: "imageType", typ: "" },
        { json: "kind", js: "kind", typ: r("ImageKind") },
    ], "any"),
    "ItemKind": [
        "image",
        "sentence",
    ],
    "SentenceKind": [
        "sentence",
    ],
    "ImageKind": [
        "image",
    ],
};
