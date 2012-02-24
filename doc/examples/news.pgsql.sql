CREATE TABLE news (
  news_id           serial,
  title             varchar(100) not null,
  posted_on         datetime not null,
  posted_by         int not null,
  content           text null,
  section           varchar(25) null,
  active            char(3) default 'no',
  expires_on        datetime null,
  primary key( news_id )
)