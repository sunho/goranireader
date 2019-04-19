alter table users
add column oauth_id character varying(1024) not null default '';

alter table users add constraint users_oauth_id_unique_idx unique (oauth_id);

alter table users
drop column password_hash;