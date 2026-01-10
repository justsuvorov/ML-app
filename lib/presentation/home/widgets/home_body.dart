
import 'package:ml_app/infrastructure/api_query_type/fast_api_query.dart';
import 'package:ml_app/infrastructure/config_data.dart';
import 'package:ml_app/presentation/data/data_page.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class HomeBody extends StatefulWidget {
  ///
  const HomeBody({
    super.key, 
  });
  ///
  @override
  State<HomeBody> createState() => _HomePageState(
  );
}

///
class _HomePageState extends State<HomeBody> {
  final log = Logger('_HomePageState');
  bool _isLoading = false;
  ///
  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }
  ///
  void _updateButtonClick() {
     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ConfigPage(
                        title: "Конфигурация",
                        configData: ConfigData(fastAPIQuery: FastApiQuery(baseUrl: 'http://127.0.0.1:8000',),
                        ),
                      )),
                    );
  }

   void _monitoringButtonClick() {
    
    // TODO method to be implemented...
  }
  void _exploringResultsButtonClick() {
    
    // TODO method to be implemented...
  }
  void _exportResultsButtonClick() {
    
    // TODO method to be implemented...
  }
  ///
  @override
  Widget build(BuildContext context) {
    var buttonStyle = const ButtonStyle(
      backgroundColor: MaterialStatePropertyAll<Color>(Color.fromARGB(255, 2, 108, 189)),
      minimumSize: MaterialStatePropertyAll<Size>(Size(800, 80)),
    // maximumSize: MaterialStatePropertyAll<Size>(Size(500, 80)),
      );
    var textStyle = const TextStyle(
      fontSize: 20,
      fontFamily: 'GPN_DIN',
      color: Colors.white,
    );
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: Wrap(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _updateButtonClick,
                  style: buttonStyle, 
                  child: Text(
                    'Обучение моделей', 
                    style: textStyle,
                  ),
                ),
                
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _monitoringButtonClick, 
                  style: buttonStyle,
                  child: Text('Мониторинг моделей и данных', style: textStyle,),
                  
                ),
                const SizedBox(height: 100),
               
                ElevatedButton(
                  onPressed: _exploringResultsButtonClick,
                  style: buttonStyle,
                  child: Text('Просмотр результатов',style: textStyle,),
                ),
                const SizedBox(height: 50),
                
                ElevatedButton(
                  onPressed: _exportResultsButtonClick,
                  style: buttonStyle,
                  child: Text('Экспорт результатов', style: textStyle,),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
