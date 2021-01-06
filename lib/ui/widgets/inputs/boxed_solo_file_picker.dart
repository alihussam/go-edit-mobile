// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:goedit/utils/file_helper.dart';

// class BoxedSoloFilePicker extends StatefulWidget {
//   final void Function(File) onFileSelect;
//   final String placeHolderText;

//   BoxedSoloFilePicker({this.placeHolderText, this.onFileSelect});

//   @override
//   _BoxedSoloFilePickerState createState() => _BoxedSoloFilePickerState();
// }

// class _BoxedSoloFilePickerState extends State<BoxedSoloFilePicker> {
//   StreamController<File> _selfStateController = StreamController<File>();

//   @override
//   void dispose() {
//     _selfStateController.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: FlatButton(
//         padding: EdgeInsets.all(0),
//         onPressed: () async {
//           File file = await FileHelper.pickFile();
//           if (file != null) {
//             _selfStateController.sink.add(file);
//             widget.onFileSelect(file);
//           }
//         },
//         child: StreamBuilder(
//           stream: _selfStateController.stream,
//           builder: (context, snapshot) {
//             if (snapshot.hasData && snapshot.data != null) {
//               return Container(
//                 height: 180,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Container(
//                       height: 30,
//                       child: Center(
//                         child: Text(
//                           widget.placeHolderText,
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 150,
//                       child: Center(
//                         child: Column(
//                           children: [
//                             Icon(
//                               Icons.file_present,
//                               size: 20,
//                             ),
//                             SizedBox(height: 10),
//                             Text(snapshot.data.path.split('/').last),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
//             return Container(
//               height: 150,
//               // decoration: BoxDecoration(
//               //   image: DecorationImage(
//               //     fit: BoxFit.cover,
//               //     image: AssetImage('assets/images/placeholder.jpg'),
//               //   ),
//               // ),
//               child: Center(
//                 child: Text(
//                   widget.placeHolderText,
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
