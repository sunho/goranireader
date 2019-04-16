alter table rates
add column created_at timestamp without time zone not null default now();

alter table rates
add column updated_at timestamp without time zone not null default now();