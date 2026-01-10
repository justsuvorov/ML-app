
import 'package:ml_app/presentation/home/widgets/home_body.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String _title;
  ///
  const HomePage({
    super.key, 
    required String title,
  }) : 
    _title = title;
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: const IconButton(
          icon: Icon(null),
          onPressed: null,
        ),
        title: Text(
          _title, 
          style: const TextStyle(fontFamily: 'GPN_DIN', fontSize: 32),
        ),
        // actions: [],
      ),
      body: HomeBody(),
      backgroundColor: const Color.fromARGB(255, 28, 33, 37),
    );
  }
}