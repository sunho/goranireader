create table posts (
    id serial primary key,
    user_id integer not null references users on delete cascade,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null
);

create table post_comments (
    id serial primary key,
    user_id integer not null references users on delete cascade,
    post_id integer not null references posts on delete cascade,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    content character varying(4094) not null
);

create view detailed_post_comments as select
    post_comments.*,
    comment_rates.rate
from
    post_comments
left join
 (
  select
    rates.target_id,
    SUM(rates.rate) as rate
    from 
        rates
    where
        rates.kind = 'post_comment'
    group by
        rates.target_id
) comment_rates
on
    post_comments.id = comment_rates.target_id;


create table sentence_posts (
    id integer not null primary key references posts on delete cascade,
    book_id integer not null references books on delete cascade,
    top_content character varying(4094) not null,
    sentence character varying(2048) not null,
    bottom_content character varying(4094) not null,
    solving_content character varying(4094),
    solving_comment integer,
    solved boolean not null
);

create view detailed_sentence_posts as select
    p.created_at,
    p.updated_at,
    p.user_id,
    sentence_posts.*,
    comment_counts.comment_count,
    post_rates.rate
from
    sentence_posts
join
    posts p
on
    sentence_posts.id = p.id
left join
 (
  select
    rates.target_id,
    SUM(rates.rate) as rate
    from 
        rates
    where
        rates.kind = 'post'
    group by
        rates.target_id
) post_rates
on
    sentence_posts.id = post_rates.target_id
left join
 (
  select
    post_comments.post_id,
    COUNT(*) as comment_count
    from 
        post_comments
    group by
        post_comments.post_id
) comment_counts
on
    sentence_posts.id = comment_counts.post_id;

create table feed_posts (
    id uuid not null,
    user_id integer not null references users on delete cascade,
    post_id integer not null references posts on delete cascade,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    primary key (user_id, post_id)
);