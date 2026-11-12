# Portfolio 5: Distributed and Cloud Database Exercise

## 1. Replication, Sharding & CAP/PACELC Analysis
- **Primary-Standby Streaming Replication:** The Lagos Victoria Island node (`pg-primary-lagos`) streams Write-Ahead Log (WAL) segments to the Abuja Garki standby node (`pg-replica-abuja`). Read-heavy reporting and patient history lookups in Abuja are offloaded to the local read replica.
- **Geographic List Partitioning (`branch_code`):** High-volume operational tables (`appointments_distributed`) are partitioned by `branch_code` (`LOS-VI`, `ABV-GRK`) so 95% of routine clinic queries prune remote partitions automatically.
- **Consistency vs Availability (CAP / PACELC):**
  - **Medication Dispensing & Appointment Booking (CP):** Uses synchronous WAL confirmation to prevent double-booking or negative drug inventory across branches.
  - **Clinical Encounter Notes in MongoDB (AP / Eventual Consistency):** Uses local branch writes (`w: 1`) with asynchronous background replication so doctors can continue recording patient notes even during a temporary Lagos-Abuja WAN link degradation.
