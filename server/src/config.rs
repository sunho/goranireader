extern crate dotenv;

lazy_static! {
    static ref CONFIG: Config = Config::load();
}

#[derive(Debug)]
pub struct Config {
    database_url: String,
}

impl Config {
    fn load() -> Self {
        use util::{get_env_or};
        dotenv::dotenv().ok();

        Config {
            database_url: get_env_or("DATABASE_URL", "".to_string()),
        }
    }
}