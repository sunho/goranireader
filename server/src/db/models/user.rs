use db::schema::users;

#[derive(Debug, Identifiable, Queryable, Insertable)]
pub struct User {
    pub id: i32,
    pub name: String,
    pub password_hash: String,
}