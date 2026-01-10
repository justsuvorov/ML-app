
import 'package:flutter/material.dart';

class DropDownContainer extends StatelessWidget {
  final Map<String, dynamic> data;
  const DropDownContainer({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = data.entries.map<Widget>((entry) {
      Widget w = Row(
        children: [
          Text(entry.key.toString()),
          const Spacer(),
          Text(entry.value.toString()),
        ],
      );
      return w;
    }).toList();

    return Column(
      /// children: [
      ///   Expanded(
      ///       child: Container(
      ///     color: Colors.red,
      ///     height: 50,
      ///   )),
      /// ],
      children: children,
    );
  }
}

