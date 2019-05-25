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

create table experienced_books (
    user_id int,
    book_id int,
    primary key (user_id, book_id)
);
