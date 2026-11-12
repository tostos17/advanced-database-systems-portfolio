-- MIT 8103 Advanced Database Systems
-- Portfolio 1: Database Design and Modelling
-- Case Study: MedCore Specialist Hospital & Diagnostics
-- Target DBMS: PostgreSQL 16

DROP TABLE IF EXISTS lab_orders CASCADE;
DROP TABLE IF EXISTS prescription_items CASCADE;
DROP TABLE IF EXISTS prescriptions CASCADE;
DROP TABLE IF EXISTS medications CASCADE;
DROP TABLE IF EXISTS consultations CASCADE;
DROP TABLE IF EXISTS appointments CASCADE;
DROP TABLE IF EXISTS patients CASCADE;
DROP TABLE IF EXISTS doctors CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

-- 1. Clinical Departments
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    dept_code VARCHAR(10) NOT NULL UNIQUE,
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    branch_code VARCHAR(10) NOT NULL CHECK (branch_code IN ('LOS-VI', 'ABV-GRK')),
    floor_location VARCHAR(40) NOT NULL
);

-- 2. Medical Doctors / Consultants
CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    staff_no VARCHAR(20) NOT NULL UNIQUE,
    department_id INT NOT NULL REFERENCES departments(department_id) ON DELETE RESTRICT,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    specialty VARCHAR(80) NOT NULL,
    mdcn_license_no VARCHAR(30) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    active_status BOOLEAN NOT NULL DEFAULT TRUE
);

-- 3. Patients
CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    hospital_no VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    date_of_birth DATE NOT NULL CHECK (date_of_birth <= CURRENT_DATE),
    sex CHAR(1) NOT NULL CHECK (sex IN ('M', 'F')),
    blood_group VARCHAR(3) CHECK (blood_group IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    genotype VARCHAR(3) CHECK (genotype IN ('AA', 'AS', 'SS', 'AC')),
    phone VARCHAR(20) NOT NULL,
    emergency_contact_phone VARCHAR(20) NOT NULL,
    registered_branch VARCHAR(10) NOT NULL CHECK (registered_branch IN ('LOS-VI', 'ABV-GRK')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4. Appointments
CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES patients(patient_id) ON DELETE RESTRICT,
    doctor_id INT NOT NULL REFERENCES doctors(doctor_id) ON DELETE RESTRICT,
    scheduled_start TIMESTAMP NOT NULL,
    scheduled_end TIMESTAMP NOT NULL,
    visit_type VARCHAR(30) NOT NULL CHECK (visit_type IN ('Outpatient', 'Follow-Up', 'Emergency', 'Specialist')),
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled'
        CHECK (status IN ('Scheduled', 'Checked-In', 'Completed', 'Cancelled', 'No-Show')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_appointment_window CHECK (scheduled_end > scheduled_start),
    CONSTRAINT uq_doctor_slot UNIQUE (doctor_id, scheduled_start)
);

-- 5. Clinical Consultations (1-to-1 with Completed/Checked-In Appointment)
CREATE TABLE consultations (
    consultation_id SERIAL PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE REFERENCES appointments(appointment_id) ON DELETE RESTRICT,
    icd10_code VARCHAR(10) NOT NULL,
    primary_diagnosis VARCHAR(200) NOT NULL,
    systolic_bp SMALLINT CHECK (systolic_bp BETWEEN 50 AND 260),
    diastolic_bp SMALLINT CHECK (diastolic_bp BETWEEN 30 AND 160),
    temperature_c NUMERIC(4,1) CHECK (temperature_c BETWEEN 34.0 AND 43.0),
    clinical_summary TEXT NOT NULL,
    recorded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 6. Medication Catalogue & Pharmacy Inventory
CREATE TABLE medications (
    medication_id SERIAL PRIMARY KEY,
    sku_code VARCHAR(25) NOT NULL UNIQUE,
    generic_name VARCHAR(120) NOT NULL,
    dosage_form VARCHAR(40) NOT NULL CHECK (dosage_form IN ('Tablet', 'Capsule', 'Syrup', 'Injection', 'Inhaler')),
    strength VARCHAR(40) NOT NULL,
    unit_price_ngn NUMERIC(10,2) NOT NULL CHECK (unit_price_ngn >= 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    reorder_level INT NOT NULL DEFAULT 50 CHECK (reorder_level >= 0)
);

-- 7. Prescriptions Header
CREATE TABLE prescriptions (
    prescription_id SERIAL PRIMARY KEY,
    consultation_id INT NOT NULL REFERENCES consultations(consultation_id) ON DELETE RESTRICT,
    dispensed_status VARCHAR(20) NOT NULL DEFAULT 'Pending'
        CHECK (dispensed_status IN ('Pending', 'Dispensed', 'Cancelled')),
    issued_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dispensed_at TIMESTAMP
);

-- 8. Prescription Line Items (Resolves M:N between Prescriptions and Medications)
CREATE TABLE prescription_items (
    prescription_item_id SERIAL PRIMARY KEY,
    prescription_id INT NOT NULL REFERENCES prescriptions(prescription_id) ON DELETE CASCADE,
    medication_id INT NOT NULL REFERENCES medications(medication_id) ON DELETE RESTRICT,
    dosage_instruction VARCHAR(120) NOT NULL,
    duration_days SMALLINT NOT NULL CHECK (duration_days BETWEEN 1 AND 365),
    quantity_prescribed INT NOT NULL CHECK (quantity_prescribed > 0),
    unit_price_ngn NUMERIC(10,2) NOT NULL CHECK (unit_price_ngn >= 0),
    CONSTRAINT uq_prescription_med UNIQUE (prescription_id, medication_id)
);

-- 9. Laboratory Test Orders & Results
CREATE TABLE lab_orders (
    lab_order_id SERIAL PRIMARY KEY,
    consultation_id INT NOT NULL REFERENCES consultations(consultation_id) ON DELETE RESTRICT,
    test_code VARCHAR(20) NOT NULL,
    test_name VARCHAR(120) NOT NULL,
    priority VARCHAR(15) NOT NULL DEFAULT 'Routine' CHECK (priority IN ('Routine', 'Urgent', 'STAT')),
    order_status VARCHAR(20) NOT NULL DEFAULT 'Requested'
        CHECK (order_status IN ('Requested', 'Sample-Collected', 'Completed', 'Cancelled')),
    result_value VARCHAR(100),
    reference_range VARCHAR(60),
    abnormal_flag BOOLEAN DEFAULT FALSE,
    ordered_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);
