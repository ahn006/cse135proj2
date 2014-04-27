CREATE TABLE users
(
  id serial NOT NULL,
  username text NOT NULL,
  age integer NOT NULL,
  type text NOT NULL,
  state text NOT NULL,
  CONSTRAINT id PRIMARY KEY (id)
);