create table similar_wards (
    id uuid not null,
    word character varying(100) not null,
    other_word character varying(100) not null,
    kind character varying(100) not null,
    score integer not null,
    primary key (word, kind, other_word)
);