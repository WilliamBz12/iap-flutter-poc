import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_provider.dart';

class AppPurchase extends StatefulWidget {
  const AppPurchase({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  _AppPurchaseState createState() => _AppPurchaseState();
}

class _AppPurchaseState extends State<AppPurchase> {
  @override
  void initState() {
    super.initState();
    context.read(iapProvider).initialize();
  }

  @override
  void dispose() {
    super.dispose();
    context.read(iapProvider).subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
