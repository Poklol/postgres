-- Query practice against schema.sql after loading sample rows.
-- Customer booking history:
SELECT b.booking_id, r.name AS resource, l.name AS location, b.starts_at, b.ends_at, b.status
FROM bookings b JOIN resources r ON r.resource_id=b.resource_id JOIN locations l ON l.location_id=r.location_id
WHERE b.customer_id=1 ORDER BY b.starts_at DESC;

-- Active booking counts per resource:
SELECT r.resource_id, r.name, COUNT(*) AS active_booking_count
FROM resources r JOIN bookings b ON b.resource_id=r.resource_id
WHERE b.status IN ('pending','confirmed') GROUP BY r.resource_id,r.name ORDER BY active_booking_count DESC;

-- Upcoming confirmed bookings:
SELECT booking_id,resource_id,starts_at,ends_at FROM bookings
WHERE status='confirmed' AND starts_at>=now() ORDER BY starts_at LIMIT 20;

-- Add-on total per booking using historical unit-price snapshots:
SELECT booking_id,SUM(quantity*unit_price) AS add_on_total FROM booking_services GROUP BY booking_id ORDER BY booking_id;
