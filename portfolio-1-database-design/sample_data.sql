-- Sample Seed Data for MedCore Specialist Hospital & Diagnostics

INSERT INTO departments (dept_code, dept_name, branch_code, floor_location) VALUES
('CARD', 'Cardiology', 'LOS-VI', 'Block A, 2nd Floor'),
('GENM', 'Internal & General Medicine', 'LOS-VI', 'Block A, 1st Floor'),
('PAED', 'Paediatrics', 'ABV-GRK', 'Wing B, Ground Floor'),
('PATH', 'Chemical Pathology & Haematology', 'LOS-VI', 'Block C, Ground Floor');

INSERT INTO doctors (staff_no, department_id, first_name, last_name, specialty, mdcn_license_no, phone, email) VALUES
('DOC-1001', 1, 'Adebayo', 'Ogunlesi', 'Consultant Cardiologist', 'MDCN/R/44812', '08032001101', 'a.ogunlesi@medcore.ng'),
('DOC-1002', 2, 'Chidinma', 'Eze', 'Senior Medical Officer', 'MDCN/R/51904', '08032001102', 'c.eze@medcore.ng'),
('DOC-1003', 3, 'Ibrahim', 'Danjuma', 'Consultant Paediatrician', 'MDCN/R/39110', '08032001103', 'i.danjuma@medcore.ng');

INSERT INTO patients (hospital_no, first_name, last_name, date_of_birth, sex, blood_group, genotype, phone, emergency_contact_phone, registered_branch) VALUES
('MCH-2026-0001', 'Ngozi', 'Nwosu', '1984-05-14', 'F', 'O+', 'AA', '08091112201', '08091112202', 'LOS-VI'),
('MCH-2026-0002', 'Tunde', 'Bakare', '1971-11-03', 'M', 'A+', 'AS', '08091112203', '08091112204', 'LOS-VI'),
('MCH-2026-0003', 'Amina', 'Suleiman', '2018-08-22', 'F', 'B+', 'AA', '08091112205', '08091112206', 'ABV-GRK');

INSERT INTO appointments (patient_id, doctor_id, scheduled_start, scheduled_end, visit_type, status) VALUES
(1, 2, '2026-10-12 09:00:00', '2026-10-12 09:30:00', 'Outpatient', 'Completed'),
(2, 1, '2026-10-12 10:00:00', '2026-10-12 10:45:00', 'Specialist', 'Completed'),
(3, 3, '2026-10-13 11:00:00', '2026-10-13 11:30:00', 'Outpatient', 'Scheduled');

INSERT INTO consultations (appointment_id, icd10_code, primary_diagnosis, systolic_bp, diastolic_bp, temperature_c, clinical_summary) VALUES
(1, 'B50.9', 'Uncomplicated Plasmodium falciparum malaria', 118, 76, 38.6, 'Patient presented with 3-day history of fever, headache, and malaise.'),
(2, 'I10', 'Essential (primary) hypertension', 162, 98, 36.8, 'Routine specialist review; elevated blood pressure requiring antihypertensive adjustment.');

INSERT INTO medications (sku_code, generic_name, dosage_form, strength, unit_price_ngn, stock_quantity, reorder_level) VALUES
('MED-ACT-80', 'Artemether / Lumefantrine', 'Tablet', '80mg/480mg', 3500.00, 240, 50),
('MED-PCM-500', 'Paracetamol', 'Tablet', '500mg', 800.00, 600, 100),
('MED-AML-10', 'Amlodipine', 'Tablet', '10mg', 2800.00, 180, 40),
('MED-LIS-20', 'Lisinopril', 'Tablet', '20mg', 3200.00, 150, 40);

INSERT INTO prescriptions (consultation_id, dispensed_status, issued_at, dispensed_at) VALUES
(1, 'Dispensed', '2026-10-12 09:25:00', '2026-10-12 09:42:00'),
(2, 'Pending', '2026-10-12 10:38:00', NULL);

INSERT INTO prescription_items (prescription_id, medication_id, dosage_instruction, duration_days, quantity_prescribed, unit_price_ngn) VALUES
(1, 1, '1 tablet twice daily after meals', 3, 6, 3500.00),
(1, 2, '2 tablets three times daily', 3, 18, 800.00),
(2, 3, '1 tablet once daily in the morning', 30, 30, 2800.00),
(2, 4, '1 tablet once daily in the morning', 30, 30, 3200.00);

INSERT INTO lab_orders (consultation_id, test_code, test_name, priority, order_status, result_value, reference_range, abnormal_flag, ordered_at, completed_at) VALUES
(1, 'MP-RDT', 'Malaria Parasite Microscopy & RDT', 'Urgent', 'Completed', 'Positive (++ P. falciparum)', 'Negative', TRUE, '2026-10-12 09:12:00', '2026-10-12 09:22:00'),
(2, 'LIPID-PNL', 'Fasting Lipid Profile (Total Cholesterol)', 'Routine', 'Completed', '218 mg/dL', '< 200 mg/dL', TRUE, '2026-10-12 10:15:00', '2026-10-12 13:10:00');
