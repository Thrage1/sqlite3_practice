CREATE TABLE plays(
id INTEGER PRIMARY KEY,
title TEXT NOT NULL,
year INTEGER NOT NULL,
playwright_id INTEGER, NOT NULL,
FOREIGN KEY (playwright_id) REFERENCES playwrights(id)
);

CREATE TABLE playwrights(
id INTEGER PRIMARY KEY,
name TEXT NOT NULL,
birth_year INTEGER,
);
