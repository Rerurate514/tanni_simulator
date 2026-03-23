import 'package:flutter/material.dart';

class AppGap extends StatelessWidget {
  const AppGap.xs({super.key}) : size = 8;
  const AppGap.s({super.key}) : size = 16;//余白
  const AppGap.m({super.key}) : size = 24;//セクション
  const AppGap.l({super.key}) : size = 32;//カテゴリ

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size);
  }
}
