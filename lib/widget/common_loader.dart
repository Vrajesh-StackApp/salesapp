import 'package:flutter/material.dart';

class CommonLoader extends StatelessWidget {
  const CommonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      width: double.infinity,
      height: double.infinity,
      child: const Center(
        child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
