# PostgreSQL Booking & Reservations

A learning project to design, explain and validate a PostgreSQL booking schema.

## Deliverables
- Complete schema: [schema.sql](schema.sql)
- ERD source: [erd.dbml](erd.dbml)
- Design explanation: [docs/database-design.md](docs/database-design.md)
- SQL learning exercises: [sql/](sql/)
- Validation checks: [sql/03_schema_validation.sql](sql/03_schema_validation.sql)
- Learning progress: [docs/learning-log.md](docs/learning-log.md)
- Public dbdiagram.io URL: **pending publication**. Import `erd.dbml` at https://dbdiagram.io/, publish/share the diagram, then replace this note with its public URL.
- ERD image: **pending export**. Export the diagram as PNG and commit it as `erd.png`.

## Run the schema on a fresh database

Create or connect to an empty PostgreSQL database. The account needs permission to install the `btree_gist` extension.

```bash
psql -v ON_ERROR_STOP=1 -f schema.sql
```

Then run the validation script against that database:

```bash
psql -v ON_ERROR_STOP=1 -f sql/03_schema_validation.sql
```

The validation script uses a transaction and rolls back its sample data. It checks valid inserts, adjacent time slots, overlapping active bookings, and basic foreign-key integrity. Run it only after `schema.sql`.

## Design summary

The seven tables model customers, locations, resources, bookings, booking status history, reusable services and the booking/service junction. A GiST exclusion constraint prevents overlapping pending or confirmed bookings for the same resource. See [the design document](docs/database-design.md) for table rationale, FK rationale, normalization, indexing and tradeoffs.

## Learning and daily commits

Work through the eight supplied YouTube resources first, then complete the Udemy course. Commit genuine learning progress daily; do not backdate commits or claim lessons completed unless you actually completed them. Keep a record of the actual lesson/section and exercises completed in [the learning log](docs/learning-log.md).

Suggested commit messages:
- `learn: practice SELECT and filtering`
- `learn: practice joins and aggregates`
- `schema: add booking constraints`
- `test: validate booking time constraints`
- `docs: explain normalization and indexes`

## Suggested learning sequence

1. Relational database concepts, tables, columns, data types and SELECT.
2. WHERE, ORDER BY, LIMIT, NULL and basic functions.
3. INSERT, UPDATE, DELETE and transactions.
4. Primary keys, foreign keys, UNIQUE, NOT NULL and CHECK.
5. One-to-many and many-to-many relationships; ERD.
6. Joins, aggregates, GROUP BY and HAVING.
7. Normalization (1NF–3NF) and design review.
8. Indexes and EXPLAIN.
9. Timestamps, range types and exclusion constraints.
10. Transactions, concurrent booking tests, validation and final documentation.
