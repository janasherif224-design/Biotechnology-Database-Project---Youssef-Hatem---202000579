-- 1. Basic retrieval: active donors
SELECT donor_code, first_name, last_name, status
FROM donors
WHERE status = 'ACTIVE'
ORDER BY donor_code;

-- 2. JOIN: show samples with donor and storage information
SELECT s.sample_code, d.donor_code, d.first_name || ' ' || d.last_name AS donor_name,
       st.type_name, sl.freezer_code, sl.shelf_code, sl.box_code
FROM samples s
JOIN collection_events ce ON ce.collection_id = s.collection_id
JOIN donors d ON d.donor_id = ce.donor_id
JOIN sample_types st ON st.sample_type_id = s.sample_type_id
JOIN storage_locations sl ON sl.location_id = s.location_id
ORDER BY s.sample_id;

-- 3. JOIN across the many-to-many relationship
SELECT tr.request_id, tr.priority, r.researcher_code,
       s.sample_code, tt.test_name, str.requested_volume_ml, str.result_status
FROM test_requests tr
JOIN researchers r ON r.researcher_id = tr.researcher_id
JOIN sample_test_requests str ON str.request_id = tr.request_id
JOIN samples s ON s.sample_id = str.sample_id
JOIN test_types tt ON tt.test_type_id = str.test_type_id
ORDER BY tr.request_id;

-- 4. Aggregation: number of samples by sample type
SELECT st.type_name, COUNT(*) AS sample_count,
       SUM(s.available_volume_ml) AS total_available_volume
FROM sample_types st
JOIN samples s ON s.sample_type_id = st.sample_type_id
GROUP BY st.type_name
ORDER BY sample_count DESC, st.type_name;

-- 5. Aggregation: usage by researcher
SELECT r.researcher_code,
       r.first_name || ' ' || r.last_name AS researcher_name,
       COUNT(su.usage_id) AS usage_events,
       SUM(su.volume_used_ml) AS total_volume_used
FROM researchers r
LEFT JOIN sample_usage su ON su.researcher_id = r.researcher_id
GROUP BY r.researcher_id, r.researcher_code, r.first_name, r.last_name
ORDER BY total_volume_used DESC NULLS LAST;

-- 6. Subquery: donors whose samples have been used
SELECT donor_code, first_name, last_name
FROM donors
WHERE donor_id IN (
    SELECT ce.donor_id
    FROM collection_events ce
    JOIN samples s ON s.collection_id = ce.collection_id
    JOIN aliquots a ON a.sample_id = s.sample_id
    JOIN sample_usage su ON su.aliquot_id = a.aliquot_id
)
ORDER BY donor_code;

-- 7. Nested query: researchers with above-average usage events
SELECT researcher_code, first_name, last_name
FROM researchers
WHERE researcher_id IN (
    SELECT researcher_id
    FROM sample_usage
    GROUP BY researcher_id
    HAVING COUNT(*) > (
        SELECT AVG(usage_count)
        FROM (
            SELECT COUNT(*) AS usage_count
            FROM sample_usage
            GROUP BY researcher_id
        ) x
    )
);

-- 8. INSERT test: add a new test request
INSERT INTO test_requests
(request_id, researcher_id, request_date, priority, purpose, status)
VALUES
(11, 1, CURRENT_DATE, 'NORMAL', 'Demonstration request for database testing', 'PENDING');

-- 9. UPDATE test: change request 11 to HIGH priority
UPDATE test_requests
SET priority = 'HIGH'
WHERE request_id = 11;

-- 10. DELETE test: remove the demonstration request
DELETE FROM test_requests
WHERE request_id = 11;

-- 11. View 1
SELECT * FROM sample_inventory
ORDER BY sample_id;

-- 12. View 2
SELECT * FROM pending_test_requests
ORDER BY priority DESC, request_date;

-- 13. Trigger test that SHOULD FAIL.
-- Run this statement by itself after the load script:
-- INSERT INTO sample_usage
-- (usage_id, aliquot_id, researcher_id, usage_date, volume_used_ml, purpose)
-- VALUES (99, 3, 1, CURRENT_DATE, 999, 'Intentional constraint test');

-- Expected result: an exception saying that there is insufficient aliquot volume.

-- 14. Trigger success test
-- Remove a previous demo row if this script is being re-run.
DELETE FROM sample_usage WHERE usage_id = 100;

INSERT INTO sample_usage
(usage_id, aliquot_id, researcher_id, usage_date, volume_used_ml, purpose)
VALUES (100, 12, 2, CURRENT_DATE, 0.5, 'Trigger demonstration');

-- Check the automatically updated aliquot volume
SELECT aliquot_id, aliquot_code, volume_ml, current_volume_ml, status
FROM aliquots
WHERE aliquot_id = 12;

-- Optional cleanup after the trigger demonstration:
-- DELETE FROM sample_usage WHERE usage_id = 100;
