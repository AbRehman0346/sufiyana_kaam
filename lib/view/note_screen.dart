import 'package:flutter/material.dart';

import '../xutils/widgets/xtext.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late double _screenHeight;
  late double _screenWidth;

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: XText("Note"),),
      body: SizedBox(
        width: _screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTask(),

            buildTask(),
            buildTask(),
          ],
        ),
      ),
    );
  }

  Widget buildTask(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: XText("Crate an App", size: 20,),
    );
  }

  Widget _height(double height) {
    return SizedBox(
      height: height,
    );

  }

  Widget _width(double width) {
    return SizedBox(
      height: width,
    );

  }
}
