create table user_tokens (
    id uuid not null,
    user_id integer not null references users on delete cascade,
    buf character varying(4096) not null,
    primary key (user_id)
);

