
CREATE TABLE plays (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  year INTEGER NOT NULL,
  playwright_id INTEGER NOT NULL,
  FOREIGN KEY (playwright_id) REFERENCES playwrights(id)
);

CREATE TABLE playwrights (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  birth_year INTEGER
);

INSERT INTO
  playwrights(name, birth_year)
VALUES
  ('Franz Kafka', 1955),
  ('Terry Goodkind', 1967);

INSERT INTO
  plays(title, year, playwright_id)
VALUES
  ('Wizard''s First Rule', 1999, (select id from playwrights where name = 'Terry Goodkind')),
  ('The Cockaroach', 1966, (select id from playwrights where name = 'Franz Kafka'));
