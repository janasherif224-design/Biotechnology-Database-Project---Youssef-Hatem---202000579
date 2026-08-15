CREATE OR REPLACE VIEW sample_inventory AS
SELECT
    s.sample_id,
    s.sample_code,
    d.donor_code,
    st.type_name AS sample_type,
    s.collection_volume_ml,
    s.available_volume_ml,
    s.quality_status,
    sl.freezer_code,
    sl.shelf_code,
    sl.box_code,
    sl.temperature_c
FROM samples s
JOIN collection_events ce ON ce.collection_id = s.collection_id
JOIN donors d ON d.donor_id = ce.donor_id
JOIN sample_types st ON st.sample_type_id = s.sample_type_id
JOIN storage_locations sl ON sl.location_id = s.location_id;

CREATE OR REPLACE VIEW pending_test_requests AS
SELECT
    tr.request_id,
    tr.request_date,
    tr.priority,
    tr.status,
    r.researcher_code,
    r.first_name || ' ' || r.last_name AS researcher_name,
    COUNT(str.sample_id) AS linked_sample_count
FROM test_requests tr
JOIN researchers r ON r.researcher_id = tr.researcher_id
LEFT JOIN sample_test_requests str ON str.request_id = tr.request_id
WHERE tr.status IN ('PENDING','IN_PROGRESS')
GROUP BY tr.request_id, tr.request_date, tr.priority, tr.status,
         r.researcher_code, r.first_name, r.last_name;
