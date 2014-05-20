CREATE DATABASE cseproject
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'English_United States.1252'
       LC_CTYPE = 'English_United States.1252'
       CONNECTION LIMIT = -1;
\connect cseproject
DROP TABLE users CASCADE;
DROP TABLE categories CASCADE;
DROP TABLE products CASCADE;
DROP TABLE transactions CASCADE;

/**table 1: [entity] users**/
CREATE TABLE IF NOT EXISTS users (
    id          SERIAL PRIMARY KEY,
    username        TEXT NOT NULL UNIQUE,
    type        TEXT,
    age     INTEGER,
    state   TEXT
);

/**table 2: [entity] category**/
CREATE TABLE IF NOT EXISTS categories (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    description TEXT
);

/**table 3: [entity] product**/
CREATE TABLE IF NOT EXISTS products (
    id          SERIAL PRIMARY KEY,
    cid         INTEGER REFERENCES categories (id) ON DELETE CASCADE,
    name        TEXT NOT NULL,
    sku         TEXT NOT NULL UNIQUE,
    category    TEXT NOT NULL,
    price       FLOAT NOT NULL
);

/**table 4: [relation] carts**/
CREATE TABLE IF NOT EXISTS transactions (
    id          SERIAL PRIMARY KEY,
    uid         INTEGER REFERENCES users (id) ON DELETE CASCADE,
    pid         INTEGER REFERENCES products (id) ON DELETE CASCADE,
    quantity    INTEGER,
    price       FLOAT
);