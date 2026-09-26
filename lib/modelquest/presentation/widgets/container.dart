// Container(
//   width: double.infinity,
//   height: 240,
//   padding: const EdgeInsets.all(16),
//   decoration: BoxDecoration(
//     color: const Color(0xFFFFFCEE),
//     borderRadius: BorderRadius.circular(12),
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.25),
//         blurRadius: 3,
//         offset: const Offset(0, 3),
//       ),
//     ],
//   ),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       // Título
//       Row(
//         children: [
//           Icon(
//             Icons.edit_note,
//             size: 32,
//             color: const Color(0xFF3A183B),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             'EDQ - Quest R8',
//             style: TextStyle(
//               fontSize: 28,
//               color: const Color(0xFF3A183B),
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ),

//       const SizedBox(height: 14),

//       // Data
//       Text(
//         'Data de criação: 18/02/25',
//         style: TextStyle(
//           fontSize: 18,
//           color: const Color(0xFF3A183B),
//         ),
//       ),

//       const SizedBox(height: 8),

//       // Perguntas
//       Text(
//         'Perguntas: 20',
//         style: TextStyle(
//           fontSize: 18,
//           color: const Color(0xFF3A183B),
//         ),
//       ),

//       const Spacer(),

//       // Ver mais
//       Align(
//         alignment: Alignment.centerRight,
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Ver mais',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF65316A),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Icon(
//               Icons.chevron_right,
//               size: 28,
//               color: const Color(0xFF777777),
//             ),
//           ],
//         ),
//       ),
//     ],
//   ),
// )