# Portfolio 3: Transactions and Concurrency

## 1. ACID Properties & Isolation
- **Atomicity & Consistency:** Multi-line prescription dispensing executes inside an explicit transaction block. If any medication violates `CHECK (stock_quantity >= 0)`, the entire transaction rolls back cleanly.
- **Lost-Update & Deadlock Prevention:** Pharmacists lock target medication rows using `SELECT ... FOR UPDATE` ordered by `medication_id ASC`. Ordering row locks deterministically prevents circular wait conditions (deadlocks) when two counters dispense overlapping drug combinations simultaneously.
