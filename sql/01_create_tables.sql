-- Learning exercise: practice CREATE TABLE and basic constraints in a scratch database.
CREATE TABLE practice_customers (customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, email TEXT NOT NULL UNIQUE, full_name TEXT NOT NULL, created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE practice_resources (resource_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, name TEXT NOT NULL, capacity INTEGER NOT NULL CHECK (capacity > 0));
CREATE TABLE practice_bookings (booking_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, customer_id BIGINT NOT NULL REFERENCES practice_customers(customer_id), resource_id BIGINT NOT NULL REFERENCES practice_resources(resource_id), starts_at TIMESTAMPTZ NOT NULL, ends_at TIMESTAMPTZ NOT NULL, CHECK (ends_at > starts_at));
-- Exercises: insert sample rows; JOIN booking to customer/resource; try a bad FK;
-- try capacity=0; explain the constraint errors.
