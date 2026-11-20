// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:medquest/firebase_options.dart';



// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   final firestore = FirebaseFirestore.instance;
//   final batch = firestore.batch();

//   const patients = [
//     // {
//     //   'birthDate': '1985-04-12T10:30:00.000000',
//     //   'birthPlacement': 'Hospital',
//     //   'comorbidities': ['Hypertension'],
//     //   'drugs': ['Sertraline'],
//     //   'educationLevel': 'Bachelor',
//     //   'elitism': 'Low',
//     //   'ethnicity': 'Caucasian',
//     //   'exitReason': null,
//     //   'height': 175.0,
//     //   'income': 50000.0,
//     //   'name': 'Jonas',
//     //   'occupation': 'Engineer',
//     //   'participationStatus': true,
//     //   'researchAttributes': {},
//     //   'sex': 'Masculino',
//     //   'smokingLevel': 'never',
//     //   'treatmentStartAge': 50,
//     //   'weight': 70.0,
//     // },
//     {
//       'birthDate': '1992-08-21T14:15:00.000000',
//       'birthPlacement': 'Hospital',
//       'comorbidities': ['Asthma'],
//       'drugs': ['Salbutamol'],
//       'educationLevel': 'Master',
//       'elitism': 'Medium',
//       'ethnicity': 'Asian',
//       'exitReason': null,
//       'height': 162.0,
//       'income': 65000.0,
//       'name': 'Mariana',
//       'occupation': 'Psychologist',
//       'participationStatus': true,
//       'researchAttributes': {},
//       'sex': 'Feminino',
//       'smokingLevel': 'never',
//       'treatmentStartAge': 31,
//       'weight': 58.0,
//     },
//     {
//       'birthDate': '1978-02-05T08:45:00.000000',
//       'birthPlacement': 'Home',
//       'comorbidities': ['Diabetes'],
//       'drugs': ['Metformin'],
//       'educationLevel': 'HighSchool',
//       'elitism': 'High',
//       'ethnicity': 'Black',
//       'exitReason': 'Completed',
//       'height': 180.0,
//       'income': 42000.0,
//       'name': 'Carlos',
//       'occupation': 'Teacher',
//       'participationStatus': false,
//       'researchAttributes': {},
//       'sex': 'Masculino',
//       'smokingLevel': 'former',
//       'treatmentStartAge': 45,
//       'weight': 82.0,
//     },
//     {
//       'birthDate': '2000-11-17T16:20:00.000000',
//       'birthPlacement': 'Hospital',
//       'comorbidities': [],
//       'drugs': [],
//       'educationLevel': 'Bachelor',
//       'elitism': 'Low',
//       'ethnicity': 'Mixed',
//       'exitReason': null,
//       'height': 168.0,
//       'income': 36000.0,
//       'name': 'Beatriz',
//       'occupation': 'Designer',
//       'participationStatus': true,
//       'researchAttributes': {},
//       'sex': 'Feminino',
//       'smokingLevel': 'never',
//       'treatmentStartAge': 24,
//       'weight': 62.0,
//     },
//     {
//       'birthDate': '1969-06-30T12:00:00.000000',
//       'birthPlacement': 'Hospital',
//       'comorbidities': ['Hypertension', 'Insomnia'],
//       'drugs': ['Losartan', 'Melatonin'],
//       'educationLevel': 'Doctorate',
//       'elitism': 'Medium',
//       'ethnicity': 'Caucasian',
//       'exitReason': 'Withdrawn',
//       'height': 172.0,
//       'income': 85000.0,
//       'name': 'Roberto',
//       'occupation': 'Physician',
//       'participationStatus': false,
//       'researchAttributes': {},
//       'sex': 'Masculino',
//       'smokingLevel': 'former',
//       'treatmentStartAge': 52,
//       'weight': 76.0,
//     },
//   ];

//   for (final patient in patients) {
//     final docRef = firestore.collection('Research').doc('RjLSlXYoZjbocCPObGEG').collection('Group').doc('placebo').collection('Patient').doc();

//     batch.set(docRef, patient);
//   }

//   await batch.commit();

// }
