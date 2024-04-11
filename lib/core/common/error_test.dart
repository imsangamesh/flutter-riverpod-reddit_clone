// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  const ErrorText(this.error, {super.key});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error));
  }
}