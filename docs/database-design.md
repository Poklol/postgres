# Booking & Reservations Database Design

## Subsystem overview
This subsystem lets customers reserve a resource at a location for a time interval, optionally add services, and review status changes over time. PostgreSQL enforces data integrity and prevents two active bookings from overlapping on the same resource.

## Table-by-table rationale
- **customers**: customer identity and contact details, reused across many bookings.
- **locations**: independently managed sites with addresses and time zones; each may contain many resources.
- **resources**: individually bookable assets, separated from locations because a location can contain multiple assets.
- **bookings**: central reservation record identifying customer, resource, time interval and current status.
- **booking_status_history**: separate history rows preserve multiple transitions rather than overwriting prior state.
- **services**: reusable optional add-ons and their current default prices.
- **booking_services**: junction table resolves the many-to-many relationship between bookings and services, with quantity and agreed unit-price snapshot.

## Foreign keys and why they exist
- `resources.location_id -> locations.location_id`: every resource belongs to a location.
- `bookings.customer_id -> customers.customer_id`: every booking has a customer; customers can make multiple bookings.
- `bookings.resource_id -> resources.resource_id`: each booking reserves a resource, which can be booked at other times.
- `booking_status_history.booking_id -> bookings.booking_id`: every history entry belongs to a booking.
- `booking_status_history.changed_by_customer_id -> customers.customer_id`: identifies the actor when a customer initiated a change; NULL permits system actions.
- `booking_services.booking_id -> bookings.booking_id`: associates an add-on selection with its booking.
- `booking_services.service_id -> services.service_id`: identifies the reusable service selected.

## Tradeoff
The current status is stored on `bookings` for fast reads, while `booking_status_history` stores transitions. An alternative is deriving the current status from the latest history row, which avoids duplicate representation but complicates and may slow common booking-list queries. Application code should update both in one transaction; a trigger or stored procedure could enforce this in a production extension.

## Normalization
The design targets 3NF: customer details, location details, resource details and service catalogue details each live in their own tables. `booking_services` resolves the many-to-many relationship rather than repeating service columns on bookings. `unit_price` is a deliberate historical snapshot so later changes to a service's default price do not rewrite past bookings.

## Indexing
Primary keys and unique constraints create indexes automatically. Explicit indexes support location joins, customer booking history, resource schedules, status/date filtering, history timelines and service lookups. Indexes speed reads but cost storage and writes; add more only after checking representative queries with `EXPLAIN (ANALYZE, BUFFERS)`.

## Time overlap rule
`bookings_no_active_overlap` uses `btree_gist` and a GiST exclusion constraint on resource equality and overlapping half-open timestamp ranges. `[start, end)` permits adjacent bookings but rejects overlaps. Pending and confirmed bookings block time; cancelled, completed and no-show bookings do not. `TIMESTAMPTZ` stores unambiguous instants, while the location time zone is used for display.

## Validation
On a fresh PostgreSQL database, with permission to install `btree_gist`, run `psql -v ON_ERROR_STOP=1 -f schema.sql`. The script creates an enum, seven tables, constraints and indexes in a transaction.
