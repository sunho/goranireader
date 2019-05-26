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
use gorani;

create table books (
    id int,
    name varchar,
    content list<varchar>,
    primary key (id, name)
);

create table book_similarity (
    id int,
    other_id int,
    value double,
    primary key (id, other_id)
);
use gorani;

drop table book_similarity;

create table book_similarity (
    id int,
    type varchar,
    other_id int,
    value double,
    primary key (id, type, other_id)
);

use gorani;

create table user_event_logs (
    id uuid,
    user_id int,
    day timestamp,
    kind varchar,
    time timestamp,
    payload text,
    primary key ((user_id, day), id, time)
);

use gorani;

create table user_flipped_paragraphs (
    id uuid,
    user_id int,
    time timestamp,
    interval double,
    paragraph blob,
    primary key (user_id, id, time)
);

create table user_known_words (
    user_id int,
    word varchar,
    score counter,
    primary key (user_id, word)
);

use gorani;

create table cluster_books (
    cluster int,
    id int,
    primary key (cluster, id)
);

create table book_cluster (
    id int,
    cluster int,
    primary key (id, cluster)
);

create table user_auwpps (
    user_id int,
    book_id int,
    auwpp float,
    primary key (user_id, book_id)
);

create table readable_books (
    user_id int,
    book_id int,
    primary key (user_id, book_id)
);

create table completed_books (
    user_id int,
    book_id int,
    primary key (user_id, book_id)
);

crete table experienced_books (
    user_id int,
    book_id int,
    primary key (user_id, book_id)
);

create table book_estimated_time (
	user_id int,
	book_id int,
	total_words int,
	estimated_time float,
    primary key (user_id, book_id)
);

