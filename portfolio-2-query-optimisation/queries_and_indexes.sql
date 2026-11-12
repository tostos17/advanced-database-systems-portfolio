-- MIT 8103 Advanced Database Systems
-- Portfolio 2: Query Processing and Optimisation
-- Case Study: MedCore Specialist Hospital & Diagnostics

-- Query 1: Retrieve Patient Clinical & Prescription History with Total Medication Spend
SELECT
    p.hospital_no,
    p.first_name || ' ' || p.last_name AS patient_name,
    d.last_name AS doctor_last_name,
    dept.dept_name,
    a.scheduled_start,
    c.icd10_code,
    c.primary_diagnosis,
    COALESCE(SUM(pi.quantity_prescribed * pi.unit_price_ngn), 0) AS total_drug_cost_ngn
FROM patients p
JOIN appointments a ON a.patient_id = p.patient_id
JOIN doctors d ON d.doctor_id = a.doctor_id
JOIN departments dept ON dept.department_id = d.department_id
JOIN consultations c ON c.appointment_id = a.appointment_id
LEFT JOIN prescriptions pr ON pr.consultation_id = c.consultation_id
LEFT JOIN prescription_items pi ON pi.prescription_id = pr.prescription_id
WHERE a.scheduled_start >= '2026-01-01 00:00:00'
  AND a.scheduled_start <  '2026-12-31 23:59:59'
  AND a.status = 'Completed'
GROUP BY
    p.hospital_no, p.first_name, p.last_name,
    d.last_name, dept.dept_name, a.scheduled_start,
    c.icd10_code, c.primary_diagnosis
ORDER BY a.scheduled_start DESC;

-- Query 2: Pending Urgent/STAT Laboratory Turnaround Queue
SELECT
    lo.lab_order_id,
    lo.test_code,
    lo.test_name,
    lo.priority,
    lo.ordered_at,
    p.hospital_no,
    p.first_name || ' ' || p.last_name AS patient_name,
    d.last_name AS ordering_doctor
FROM lab_orders lo
JOIN consultations c ON c.consultation_id = lo.consultation_id
JOIN appointments a ON a.appointment_id = c.appointment_id
JOIN patients p ON p.patient_id = a.patient_id
JOIN doctors d ON d.doctor_id = a.doctor_id
WHERE lo.order_status IN ('Requested', 'Sample-Collected')
  AND lo.priority IN ('Urgent', 'STAT')
ORDER BY lo.ordered_at ASC;

-- Performance Optimisation Indexes
-- 1. Composite covering index for completed appointment date-range scans
CREATE INDEX idx_appointments_status_start
    ON appointments (status, scheduled_start DESC)
    INCLUDE (patient_id, doctor_id);

-- 2. Partial index for active urgent/STAT lab queue lookups
CREATE INDEX idx_lab_orders_active_urgent
    ON lab_orders (ordered_at ASC)
    WHERE order_status IN ('Requested', 'Sample-Collected')
      AND priority IN ('Urgent', 'STAT');

-- 3. Foreign-key join indexes on high-cardinality child tables
CREATE INDEX idx_prescriptions_consultation ON prescriptions (consultation_id);
CREATE INDEX idx_prescription_items_presc   ON prescription_items (prescription_id);
