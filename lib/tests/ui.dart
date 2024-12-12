// import 'package:be_fit/extensions/routes.dart';
// import 'package:be_fit/models/widgets/app_button.dart';
// import 'package:be_fit/models/widgets/modules/myText.dart';
// import 'package:be_fit/tests/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class Test1 extends StatelessWidget {
//   const Test1({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           MyText(text: context.watch<TestBloc>().counter.toString()),
//
//           AppButton(text: 'Count',onPressed: context.read<TestBloc>().inc),
//
//           AppButton(text: 'Go',onPressed: () => context.normalNewRoute(BlocProvider.value(
//
//               value: BlocProvider.of<TestBloc>(context),
//               child: const Test2())),)
//         ],
//       ),
//     );
//   }
// }
//
// class Test2 extends StatelessWidget {
//   const Test2({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => TestBloc(),
//       child: Scaffold(
//         appBar: AppBar(),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             MyText(text: context.watch<TestBloc>().counter.toString()),
//             AppButton(text: 'Go',onPressed: () => context.normalNewRoute(BlocProvider.value(
//               value: BlocProvider.of<TestBloc>(context),
//                 child: const Test3())),)
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class Test3 extends StatelessWidget {
//   const Test3({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => TestBloc(),
//       child: Scaffold(
//         appBar: AppBar(),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             MyText(text: context.watch<TestBloc>().counter.toString()),
//             // AppButton(text: 'Go',onPressed: () => context.normalNewRoute(Test2()),)
//           ],
//         ),
//       ),
//     );
//   }
// }
//
