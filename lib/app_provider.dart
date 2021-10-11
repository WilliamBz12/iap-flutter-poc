import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iap_flutter/payment_service.dart';

final iapProvider = ChangeNotifierProvider.autoDispose<InAppPurchaseService>(
    (ref) => InAppPurchaseService());
