# Portfolio 2: Query Processing and Optimisation

## 1. Overview
This directory contains operational and analytical SQL queries for MedCore Specialist Hospital along with PostgreSQL `EXPLAIN (ANALYZE, BUFFERS)` execution plans before and after indexing.

## 2. Key Optimisations Applied
1. **Partial B-Tree Index (`idx_lab_orders_active_urgent`):** Because over 99% of historical rows in `lab_orders` have `order_status = 'Completed'`, indexing only uncompleted `Urgent`/`STAT` rows keeps the index footprint under 64 KB while serving the laboratory bench dashboard in `2.614 ms` instead of `47.385 ms`.
2. **Covering Composite Index (`idx_appointments_status_start`):** Includes `(patient_id, doctor_id)` as payload columns (`INCLUDE`) to enable Index-Only Scans when filtering appointments by status and date range.
