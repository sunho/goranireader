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
