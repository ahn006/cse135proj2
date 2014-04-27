CREATE DATABASE cseproject
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'English_United States.1252'
       LC_CTYPE = 'English_United States.1252'
       CONNECTION LIMIT = -1;
       
CREATE TABLE users
(
  id serial NOT NULL,
  username text NOT NULL,
  age integer NOT NULL,
  type text NOT NULL,
  state text NOT NULL,
  CONSTRAINT id PRIMARY KEY (id)
);