alter table users
add column oauth_id character varying(1024) not null default '';

alter table users
drop column password_hash;