# MIT 8103 Advanced Database Systems Portfolio

**Student Name:** Oluwatosin Olufowobi  
**Email:** o.olufowobi3672@miva.edu.ng  
**Programme:** Master of Information Technology (MIT)  
**Academic Session:** 2026/2027 (First Semester Continuous Assessment)  
**Case Study Organisation:** MedCore Specialist Hospital & Diagnostics (Hospital / Clinic Management System)

---

## 1. Case Study Overview

**MedCore Specialist Hospital & Diagnostics** is a multi-branch healthcare provider operating in Lagos (Victoria Island Main Hospital) and Abuja (Garki Diagnostic & Outpatient Clinic). The hospital requires a reliable database architecture to manage patient records, doctor schedules, clinical consultations, pharmacy prescriptions, laboratory investigations, and billing.

- **Database Users:** Medical Records Officers, Doctors/Consultants, Pharmacists, Laboratory Scientists, Billing Officers, and System Administrators.
- **Core Data Stored:** Patient demographics, clinical departments, medical staff, appointment schedules, consultation diagnoses, medication inventory, prescription line items, laboratory test orders/results, and unstructured clinical observation notes.
- **Key Database Operations:**
  1. Register patients and retrieve longitudinal medical history.
  2. Book, reschedule, and prevent double-booking of doctor appointments.
  3. Record diagnoses, order laboratory investigations, and publish verified lab results.
  4. Issue prescriptions with atomic medication stock updates and billing calculation.
  5. Store and query semi-structured clinical vitals, triage notes, and diagnostic attachments.

---

## 2. Repository Structure

```text
advanced-database-portfolio/
├── portfolio-1-database-design/
│   ├── schema.sql
│   ├── sample_data.sql
│   ├── er_diagram.png
│   └── README.md
├── portfolio-2-query-optimisation/
│   ├── queries_and_indexes.sql
│   ├── execution_plans.txt
│   └── README.md
├── portfolio-3-transactions-concurrency/
│   ├── transactions_and_locking.sql
│   ├── concurrency_test_output.txt
│   └── README.md
├── portfolio-4-nosql/
│   ├── clinical_notes_mongodb.js
│   ├── sample_documents.json
│   └── README.md
├── portfolio-5-distributed-cloud/
│   ├── replication_and_sharding.sql
│   ├── docker-compose-cluster.yml
│   └── README.md
└── README.md
```

---

## 3. Summary of Portfolio Components

| Component | Activity | Key Technical Artefacts |
| :--- | :--- | :--- |
| **Portfolio 1** | Database Design and Modelling | 3NF relational schema (`schema.sql`), ER diagram (`er_diagram.png`), primary/foreign keys, domain constraints, and normalisation walk-through. |
| **Portfolio 2** | Query Processing and Optimisation | Analytical and operational SQL queries, `EXPLAIN (ANALYZE, BUFFERS)` execution plans before and after composite B-Tree indexing. |
| **Portfolio 3** | Transactions and Concurrency | ACID prescription dispensing and appointment booking transactions (`COMMIT`, `ROLLBACK`, `SAVEPOINT`), `REPEATABLE READ` isolation, and `SELECT ... FOR UPDATE` row locking. |
| **Portfolio 4** | NoSQL and Advanced Data Models | MongoDB document store for flexible clinical consultation notes, continuous patient vitals, and lab result payloads (`clinical_notes_mongodb.js`). |
| **Portfolio 5** | Distributed and Cloud Database Exercise | Primary-standby streaming replication, declarative range/list partitioning across Lagos and Abuja branches, and CAP/PACELC consistency analysis. |
