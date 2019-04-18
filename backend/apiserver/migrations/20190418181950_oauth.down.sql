alter table users
add column password_hash character varying(255) not null default '';

alter table users
drop column oauth_id;