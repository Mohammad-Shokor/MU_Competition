// import 'package:codit_competition/Trivia/CreateChallenge.dart';
// import 'package:codit_competition/Trivia/teams.dart';
// import 'package:codit_competition/screens/default_Competition_Start_Screen.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'LeaderBoardScreen.dart';

// class Startscreen extends StatefulWidget {
//   const Startscreen({super.key});

//   @override
//   State<Startscreen> createState() => _StartscreenState();
// }

// class _StartscreenState extends State<Startscreen> {
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;

//     return width < 700
//         ? DefaultCompetitionStartScreen()
//         : Scaffold(
//           body: Stack(
//             children: [
//               Lottie.asset(
//                 "assets/Background.json",
//                 width: width,
//                 height: height,
//                 fit: BoxFit.cover,
//               ),
//               Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 30),
//                     magicalContainer(
//                       width,
//                       Text(
//                         "Trivia",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: width > 700 ? 60 : 40,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     competitionButton(
//                       context,
//                       "Try Demo",

//                       content: "Trivia MUBC x Code_it; 2025",
//                     ),
//                     competitionButton(context, "", returnValue),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//   }

//   ElevatedButton competitionButton(
//     BuildContext context,
//     String header,
//     Widget returnValue, {
//     String content = "",
//   }) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.black.withOpacity(0.4),
//       ),

//       onPressed: () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) {
//               return returnValue;
//             },
//           ),
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Text(header, style: TextStyle(color: Colors.white, fontSize: 30)),
//             Text(
//               content,
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.white, fontSize: 12),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Container magicalContainer(double width, Widget child) {
//     return Container(
//       width: width > 700 ? 300 : 200,
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.4),
//         border: Border.all(),
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: child,
//     );
//   }
// }
