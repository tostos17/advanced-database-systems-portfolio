# Portfolio 4: NoSQL and Advanced Data Models

## 1. Suitability of Document Model for Clinical Encounters
While patient identity, appointment slots, pharmacy stock, and billing require strict relational ACID guarantees in PostgreSQL, clinical examination notes vary widely across specialties:
- **Cardiology** encounters record 12-lead ECG parameters and ambulatory blood-pressure arrays.
- **General Medicine** encounters record presenting symptoms and rapid diagnostic test payloads.
- **Paediatrics** encounters record immunisation milestones and growth percentiles.

Storing these specialty-specific payloads as self-contained JSON/BSON documents in MongoDB (`clinical_encounters`) avoids sparse wide tables with dozens of nullable columns or expensive Entity-Attribute-Value (EAV) joins, while allowing single-read retrieval of an entire clinical note by `hospital_no`.
