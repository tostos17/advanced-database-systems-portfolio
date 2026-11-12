// MIT 8103 Advanced Database Systems
// Portfolio 4: NoSQL and Advanced Data Models (MongoDB 7.0)
// Case Study: MedCore Specialist Hospital & Diagnostics

use medcore_clinical_nosql;

// 1. Insert polymorphic clinical encounter notes & continuous bedside vitals
db.clinical_encounters.insertMany([
  {
    _id: "ENC-2026-000101",
    consultation_id: 1,
    hospital_no: "MCH-2026-0001",
    branch_code: "LOS-VI",
    specialty: "General Medicine",
    attending_doctor: "DOC-1002",
    recorded_at: ISODate("2026-10-12T09:20:00Z"),
    triage_vitals: {
      bp_systolic: 118,
      bp_diastolic: 76,
      pulse_bpm: 92,
      temp_celsius: 38.6,
      spo2_percent: 98
    },
    presenting_complaints: [
      { symptom: "Fever", duration_days: 3, severity: "Moderate" },
      { symptom: "Frontal headache", duration_days: 2, severity: "Mild" }
    ],
    rapid_diagnostics: {
      malaria_rdt: "Positive (P. falciparum)",
      packed_cell_volume_pct: 39
    },
    clinical_tags: ["malaria", "outpatient", "febrile-illness"]
  },
  {
    _id: "ENC-2026-000102",
    consultation_id: 2,
    hospital_no: "MCH-2026-0002",
    branch_code: "LOS-VI",
    specialty: "Cardiology",
    attending_doctor: "DOC-1001",
    recorded_at: ISODate("2026-10-12T10:30:00Z"),
    triage_vitals: {
      bp_systolic: 162,
      bp_diastolic: 98,
      pulse_bpm: 78,
      temp_celsius: 36.8,
      spo2_percent: 97
    },
    ecg_summary: {
      rhythm: "Sinus rhythm",
      ventricular_rate_bpm: 78,
      qrs_duration_ms: 94,
      interpretation: "Mild left ventricular hypertrophy strain pattern"
    },
    ambulatory_bp_readings: [
      { time: "06:00", sys: 158, dia: 96 },
      { time: "12:00", sys: 164, dia: 100 },
      { time: "18:00", sys: 154, dia: 94 }
    ],
    clinical_tags: ["hypertension", "cardiology", "ecg-review"]
  }
]);

// 2. Create compound index for patient longitudinal timeline lookup
db.clinical_encounters.createIndex({ hospital_no: 1, recorded_at: -1 });

// 3. Aggregation pipeline: Flag encounters with hypertensive crisis or high-grade fever
db.clinical_encounters.aggregate([
  {
    $match: {
      $or: [
        { "triage_vitals.bp_systolic": { $gte: 160 } },
        { "triage_vitals.temp_celsius": { $gte: 38.5 } }
      ]
    }
  },
  {
    $project: {
      _id: 1,
      hospital_no: 1,
      specialty: 1,
      bp_systolic: "$triage_vitals.bp_systolic",
      temp_celsius: "$triage_vitals.temp_celsius",
      clinical_tags: 1
    }
  }
]);
