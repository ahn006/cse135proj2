CREATE DATABASE cseproject
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'English_United States.1252'
       LC_CTYPE = 'English_United States.1252'
       CONNECTION LIMIT = -1;



CREATE TABLE IF NOT EXISTS users
(
  id serial NOT NULL,
  username text UNIQUE NOT NULL,
  age integer NOT NULL,
  type text NOT NULL,
  state text NOT NULL,
  CONSTRAINT id PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS categories
(
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS products
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  sku INTEGER UNIQUE NOT NULL,
  price DECIMAL(18,2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE IF NOT EXISTS classify
(
  id SERIAL PRIMARY KEY,
  product INTEGER REFERENCES products (ID) NOT NULL,
  category INTEGER REFERENCES categories (ID) NOT NULL
);

CREATE TABLE IF NOT EXISTS transactions
(
  id serial PRIMARY KEY,
  user_id INTEGER REFERENCES users (id) NOT NULL,
  product_id INTEGER REFERENCES products (id) NOT NULL,
  price DECIMAL(18,2) NOT NULL CHECK (price >= 0),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  credit_card INTEGER NOT NULL,
  date timestamp without time zone NOT NULL DEFAULT NOW()
);

