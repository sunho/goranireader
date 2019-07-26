drop view detailed_memories;

alter table memories
add column rate double precision not null default 0;