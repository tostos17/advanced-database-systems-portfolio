-- MIT 8103 Advanced Database Systems
-- Portfolio 3: Transactions and Concurrency Control
-- Case Study: MedCore Specialist Hospital & Diagnostics

-- =============================================================================
-- SCENARIO 1: Atomic Pharmacy Prescription Dispensing (COMMIT vs ROLLBACK)
-- Ensures medication stock is locked and deducted atomically when dispensing.
-- =============================================================================

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- 1. Acquire row-level exclusive locks on the prescribed medications in deterministic PK order
SELECT medication_id, sku_code, stock_quantity
FROM medications
WHERE medication_id IN (3, 4)
ORDER BY medication_id
FOR UPDATE;

-- 2. Deduct prescribed quantities (30 tablets of Amlodipine 10mg, 30 tablets of Lisinopril 20mg)
UPDATE medications
SET stock_quantity = stock_quantity - 30
WHERE medication_id = 3;

SAVEPOINT after_first_item;

UPDATE medications
SET stock_quantity = stock_quantity - 30
WHERE medication_id = 4;

-- 3. Mark prescription header as Dispensed
UPDATE prescriptions
SET dispensed_status = 'Dispensed',
    dispensed_at = CURRENT_TIMESTAMP
WHERE prescription_id = 2
  AND dispensed_status = 'Pending';

COMMIT;

-- =============================================================================
-- SCENARIO 2: Out-of-Stock Protection Triggering Automatic ROLLBACK
-- =============================================================================

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT medication_id, stock_quantity
FROM medications
WHERE medication_id = 1
FOR UPDATE;

-- Attempting to dispense 500 packs when stock_quantity is 240 violates CHECK (stock_quantity >= 0)
UPDATE medications
SET stock_quantity = stock_quantity - 500
WHERE medication_id = 1;

-- PostgreSQL raises: ERROR: new row for relation "medications" violates check constraint "medications_stock_quantity_check"
ROLLBACK;
