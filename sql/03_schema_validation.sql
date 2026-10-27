-- Booking schema validation checks.
-- Prerequisite: run schema.sql against an empty test database first.
-- This script rolls back all sample data when successful.
\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE
  v_customer_id BIGINT;
  v_location_id BIGINT;
  v_resource_id BIGINT;
  v_service_id BIGINT;
  v_booking_id BIGINT;
BEGIN
  INSERT INTO customers (email, full_name)
  VALUES ('schema-check@example.invalid', 'Schema Check')
  RETURNING customer_id INTO v_customer_id;

  INSERT INTO locations (name, address_line, city, country_code, timezone)
  VALUES ('Schema Check Location', '1 Test Road', 'Chennai', 'IN', 'Asia/Kolkata')
  RETURNING location_id INTO v_location_id;

  INSERT INTO resources (location_id, name, resource_type, capacity)
  VALUES (v_location_id, 'Schema Check Room', 'room', 1)
  RETURNING resource_id INTO v_resource_id;

  INSERT INTO services (name, default_price)
  VALUES ('Schema Check Service', 10.00)
  RETURNING service_id INTO v_service_id;

  INSERT INTO bookings (customer_id, resource_id, starts_at, ends_at, status)
  VALUES (v_customer_id, v_resource_id, '2035-01-01 10:00+05:30',
          '2035-01-01 11:00+05:30', 'confirmed')
  RETURNING booking_id INTO v_booking_id;

  INSERT INTO booking_services (booking_id, service_id, quantity, unit_price)
  VALUES (v_booking_id, v_service_id, 1, 10.00);

  -- Adjacent half-open intervals are allowed.
  INSERT INTO bookings (customer_id, resource_id, starts_at, ends_at, status)
  VALUES (v_customer_id, v_resource_id, '2035-01-01 11:00+05:30',
          '2035-01-01 12:00+05:30', 'confirmed');

  -- An overlapping active booking must fail with exclusion_violation.
  BEGIN
    INSERT INTO bookings (customer_id, resource_id, starts_at, ends_at, status)
    VALUES (v_customer_id, v_resource_id, '2035-01-01 10:30+05:30',
            '2035-01-01 11:30+05:30', 'confirmed');
    RAISE EXCEPTION 'Validation failed: overlapping active booking was accepted';
  EXCEPTION
    WHEN exclusion_violation THEN
      RAISE NOTICE 'PASS: overlapping active booking rejected';
  END;

  -- Cancelled bookings do not block a time slot.
  INSERT INTO bookings (customer_id, resource_id, starts_at, ends_at, status,
                        cancellation_reason)
  VALUES (v_customer_id, v_resource_id, '2035-01-01 10:15+05:30',
          '2035-01-01 10:45+05:30', 'cancelled', 'Test cancellation');

  -- An invalid resource foreign key must fail.
  BEGIN
    INSERT INTO bookings (customer_id, resource_id, starts_at, ends_at, status)
    VALUES (v_customer_id, -999999, '2035-01-02 10:00+05:30',
            '2035-01-02 11:00+05:30', 'pending');
    RAISE EXCEPTION 'Validation failed: invalid resource foreign key was accepted';
  EXCEPTION
    WHEN foreign_key_violation THEN
      RAISE NOTICE 'PASS: invalid resource foreign key rejected';
  END;

  RAISE NOTICE 'PASS: valid booking, add-on, adjacent interval and cancellation checks';
END $$;

ROLLBACK;
