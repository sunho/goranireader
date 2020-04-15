import passport from 'passport';
import google from 'passport-google-oauth';
import {onSuccess} from "../index";
import {Vendor} from "../vendor";

const Strategy = google.OAuth2Strategy;

export const initGoogleStrategy = () => {
    passport.use(new Strategy({
            clientID: '',
            clientSecret: '',
            callbackURL: ''
        }, (accessToken, refreshToken, profile, done) => {
            const email = profile.emails![0].value;
            onSuccess(Vendor.GOOGLE, email, done);
        }
    ));
};