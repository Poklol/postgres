# PostgreSQL Booking & Reservations

A learning project to design, explain and validate a PostgreSQL booking schema.

## Deliverables
- Complete schema: [schema.sql](schema.sql)
- ERD source: [erd.dbml](erd.dbml)
- Design explanation: [docs/database-design.md](docs/database-design.md)
- SQL exercises: [sql/](sql/)
- Public dbdiagram.io URL: **pending publication** — import `erd.dbml` at https://dbdiagram.io/ and replace this note with the share URL.
- ERD image: **pending export** — export the diagram as PNG and commit it as `erd.png`.

## Run the schema
On a fresh PostgreSQL database, using an account with permission to create the `btree_gist` extension:

```bash
psql -v ON_ERROR_STOP=1 -f schema.sql
```

## Design summary
Tables model customers, locations, resources, bookings, booking status history, reusable services and the booking/service junction. A GiST exclusion constraint prevents overlapping pending or confirmed bookings for the same resource. See the design document for normalization, FK rationale, indexing and tradeoffs.

## Learning and daily commits
Work through the provided YouTube videos first, then the Udemy course. Commit genuine progress daily; do not backdate or fabricate activity. Suggested messages: `learn: practice SELECT and filtering`, `schema: add booking constraints`, `docs: explain normalization and indexes`.

## Learning plan
1. Day 1: relational databases, tables, columns, data types, SELECT.
2. Day 2: WHERE, ORDER BY, LIMIT, NULL, basic functions.
3. Day 3: INSERT, UPDATE, DELETE, transactions.
4. Day 4: primary keys, foreign keys, UNIQUE, NOT NULL, CHECK.
5. Day 5: one-to-many and many-to-many relationships; ERD.
6. Day 6: joins, aggregates, GROUP BY, HAVING.
7. Day 7: normalization (1NF–3NF), design review.
8. Day 8: indexes and EXPLAIN.
9. Day 9: timestamps, range types, exclusion constraints.
10. Day 10: transactions, concurrent booking tests, validation and final documentation.

Record the actual lesson/section and exercises completed in each day's commit message or a learning log; the sequence can be stretched to match the course pace.
