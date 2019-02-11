CREATE TABLE books (
    id serial primary key,
    name character varying(1024) NOT NULL,
    epub character varying(1024) NOT NULL,
    img character varying(1024) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);