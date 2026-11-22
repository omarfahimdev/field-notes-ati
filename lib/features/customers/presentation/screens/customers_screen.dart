import 'package:flutter/material.dart';

class CustomersScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Customers Screen')));
  }
}
