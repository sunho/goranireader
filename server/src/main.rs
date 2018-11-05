#![feature(proc_macro_hygiene, custom_attribute, custom_derive, decl_macro, try_trait)]
#![allow(proc_macro_derive_resolution_fallback)] 
#[macro_use]
extern crate rocket;
#[macro_use]
extern crate diesel;
#[macro_use]
extern crate diesel_migrations;
#[macro_use]
extern crate lazy_static;

mod util;
mod config;
mod db;

#[get("/")]
fn index() -> &'static str {
    "Hello, world!"
}

fn main() {
    rocket::ignite().mount("/", routes![index]).launch();
}
