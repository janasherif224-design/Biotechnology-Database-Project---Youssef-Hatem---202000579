DROP TABLE IF EXISTS sample_usage CASCADE;
DROP TABLE IF EXISTS sample_test_requests CASCADE;
DROP TABLE IF EXISTS test_requests CASCADE;
DROP TABLE IF EXISTS test_types CASCADE;
DROP TABLE IF EXISTS aliquots CASCADE;
DROP TABLE IF EXISTS samples CASCADE;
DROP TABLE IF EXISTS storage_locations CASCADE;
DROP TABLE IF EXISTS collection_events CASCADE;
DROP TABLE IF EXISTS sample_types CASCADE;
DROP TABLE IF EXISTS consent_records CASCADE;
DROP TABLE IF EXISTS researchers CASCADE;
DROP TABLE IF EXISTS donors CASCADE;

CREATE TABLE donors (
    donor_id            INTEGER PRIMARY KEY,
    donor_code          VARCHAR(20) NOT NULL UNIQUE,
    first_name          VARCHAR(50) NOT NULL,
    last_name           VARCHAR(50) NOT NULL,
    date_of_birth       DATE NOT NULL,
    sex                 CHAR(1) NOT NULL CHECK (sex IN ('F','M','O')),
    blood_group         VARCHAR(3),
    phone               VARCHAR(20),
    email               VARCHAR(120) UNIQUE,
    enrollment_date     DATE NOT NULL,
    status              VARCHAR(15) NOT NULL DEFAULT 'ACTIVE'
                        CHECK (status IN ('ACTIVE','INACTIVE','WITHDRAWN'))
);

CREATE TABLE researchers (
    researcher_id       INTEGER PRIMARY KEY,
    researcher_code     VARCHAR(20) NOT NULL UNIQUE,
    first_name          VARCHAR(50) NOT NULL,
    last_name           VARCHAR(50) NOT NULL,
    department          VARCHAR(100) NOT NULL,
    email               VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE consent_records (
    consent_id          INTEGER PRIMARY KEY,
    donor_id            INTEGER NOT NULL UNIQUE REFERENCES donors(donor_id),
    consent_date        DATE NOT NULL,
    consent_version     VARCHAR(20) NOT NULL,
    consent_status      VARCHAR(15) NOT NULL
                        CHECK (consent_status IN ('ACTIVE','WITHDRAWN','EXPIRED')),
    allowed_research    BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE sample_types (
    sample_type_id      INTEGER PRIMARY KEY,
    type_name           VARCHAR(50) NOT NULL UNIQUE,
    specimen_category   VARCHAR(50) NOT NULL,
    default_unit        VARCHAR(15) NOT NULL,
    description         VARCHAR(200)
);

CREATE TABLE collection_events (
    collection_id       INTEGER PRIMARY KEY,
    donor_id            INTEGER NOT NULL REFERENCES donors(donor_id),
    collection_date     DATE NOT NULL,
    collection_site     VARCHAR(100) NOT NULL,
    collector_name      VARCHAR(100) NOT NULL,
    collection_notes    VARCHAR(250)
);

CREATE TABLE storage_locations (
    location_id         INTEGER PRIMARY KEY,
    freezer_code        VARCHAR(30) NOT NULL,
    shelf_code          VARCHAR(30) NOT NULL,
    box_code            VARCHAR(30) NOT NULL,
    temperature_c       NUMERIC(5,2) NOT NULL CHECK (temperature_c <= 8),
    status               VARCHAR(15) NOT NULL DEFAULT 'AVAILABLE'
                        CHECK (status IN ('AVAILABLE','FULL','MAINTENANCE')),
    UNIQUE (freezer_code, shelf_code, box_code)
);

CREATE TABLE samples (
    sample_id           INTEGER PRIMARY KEY,
    sample_code         VARCHAR(25) NOT NULL UNIQUE,
    collection_id       INTEGER NOT NULL REFERENCES collection_events(collection_id),
    sample_type_id      INTEGER NOT NULL REFERENCES sample_types(sample_type_id),
    location_id         INTEGER NOT NULL REFERENCES storage_locations(location_id),
    collection_volume_ml NUMERIC(8,2) NOT NULL CHECK (collection_volume_ml > 0),
    available_volume_ml  NUMERIC(8,2) NOT NULL CHECK (available_volume_ml >= 0),
    quality_status      VARCHAR(15) NOT NULL DEFAULT 'ACCEPTED'
                        CHECK (quality_status IN ('ACCEPTED','REJECTED','REVIEW')),
    created_at          DATE NOT NULL,
    CHECK (available_volume_ml <= collection_volume_ml)
);

CREATE TABLE aliquots (
    aliquot_id          INTEGER PRIMARY KEY,
    sample_id           INTEGER NOT NULL REFERENCES samples(sample_id),
    aliquot_code        VARCHAR(25) NOT NULL UNIQUE,
    volume_ml           NUMERIC(8,2) NOT NULL CHECK (volume_ml > 0),
    current_volume_ml   NUMERIC(8,2) NOT NULL CHECK (current_volume_ml >= 0),
    freeze_thaw_count   INTEGER NOT NULL DEFAULT 0 CHECK (freeze_thaw_count >= 0),
    status              VARCHAR(15) NOT NULL DEFAULT 'AVAILABLE'
                        CHECK (status IN ('AVAILABLE','USED','DISCARDED')),
    CHECK (current_volume_ml <= volume_ml)
);

CREATE TABLE test_types (
    test_type_id        INTEGER PRIMARY KEY,
    test_name           VARCHAR(100) NOT NULL UNIQUE,
    department          VARCHAR(80) NOT NULL,
    turnaround_days     INTEGER NOT NULL CHECK (turnaround_days > 0)
);

CREATE TABLE test_requests (
    request_id          INTEGER PRIMARY KEY,
    researcher_id       INTEGER NOT NULL REFERENCES researchers(researcher_id),
    request_date        DATE NOT NULL,
    priority            VARCHAR(10) NOT NULL
                        CHECK (priority IN ('LOW','NORMAL','HIGH','URGENT')),
    purpose             VARCHAR(250) NOT NULL,
    status              VARCHAR(15) NOT NULL DEFAULT 'PENDING'
                        CHECK (status IN ('PENDING','IN_PROGRESS','COMPLETED','CANCELLED'))
);

-- Associative table: one test request can use many samples,
-- and one sample can be linked to many test requests.
CREATE TABLE sample_test_requests (
    sample_id           INTEGER NOT NULL REFERENCES samples(sample_id),
    request_id          INTEGER NOT NULL REFERENCES test_requests(request_id),
    test_type_id        INTEGER NOT NULL REFERENCES test_types(test_type_id),
    requested_volume_ml NUMERIC(8,2) NOT NULL CHECK (requested_volume_ml > 0),
    result_status       VARCHAR(15) NOT NULL DEFAULT 'PENDING'
                        CHECK (result_status IN ('PENDING','PASSED','FAILED','NOT_RUN')),
    PRIMARY KEY (sample_id, request_id)
);

CREATE TABLE sample_usage (
    usage_id            INTEGER PRIMARY KEY,
    aliquot_id          INTEGER NOT NULL REFERENCES aliquots(aliquot_id),
    researcher_id       INTEGER NOT NULL REFERENCES researchers(researcher_id),
    usage_date          DATE NOT NULL,
    volume_used_ml      NUMERIC(8,2) NOT NULL CHECK (volume_used_ml > 0),
    purpose             VARCHAR(250) NOT NULL,
    notes               VARCHAR(250)
);

CREATE INDEX idx_collection_donor ON collection_events(donor_id);
CREATE INDEX idx_samples_type ON samples(sample_type_id);
CREATE INDEX idx_samples_location ON samples(location_id);
CREATE INDEX idx_aliquots_sample ON aliquots(sample_id);
CREATE INDEX idx_requests_researcher ON test_requests(researcher_id);
CREATE INDEX idx_usage_aliquot ON sample_usage(aliquot_id);
CREATE INDEX idx_usage_date ON sample_usage(usage_date);
