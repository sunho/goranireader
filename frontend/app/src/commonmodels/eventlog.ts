// To parse this data:
//
//   import { Convert, EventLog, EventLogPayload, LogPaginatePayload, PaginateWordUnknown, LogActivePayload, LogDeactivePayload, LogReviewStartPayload, LogReviewPaginatePayload, LogLWReviewNextPayload, LogLWReviewGiveupPayload, LogLWReviewCompletePayload, LogReviewEndPayload, Step } from "./file";
//
//   const eventLog = Convert.toEventLog(json);
//   const eventLogPayload = Convert.toEventLogPayload(json);
//   const logPaginatePayload = Convert.toLogPaginatePayload(json);
//   const paginateWordUnknown = Convert.toPaginateWordUnknown(json);
//   const logActivePayload = Convert.toLogActivePayload(json);
//   const logDeactivePayload = Convert.toLogDeactivePayload(json);
//   const logReviewStartPayload = Convert.toLogReviewStartPayload(json);
//   const logReviewPaginatePayload = Convert.toLogReviewPaginatePayload(json);
//   const logLWReviewNextPayload = Convert.toLogLWReviewNextPayload(json);
//   const logLWReviewGiveupPayload = Convert.toLogLWReviewGiveupPayload(json);
//   const logLWReviewCompletePayload = Convert.toLogLWReviewCompletePayload(json);
//   const logReviewEndPayload = Convert.toLogReviewEndPayload(json);
//   const step = Convert.toStep(json);
//
// These functions will throw an error if the JSON doesn't
// match the expected interface, even if the JSON is valid.

/**
 * 이벤트 로그를 나타냅니다.
 */
export interface EventLog {
    /**
     * 이벤트 로그의 실질적인 정보를 담고 있습니다.
     */
    payload: EventLogPayload;
    /**
     * 로그가 작성된 시각입니다. rfc3339형태 입니다.
     */
    time: string;
    /**
     * uuid형태 입니다.
     */
    userId: string;
}

/**
 * 이벤트 로그의 실질적인 정보를 담고 있습니다.
 *
 * 사용자가 페이지를 앞이나 뒤로 넘겼을 때 전송됩니다.
 *
 * 사용자가 리뷰게임을 시작했을 때 전송됩니다.
 *
 * 사용자가 리뷰게임의 리더에서 페이지를 넘겼을 때 전송됩니다.
 *
 * 사용자가 리뷰게임에서 페이지의 단어들을 다 리뷰하고 다음으로 넘어갈 때 전송됩니다.
 *
 * 사용자가 리뷰게임을 포기했을 때 발생합니다.
 *
 * 사용자가 리뷰게임의 목표 복습 단어수 이상의 단어를 복습하고 완료 버튼을 눌렀을 때 발생합니다.
 *
 * 사용자가 리뷰게임을 종료했을 때 발생합니다.
 *
 * 사용자가 특정 페이지에 들어왔을 때 전송됩니다.
 *
 * 사용자가 특정 페이지에서 나갔을 때 전송됩니다.
 */
export interface EventLogPayload {
    bookId?:    string;
    chapterId?: string;
    /**
     * 본문에 있는 문장들의 배열입니다.
     */
    content?: string[];
    /**
     * 해당 페이지에 있엇던 문장들의 아이디입니다.
     */
    sentenceIds?: string[];
    /**
     * 해당 페이지를 넘기기까지 걸린 시간입니다. 단위는 ms입니다.
     *
     * 페이지가 나타나고부터 경과한 시간
     *
     * 리뷰게임을 시작하고부터 경과한 시간.
     */
    time?: number;
    type:  PayloadType;
    /**
     * 해당 페이지를 보면서 찾아봤던 단어에 대한 정보를 담고 있습니다.
     */
    wordUnknowns?: PaginateWordUnknown[];
    reviewId?:     string;
    /**
     * 리뷰 게임의 단계를 나타냅니다
     */
    step?: Step;
    /**
     * 해당 텍스트에서 습득해야할 목표 단어입니다.
     */
    targetWords?: string[];
    /**
     * 전까지 복습한 단어의 수
     */
    previousCompletedWords?: number;
    /**
     * 사용자가 선택한 단어들입니다.
     */
    selectedWords?: string[];
    /**
     * 목표 복습 단어 수
     */
    targetCompletedWords?: number;
    /**
     * 사용자가 선택할 수 있엇던 단어들입니다.
     */
    visibleWords?: string[];
    /**
     * 해당 리뷰게임에 포함된 목표 단어들입니다.
     *
     * 목표 습득 단어들
     */
    words?: string[];
    /**
     * 복습한 단어의 수
     */
    completedWords?: number;
    page?:           string;
}

/**
 * 리뷰 게임의 단계를 나타냅니다
 */
export enum Step {
    ReviewWords = "review-words",
}

export enum PayloadType {
    Active = "active",
    Deactive = "deactive",
    Paginate = "paginate",
    ReviewEnd = "review-end",
    ReviewPaginate = "review-paginate",
    ReviewStart = "review-start",
    ReviewWordsReviewComplete = "review-words-review-complete",
    ReviewWordsReviewGiveup = "review-words-review-giveup",
    ReviewWordsReviewNext = "review-words-review-next",
}

/**
 * 찾아봤던 단어에 대한 정보를 담고 있습니다.
 */
export interface PaginateWordUnknown {
    sentenceId: string;
    /**
     * 페이지 시작후로부터 경과한 시간입니다. 단위는 ms입니다.
     */
    time: number;
    word: string;
    /**
     * 해당 문장을 아래 정규식을 기준으로 split했을 때 찾아본 단어가 몇번째인지 나타냅니다.
     * ```
     * * /([^a-zA-Z-']+)/
     * * ```
     */
    wordIndex: number;
}

/**
 * 사용자가 페이지를 앞이나 뒤로 넘겼을 때 전송됩니다.
 */
export interface LogPaginatePayload {
    bookId:    string;
    chapterId: string;
    /**
     * 본문에 있는 문장들의 배열입니다.
     */
    content: string[];
    /**
     * 해당 페이지에 있엇던 문장들의 아이디입니다.
     */
    sentenceIds: string[];
    /**
     * 해당 페이지를 넘기기까지 걸린 시간입니다. 단위는 ms입니다.
     */
    time: number;
    type: LogPaginatePayloadType;
    /**
     * 해당 페이지를 보면서 찾아봤던 단어에 대한 정보를 담고 있습니다.
     */
    wordUnknowns: PaginateWordUnknown[];
}

export enum LogPaginatePayloadType {
    Paginate = "paginate",
}

/**
 * 사용자가 특정 페이지에 들어왔을 때 전송됩니다.
 */
export interface LogActivePayload {
    page: string;
    type: LogActivePayloadType;
}

export enum LogActivePayloadType {
    Active = "active",
}

/**
 * 사용자가 특정 페이지에서 나갔을 때 전송됩니다.
 */
export interface LogDeactivePayload {
    page: string;
    type: LogDeactivePayloadType;
}

export enum LogDeactivePayloadType {
    Deactive = "deactive",
}

/**
 * 사용자가 리뷰게임을 시작했을 때 전송됩니다.
 */
export interface LogReviewStartPayload {
    reviewId: string;
    /**
     * 리뷰 게임의 단계를 나타냅니다
     */
    step: Step;
    type: LogReviewStartPayloadType;
}

export enum LogReviewStartPayloadType {
    ReviewStart = "review-start",
}

/**
 * 사용자가 리뷰게임의 리더에서 페이지를 넘겼을 때 전송됩니다.
 */
export interface LogReviewPaginatePayload {
    /**
     * 본문에 있는 문장들의 배열입니다.
     */
    content:     string[];
    reviewId:    string;
    sentenceIds: string[];
    /**
     * 리뷰 게임의 단계를 나타냅니다
     */
    step: Step;
    /**
     * 해당 텍스트에서 습득해야할 목표 단어입니다.
     */
    targetWords: string[];
    /**
     * 해당 페이지를 넘기기까지 걸린 시간입니다. 단위는 ms입니다.
     */
    time: number;
    type: LogReviewPaginatePayloadType;
    /**
     * 해당 페이지를 보면서 찾아봤던 단어에 대한 정보를 담고 있습니다.
     */
    wordUnknowns: PaginateWordUnknown[];
}

export enum LogReviewPaginatePayloadType {
    ReviewPaginate = "review-paginate",
}

/**
 * 사용자가 리뷰게임에서 페이지의 단어들을 다 리뷰하고 다음으로 넘어갈 때 전송됩니다.
 */
export interface LogLWReviewNextPayload {
    /**
     * 전까지 복습한 단어의 수
     */
    previousCompletedWords: number;
    reviewId:               string;
    /**
     * 사용자가 선택한 단어들입니다.
     */
    selectedWords: string[];
    /**
     * 목표 복습 단어 수
     */
    targetCompletedWords: number;
    /**
     * 페이지가 나타나고부터 경과한 시간
     */
    time: number;
    type: LogLWReviewNextPayloadType;
    /**
     * 사용자가 선택할 수 있엇던 단어들입니다.
     */
    visibleWords: string[];
    /**
     * 해당 리뷰게임에 포함된 목표 단어들입니다.
     */
    words: string[];
}

export enum LogLWReviewNextPayloadType {
    ReviewWordsReviewNext = "review-words-review-next",
}

/**
 * 사용자가 리뷰게임을 포기했을 때 발생합니다.
 */
export interface LogLWReviewGiveupPayload {
    /**
     * 복습한 단어의 수
     */
    completedWords: number;
    reviewId:       string;
    /**
     * 목표 복습 단어 수
     */
    targetCompletedWords: number;
    /**
     * 리뷰게임을 시작하고부터 경과한 시간.
     */
    time: number;
    type: LogLWReviewGiveupPayloadType;
    /**
     * 목표 습득 단어들
     */
    words: string[];
}

export enum LogLWReviewGiveupPayloadType {
    ReviewWordsReviewGiveup = "review-words-review-giveup",
}

/**
 * 사용자가 리뷰게임의 목표 복습 단어수 이상의 단어를 복습하고 완료 버튼을 눌렀을 때 발생합니다.
 */
export interface LogLWReviewCompletePayload {
    /**
     * 복습한 단어의 수
     */
    completedWords: number;
    reviewId:       string;
    /**
     * 목표 복습 단어 수
     */
    targetCompletedWords: number;
    /**
     * 리뷰게임을 시작하고부터 경과한 시간.
     */
    time: number;
    type: LogLWReviewCompletePayloadType;
    /**
     * 목표 습득 단어들
     */
    words: string[];
}

export enum LogLWReviewCompletePayloadType {
    ReviewWordsReviewComplete = "review-words-review-complete",
}

/**
 * 사용자가 리뷰게임을 종료했을 때 발생합니다.
 */
export interface LogReviewEndPayload {
    reviewId: string;
    type:     LogReviewEndPayloadType;
}

export enum LogReviewEndPayloadType {
    ReviewEnd = "review-end",
}

// Converts JSON strings to/from your types
// and asserts the results of JSON.parse at runtime
export class Convert {
    public static toEventLog(json: string): EventLog {
        return cast(JSON.parse(json), r("EventLog"));
    }

    public static eventLogToJson(value: EventLog): string {
        return JSON.stringify(uncast(value, r("EventLog")), null, 2);
    }

    public static toEventLogPayload(json: string): EventLogPayload {
        return cast(JSON.parse(json), r("EventLogPayload"));
    }

    public static eventLogPayloadToJson(value: EventLogPayload): string {
        return JSON.stringify(uncast(value, r("EventLogPayload")), null, 2);
    }

    public static toLogPaginatePayload(json: string): LogPaginatePayload {
        return cast(JSON.parse(json), r("LogPaginatePayload"));
    }

    public static logPaginatePayloadToJson(value: LogPaginatePayload): string {
        return JSON.stringify(uncast(value, r("LogPaginatePayload")), null, 2);
    }

    public static toPaginateWordUnknown(json: string): PaginateWordUnknown {
        return cast(JSON.parse(json), r("PaginateWordUnknown"));
    }

    public static paginateWordUnknownToJson(value: PaginateWordUnknown): string {
        return JSON.stringify(uncast(value, r("PaginateWordUnknown")), null, 2);
    }

    public static toLogActivePayload(json: string): LogActivePayload {
        return cast(JSON.parse(json), r("LogActivePayload"));
    }

    public static logActivePayloadToJson(value: LogActivePayload): string {
        return JSON.stringify(uncast(value, r("LogActivePayload")), null, 2);
    }

    public static toLogDeactivePayload(json: string): LogDeactivePayload {
        return cast(JSON.parse(json), r("LogDeactivePayload"));
    }

    public static logDeactivePayloadToJson(value: LogDeactivePayload): string {
        return JSON.stringify(uncast(value, r("LogDeactivePayload")), null, 2);
    }

    public static toLogReviewStartPayload(json: string): LogReviewStartPayload {
        return cast(JSON.parse(json), r("LogReviewStartPayload"));
    }

    public static logReviewStartPayloadToJson(value: LogReviewStartPayload): string {
        return JSON.stringify(uncast(value, r("LogReviewStartPayload")), null, 2);
    }

    public static toLogReviewPaginatePayload(json: string): LogReviewPaginatePayload {
        return cast(JSON.parse(json), r("LogReviewPaginatePayload"));
    }

    public static logReviewPaginatePayloadToJson(value: LogReviewPaginatePayload): string {
        return JSON.stringify(uncast(value, r("LogReviewPaginatePayload")), null, 2);
    }

    public static toLogLWReviewNextPayload(json: string): LogLWReviewNextPayload {
        return cast(JSON.parse(json), r("LogLWReviewNextPayload"));
    }

    public static logLWReviewNextPayloadToJson(value: LogLWReviewNextPayload): string {
        return JSON.stringify(uncast(value, r("LogLWReviewNextPayload")), null, 2);
    }

    public static toLogLWReviewGiveupPayload(json: string): LogLWReviewGiveupPayload {
        return cast(JSON.parse(json), r("LogLWReviewGiveupPayload"));
    }

    public static logLWReviewGiveupPayloadToJson(value: LogLWReviewGiveupPayload): string {
        return JSON.stringify(uncast(value, r("LogLWReviewGiveupPayload")), null, 2);
    }

    public static toLogLWReviewCompletePayload(json: string): LogLWReviewCompletePayload {
        return cast(JSON.parse(json), r("LogLWReviewCompletePayload"));
    }

    public static logLWReviewCompletePayloadToJson(value: LogLWReviewCompletePayload): string {
        return JSON.stringify(uncast(value, r("LogLWReviewCompletePayload")), null, 2);
    }

    public static toLogReviewEndPayload(json: string): LogReviewEndPayload {
        return cast(JSON.parse(json), r("LogReviewEndPayload"));
    }

    public static logReviewEndPayloadToJson(value: LogReviewEndPayload): string {
        return JSON.stringify(uncast(value, r("LogReviewEndPayload")), null, 2);
    }

    public static toStep(json: string): Step {
        return cast(JSON.parse(json), r("Step"));
    }

    public static stepToJson(value: Step): string {
        return JSON.stringify(uncast(value, r("Step")), null, 2);
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
    "EventLog": o([
        { json: "payload", js: "payload", typ: r("EventLogPayload") },
        { json: "time", js: "time", typ: "" },
        { json: "userId", js: "userId", typ: "" },
    ], "any"),
    "EventLogPayload": o([
        { json: "bookId", js: "bookId", typ: u(undefined, "") },
        { json: "chapterId", js: "chapterId", typ: u(undefined, "") },
        { json: "content", js: "content", typ: u(undefined, a("")) },
        { json: "sentenceIds", js: "sentenceIds", typ: u(undefined, a("")) },
        { json: "time", js: "time", typ: u(undefined, 3.14) },
        { json: "type", js: "type", typ: r("PayloadType") },
        { json: "wordUnknowns", js: "wordUnknowns", typ: u(undefined, a(r("PaginateWordUnknown"))) },
        { json: "reviewId", js: "reviewId", typ: u(undefined, "") },
        { json: "step", js: "step", typ: u(undefined, r("Step")) },
        { json: "targetWords", js: "targetWords", typ: u(undefined, a("")) },
        { json: "previousCompletedWords", js: "previousCompletedWords", typ: u(undefined, 3.14) },
        { json: "selectedWords", js: "selectedWords", typ: u(undefined, a("")) },
        { json: "targetCompletedWords", js: "targetCompletedWords", typ: u(undefined, 3.14) },
        { json: "visibleWords", js: "visibleWords", typ: u(undefined, a("")) },
        { json: "words", js: "words", typ: u(undefined, a("")) },
        { json: "completedWords", js: "completedWords", typ: u(undefined, 3.14) },
        { json: "page", js: "page", typ: u(undefined, "") },
    ], "any"),
    "PaginateWordUnknown": o([
        { json: "sentenceId", js: "sentenceId", typ: "" },
        { json: "time", js: "time", typ: 3.14 },
        { json: "word", js: "word", typ: "" },
        { json: "wordIndex", js: "wordIndex", typ: 3.14 },
    ], "any"),
    "LogPaginatePayload": o([
        { json: "bookId", js: "bookId", typ: "" },
        { json: "chapterId", js: "chapterId", typ: "" },
        { json: "content", js: "content", typ: a("") },
        { json: "sentenceIds", js: "sentenceIds", typ: a("") },
        { json: "time", js: "time", typ: 3.14 },
        { json: "type", js: "type", typ: r("LogPaginatePayloadType") },
        { json: "wordUnknowns", js: "wordUnknowns", typ: a(r("PaginateWordUnknown")) },
    ], "any"),
    "LogActivePayload": o([
        { json: "page", js: "page", typ: "" },
        { json: "type", js: "type", typ: r("LogActivePayloadType") },
    ], "any"),
    "LogDeactivePayload": o([
        { json: "page", js: "page", typ: "" },
        { json: "type", js: "type", typ: r("LogDeactivePayloadType") },
    ], "any"),
    "LogReviewStartPayload": o([
        { json: "reviewId", js: "reviewId", typ: "" },
        { json: "step", js: "step", typ: r("Step") },
        { json: "type", js: "type", typ: r("LogReviewStartPayloadType") },
    ], "any"),
    "LogReviewPaginatePayload": o([
        { json: "content", js: "content", typ: a("") },
        { json: "reviewId", js: "reviewId", typ: "" },
        { json: "sentenceIds", js: "sentenceIds", typ: a("") },
        { json: "step", js: "step", typ: r("Step") },
        { json: "targetWords", js: "targetWords", typ: a("") },
        { json: "time", js: "time", typ: 3.14 },
        { json: "type", js: "type", typ: r("LogReviewPaginatePayloadType") },
        { json: "wordUnknowns", js: "wordUnknowns", typ: a(r("PaginateWordUnknown")) },
    ], "any"),
    "LogLWReviewNextPayload": o([
        { json: "previousCompletedWords", js: "previousCompletedWords", typ: 3.14 },
        { json: "reviewId", js: "reviewId", typ: "" },
        { json: "selectedWords", js: "selectedWords", typ: a("") },
        { json: "targetCompletedWords", js: "targetCompletedWords", typ: 3.14 },
        { json: "time", js: "time", typ: 3.14 },
        { json: "type", js: "type", typ: r("LogLWReviewNextPayloadType") },
        { json: "visibleWords", js: "visibleWords", typ: a("") },
        { json: "words", js: "words", typ: a("") },
    ], "any"),
    "LogLWReviewGiveupPayload": o([
        { json: "completedWords", js: "completedWords", typ: 3.14 },
        { json: "reviewId", js: "reviewId", typ: "" },
        { json: "targetCompletedWords", js: "targetCompletedWords", typ: 3.14 },
        { json: "time", js: "time", typ: 3.14 },
        { json: "type", js: "type", typ: r("LogLWReviewGiveupPayloadType") },
        { json: "words", js: "words", typ: a("") },
    ], "any"),
    "LogLWReviewCompletePayload": o([
        { json: "completedWords", js: "completedWords", typ: 3.14 },
        { json: "reviewId", js: "reviewId", typ: "" },
        { json: "targetCompletedWords", js: "targetCompletedWords", typ: 3.14 },
        { json: "time", js: "time", typ: 3.14 },
        { json: "type", js: "type", typ: r("LogLWReviewCompletePayloadType") },
        { json: "words", js: "words", typ: a("") },
    ], "any"),
    "LogReviewEndPayload": o([
        { json: "reviewId", js: "reviewId", typ: "" },
        { json: "type", js: "type", typ: r("LogReviewEndPayloadType") },
    ], "any"),
    "Step": [
        "review-words",
    ],
    "PayloadType": [
        "active",
        "deactive",
        "paginate",
        "review-end",
        "review-paginate",
        "review-start",
        "review-words-review-complete",
        "review-words-review-giveup",
        "review-words-review-next",
    ],
    "LogPaginatePayloadType": [
        "paginate",
    ],
    "LogActivePayloadType": [
        "active",
    ],
    "LogDeactivePayloadType": [
        "deactive",
    ],
    "LogReviewStartPayloadType": [
        "review-start",
    ],
    "LogReviewPaginatePayloadType": [
        "review-paginate",
    ],
    "LogLWReviewNextPayloadType": [
        "review-words-review-next",
    ],
    "LogLWReviewGiveupPayloadType": [
        "review-words-review-giveup",
    ],
    "LogLWReviewCompletePayloadType": [
        "review-words-review-complete",
    ],
    "LogReviewEndPayloadType": [
        "review-end",
    ],
};
