var listpaciente = <Map<String,Object>>[
  {
    "surname": "Rodriguez", 
    "code": "911-02-0747",
    "name": "Emiliano", 
    "id": 1
  },
  {
    "surname": "Rojas Olivero", 
    "code": "727-08-2005",
    "name": "Luis Miguel", 
    "id": 2
  },
  {
    "surname": "Rojas Olivero", 
    "code": "020-12-2000",
    "name": "Eliana", 
    "id": 3
  }
];

var listMedcinas = <Map<String, Object>> [
  {
    "id": 1,
    "name": "Loratadina Boin Capsulas",
    "dosage": 11.0,
    "start_date": "2024-09-11",
    "treatment_duration": 30,
    "patient_id": 1
  },

  {
    "id": 2,
    "name": "Broxol Jarabe",
    "dosage": 1.0,
    "start_date": "2024-11-11",
    "treatment_duration": 40,
    "patient_id": 1
  },

  {
    "id": 3,
    "name": "Citrizina Pastillas",
    "dosage": 0.1,
    "start_date": "2024-10-30",
    "treatment_duration": 30,
    "patient_id": 1
  },

  {
    "id": 4,
    "name": "ANTHELIOS PIGMENTATION FPS 50+",
    "dosage": 3.0,
    "start_date": "2024-11-04",
    "treatment_duration": 30,
    "patient_id": 1
  }
];

var listPosologias = <Map<String, Object>>[
  {
    "id": 1,
    "hour": 6,
    "minute": 0,
    "medication_id": 1
  },
  {
    "id": 2,
    "hour": 12,
    "minute": 0,
    "medication_id": 1
  },
  {
    "id": 3,
    "hour": 18,
    "minute": 0,
    "medication_id": 1
  },
  {
    "id": 4,
    "hour": 5,
    "minute": 30,
    "medication_id": 2
  },
  {
    "id": 5,
    "hour": 9,
    "minute": 0,
    "medication_id": 2
  },
  {
    "id": 6,
    "hour": 13,
    "minute": 0,
    "medication_id": 2
  },
  {
    "id": 7,
    "hour": 17,
    "minute": 0,
    "medication_id": 2
  },
  {
    "id": 8,
    "hour": 21,
    "minute": 0,
    "medication_id": 2
  },
  {
    "id": 9,
    "hour": 4,
    "minute": 0,
    "medication_id": 3
  },
  {
    "id": 10,
    "hour": 14,
    "minute": 30,
    "medication_id": 3
  },
  {
    "id": 11,
    "hour": 23,
    "minute": 0,
    "medication_id": 3
  },
  {
    "id": 12,
    "hour": 3,
    "minute": 0,
    "medication_id": 4
  },
  {
    "id": 13,
    "hour": 11,
    "minute": 30,
    "medication_id": 4
  },
  {
    "id": 14,
    "hour": 20,
    "minute": 0,
    "medication_id": 4
  }
];

var listintakes = <Map<String, Object>>[
  {
    "id": 1,
    "date": "2024-09-11T06:00",
    "medication_id": 1
  },
  {
    "id": 2,
    "date": "2024-09-11T12:00",
    "medication_id": 1
  },
  {
    "id": 3,
    "date": "2024-09-11T18:00",
    "medication_id": 1
  },
  {
    "id": 4,
    "date": "2024-11-11T05:30",
    "medication_id": 2
  },
  {
    "id": 5,
    "date": "2024-11-11T09:00",
    "medication_id": 2
  },
  {
    "id": 6,
    "date": "2024-11-11T13:00",
    "medication_id": 2
  },
  {
    "id": 7,
    "date": "2024-11-11T17:00",
    "medication_id": 2
  },
  {
    "id": 8,
    "date": "2024-11-11T21:00",
    "medication_id": 2
  },
  {
    "id": 9,
    "date": "2024-10-30T04:00",
    "medication_id": 3
  },
  {
    "id": 10,
    "date": "2024-10-30T14:30",
    "medication_id": 3
  },
  {
    "id": 11,
    "date": "2024-10-30T23:00",
    "medication_id": 3
  },
  {
    "id": 12,
    "date": "2024-11-04T03:00",
    "medication_id": 4
  },
  {
    "id": 13,
    "date": "2024-11-04T11:30",
    "medication_id": 4
  },
  {
    "id": 14,
    "date": "2024-11-04T20:00",
    "medication_id": 4
  },
  {
    "id": 15,
    "date": "2024-11-12T06:00",
    "medication_id": 1
  },
  {
    "id": 16,
    "date": "2024-11-12T12:00",
    "medication_id": 1
  },
  {
    "id": 17,
    "date": "2024-11-12T18:00",
    "medication_id": 1
  },
  {
    "id": 18,
    "date": "2024-11-15T05:30",
    "medication_id": 2
  },
  {
    "id": 19,
    "date": "2024-11-15T13:00",
    "medication_id": 2
  },
  {
    "id": 20,
    "date": "2024-11-15T21:00",
    "medication_id": 2
  },
  {
    "id": 21,
    "date": "2024-11-20T09:00",
    "medication_id": 2
  },
  {
    "id": 22,
    "date": "2024-11-20T17:00",
    "medication_id": 2
  },
  {
    "id": 23,
    "date": "2024-11-25T05:30",
    "medication_id": 2
  },
  {
    "id": 24,
    "date": "2024-11-25T13:00",
    "medication_id": 2
  },
  {
    "id": 25,
    "date": "2024-11-26T21:00",
    "medication_id": 2
  },
  {
    "id": 26,
    "date": "2024-11-28T05:30",
    "medication_id": 2
  },
  {
    "id": 27,
    "date": "2024-11-28T13:00",
    "medication_id": 2
  }
];

var listintakesDetail= <Map<String, Object>>[
  {
    "id": 1,
    "name": "Loratadina Boin Capsulas",
    "dosage": 11.0,
    "start_date": "2024-09-11",
    "treatment_duration": 30,
    "patient_id": 1,
    "posologies_by_medication": [
      {"id": 1, "hour": 6, "minute": 0, "medication_id": 1},
      {"id": 2, "hour": 12, "minute": 0, "medication_id": 1},
      {"id": 3, "hour": 18, "minute": 0, "medication_id": 1}
    ],
    "intakes_by_medication": [
      {"id": 1, "date": "2024-09-11T06:00", "medication_id": 1},
      {"id": 2, "date": "2024-09-11T12:00", "medication_id": 1},
      {"id": 3, "date": "2024-09-11T18:00", "medication_id": 1},
      {"id": 15, "date": "2024-11-12T06:00", "medication_id": 1},
      {"id": 16, "date": "2024-11-12T12:00", "medication_id": 1},
      {"id": 17, "date": "2024-11-12T18:00", "medication_id": 1}
    ]
  },
  {
    "id": 2,
    "name": "Broxol Jarabe",
    "dosage": 1.0,
    "start_date": "2024-11-11",
    "treatment_duration": 40,
    "patient_id": 1,
    "posologies_by_medication": [
      {"id": 4, "hour": 5, "minute": 30, "medication_id": 2},
      {"id": 5, "hour": 9, "minute": 0, "medication_id": 2},
      {"id": 6, "hour": 13, "minute": 0, "medication_id": 2},
      {"id": 7, "hour": 17, "minute": 0, "medication_id": 2},
      {"id": 8, "hour": 21, "minute": 0, "medication_id": 2}
    ],
    "intakes_by_medication": [
      {"id": 4, "date": "2024-11-11T05:30", "medication_id": 2},
      {"id": 5, "date": "2024-11-11T09:00", "medication_id": 2},
      {"id": 6, "date": "2024-11-11T13:00", "medication_id": 2},
      {"id": 7, "date": "2024-11-11T17:00", "medication_id": 2},
      {"id": 8, "date": "2024-11-11T21:00", "medication_id": 2},
      {"id": 18, "date": "2024-11-15T05:30", "medication_id": 2},
      {"id": 19, "date": "2024-11-15T13:00", "medication_id": 2},
      {"id": 20, "date": "2024-11-15T21:00", "medication_id": 2},
      {"id": 21, "date": "2024-11-20T09:00", "medication_id": 2},
      {"id": 22, "date": "2024-11-20T17:00", "medication_id": 2},
      {"id": 23, "date": "2024-11-25T05:30", "medication_id": 2},
      {"id": 24, "date": "2024-11-25T13:00", "medication_id": 2},
      {"id": 25, "date": "2024-11-26T21:00", "medication_id": 2},
      {"id": 26, "date": "2024-11-28T05:30", "medication_id": 2},
      {"id": 27, "date": "2024-11-28T13:00", "medication_id": 2}
    ]
  },
  {
    "id": 3,
    "name": "Citrizina Pastillas",
    "dosage": 0.1,
    "start_date": "2024-10-30",
    "treatment_duration": 30,
    "patient_id": 1,
    "posologies_by_medication": [
      {"id": 9, "hour": 4, "minute": 0, "medication_id": 3},
      {"id": 10, "hour": 14, "minute": 30, "medication_id": 3},
      {"id": 11, "hour": 23, "minute": 0, "medication_id": 3}
    ],
    "intakes_by_medication": [
      {"id": 9, "date": "2024-10-30T04:00", "medication_id": 3},
      {"id": 10, "date": "2024-10-30T14:30", "medication_id": 3},
      {"id": 11, "date": "2024-10-30T23:00", "medication_id": 3}
    ]
  },
  {
    "id": 4,
    "name": "ANTHELIOS PIGMENTATION FPS 50+",
    "dosage": 3.0,
    "start_date": "2024-11-04",
    "treatment_duration": 30,
    "patient_id": 1,
    "posologies_by_medication": [
      {"id": 12, "hour": 3, "minute": 0, "medication_id": 4},
      {"id": 13, "hour": 11, "minute": 30, "medication_id": 4},
      {"id": 14, "hour": 20, "minute": 0, "medication_id": 4}
    ],
    "intakes_by_medication": [
      {"id": 12, "date": "2024-11-04T03:00", "medication_id": 4},
      {"id": 13, "date": "2024-11-04T11:30", "medication_id": 4},
      {"id": 14, "date": "2024-11-04T20:00", "medication_id": 4}
    ]
  }
];