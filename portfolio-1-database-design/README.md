# Portfolio 1: Database Design and Modelling

## 1. Entity-Relationship Design
The MedCore Specialist Hospital schema models nine core relations:
- `departments` (1) to `doctors` (M)
- `patients` (1) to `appointments` (M)
- `doctors` (1) to `appointments` (M)
- `appointments` (1) to `consultations` (0..1)
- `consultations` (1) to `prescriptions` (M) and `lab_orders` (M)
- `prescriptions` (M) to `medications` (M), resolved via the associative entity `prescription_items`.

## 2. Normalisation to Third Normal Form (3NF / BCNF)
1. **First Normal Form (1NF):** Multi-valued repeating groups (such as multiple drugs prescribed in a single consultation or multiple lab tests ordered) were decomposed into `prescription_items` and `lab_orders` so every attribute holds an atomic value.
2. **Second Normal Form (2NF):** In the associative table `prescription_items`, attributes that depend only on `medication_id` (`generic_name`, `dosage_form`, `strength`, `stock_quantity`) were moved to `medications`. Only attributes dependent on the full composite relationship (`prescription_id`, `medication_id`) remain in `prescription_items`.
3. **Third Normal Form (3NF):** Transitive dependencies such as `doctor_id -> department_id -> (dept_name, branch_code, floor_location)` were removed by separating `departments` from `doctors`.
