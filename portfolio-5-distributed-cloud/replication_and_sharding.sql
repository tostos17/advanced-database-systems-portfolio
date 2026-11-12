-- MIT 8103 Advanced Database Systems
-- Portfolio 5: Distributed and Cloud Database Exercise
-- Case Study: MedCore Specialist Hospital & Diagnostics (Lagos & Abuja Branches)

-- 1. Declarative List Partitioning (Geographic Sharding by Hospital Branch)
CREATE TABLE appointments_distributed (
    appointment_id BIGSERIAL,
    branch_code VARCHAR(10) NOT NULL,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    scheduled_start TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    PRIMARY KEY (branch_code, appointment_id)
) PARTITION BY LIST (branch_code);

-- Shard 1: Lagos Victoria Island Main Hospital Node
CREATE TABLE appointments_lagos_vi
    PARTITION OF appointments_distributed
    FOR VALUES IN ('LOS-VI');

-- Shard 2: Abuja Garki Clinic Node
CREATE TABLE appointments_abuja_grk
    PARTITION OF appointments_distributed
    FOR VALUES IN ('ABV-GRK');

-- 2. Streaming Replication Verification Query (Primary -> Read Replica)
SELECT
    client_addr,
    application_name,
    state,
    sync_state,
    pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn) AS replication_lag_bytes
FROM pg_stat_replication;
