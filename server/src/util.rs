use std::str::FromStr;
use std::ops::Try;

pub fn try_parse_string<S, T, U>(string: impl Try<Ok = S, Error=U>) -> Option<T> where S: AsRef<str>, T: FromStr {
    if let Ok(Ok(value)) = string.into_result().map(|s| s.as_ref().parse::<T>()) {
        Some(value)
    } else {
        None
    }
}

pub fn try_parse_string_or<S, T, U>(string: impl Try<Ok = S, Error=U>, default: T) -> T where S: AsRef<str>, T: FromStr {
    if let Ok(Ok(value)) = string.into_result().map(|s| s.as_ref().parse::<T>()) {
        value
    } else {
        default
    }
}

use std::env;

pub fn get_env<V>(key: &str) -> Option<V> where V: FromStr {
    try_parse_string(env::var(key))
}

pub fn get_env_or<V>(key: &str, default: V) -> V where V: FromStr {
    try_parse_string_or(env::var(key), default)
}
