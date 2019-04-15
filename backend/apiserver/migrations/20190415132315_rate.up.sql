ALTER TABLE rates
ADD COLUMN created_at timestamp without time zone not null default now();

ALTER TABLE rates
ADD COLUMN updated_at timestamp without time zone not null default now();