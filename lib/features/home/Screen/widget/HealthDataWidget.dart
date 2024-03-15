import 'package:flutter/material.dart';

class HealthDataWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const HealthDataWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}