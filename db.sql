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

CREATE TABLE categories
(
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  description TEXT NOT NULL
);

CREATE TABLE products
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  sku INTEGER UNIQUE NOT NULL,
  price DECIMAL(18,2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE classify
(
  id SERIAL PRIMARY KEY,
  product INTEGER REFERENCES products (ID) NOT NULL,
  category INTEGER REFERENCES categories (ID) NOT NULL
);

