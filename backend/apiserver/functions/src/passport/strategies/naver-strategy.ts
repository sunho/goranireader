import passport from 'passport';
import naver from 'passport-naver';
import {onSuccess} from "../index";
import {Vendor} from "../vendor";
import config from "../../config/config";

const Strategy = naver.Strategy;

export const initNaverStrategy = () => {
    passport.use(new Strategy({
            clientID: config.auth.naver.clientID,
            clientSecret: config.auth.naver.clientID,
            callbackURL: ''
        }, (accessToken, refreshToken, profile, done) => {
            const email = profile.emails![0].value;

            onSuccess(Vendor.NAVER, email, done);
        }
    ));
};