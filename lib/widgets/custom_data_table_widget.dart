// // ignore_for_file: deprecated_member_use
//
// import 'package:flutter/material.dart';
// import 'package:forms_project/models/event/event_info_model.dart';
//
// class DataTableWidget extends StatelessWidget {
//   final List<EventInfoModel?> dataList;
//
//   // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
//   DataTableWidget({required this.dataList});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.transparent,
//       child: DataTable(
//         dataRowHeight: MediaQuery.of(context).size.height * 0.125,
//         columns: const [
//           DataColumn(
//             label: Text(
//               'Evento',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           DataColumn(
//             label: Text(
//               'Estado',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           DataColumn(
//             label: Text(
//               'Monto máximo',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           DataColumn(
//             label: Text(
//               'Tipo de pago VIP',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           DataColumn(
//             label: Text(
//               'Categoria de comercio (No aplica)',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           DataColumn(
//             label: Text(
//               'Entregable',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           DataColumn(
//             label: Text(
//               'Fecha de inicio',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           DataColumn(
//             label: Text(
//               'Fecha de fin',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//         rows: dataList.map((data) {
//           return DataRow(cells: [
//             DataCell(Text(
//               data?.name ?? 'N/A',
//               style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
//             )),
//             DataCell(Text(
//               data?.status ?? 'N/A',
//               style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
//             )),
//             DataCell(Text(
//               data?.maxAmount.toString() ?? 'N/A',
//               style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
//             )),
//             DataCell(Text(
//               data?.paymentTypeVip[0].paymentTypeName ?? 'N/A',
//               style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
//             )),
//             DataCell(
//               Container(
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.2, // Set fixed height
//                 ),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: (data?.commerceCategories as List<dynamic>).map((category) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 2.0), // Optional: spacing between items
//                         child: Text(
//                           category['name'] ?? 'N/A',
//                           style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ),
//             DataCell(Text(
//               data?.deliveryType ?? 'N/A',
//               style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
//             )),
//             DataCell(Text(
//               formatDate(data?.startDate ?? 'N/A'),
//               style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
//             )),
//             DataCell(Text(
//               formatDate(data?.endDate ?? 'N/A'),
//               style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
//             )),
//           ], color: MaterialStateProperty.all(Colors.transparent));
//         }).toList(),
//         headingRowColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
//         dataRowColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
//         dividerThickness: 0.5,
//         horizontalMargin: 0,
//         columnSpacing: 20,
//         decoration: const BoxDecoration(
//           border: Border(
//               bottom: BorderSide(color: Colors.white, width: 0.5)
//           ),
//         ),
//       ),
//     );
//   }
//
//   String formatDate(String dateString) {
//     try {
//       DateTime dateTime = DateTime.parse(dateString);
//       String year = dateTime.year.toString();
//       String month = dateTime.month.toString().padLeft(2, '0');
//       String day = dateTime.day.toString().padLeft(2, '0');
//       return '$year-$month-$day';
//     } catch (e) {
//       return 'N/A';
//     }
//   }
//
// }
