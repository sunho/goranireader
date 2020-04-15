import passport from 'passport';
import {initGoogleStrategy} from "./strategies/google-strategy";
import {Vendor} from "./vendor";
import {VerifyOptions} from "passport-google-oauth";
import {initNaverStrategy} from "./strategies/naver-strategy";

export const initPassport = () => {
    passport.serializeUser((user, done) => {
        done(null, user);
    });

    passport.deserializeUser((user, done) => {
        done(null, user);
    });

    initGoogleStrategy();
    initNaverStrategy();
}

export const onSuccess = (vendor: Vendor, email: string, done: (error: any, user?: any, msg?: VerifyOptions) => void) => {
    // TODO: DB에 유저 데이터 만들기
}