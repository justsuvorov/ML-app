import 'package:ml_app/infrastructure/config_data.dart';
import 'package:ml_app/presentation/data/widgets/config_data_body.dart';
import 'package:ml_app/presentation/home/home_page.dart';
import 'package:flutter/material.dart';


class ConfigPage extends StatelessWidget {
  final String _title;
  final ConfigData _configData;
  ///
  const ConfigPage({
    Key? key,
    required String title,
    required ConfigData configData,
  }) : 
    _title = title, 
    _configData = configData,
    super(key: key);
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("home"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      title: 'OutboxML',
                      ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: ConfigDataBody(
        configData: _configData,
      ),
    );
  }
}