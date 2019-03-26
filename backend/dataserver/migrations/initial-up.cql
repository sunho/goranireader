create keyspace gorani with replication = {'class':'SimpleStrategy','replication_factor':1};

use gorani;

create table words (
    word varchar,
    pron varchar,
    primary key (word, pron)
);

create table word_defs (
    word varchar,
    id int,
    def varchar,
    pos varchar,
    primary key (word, id, def)
);

create table book_words (
    book_id int,
    word varchar,
    n int,
    primary key (book_id, word)
);

create table known_words (
    user_id int,
    word varchar,
    n int,
    primary key (user_id, word)
);