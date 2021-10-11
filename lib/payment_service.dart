import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:collection/collection.dart';

class InAppPurchaseService with ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  bool available = true;
  StreamSubscription<List<PurchaseDetails>>? subscription;
  final String myProductID = 'product_id';

  bool _isPurchased = false;
  bool get isPurchased => _isPurchased;

  set isPurchased(bool value) {
    _isPurchased = value;
    notifyListeners();
  }

  List<PurchaseDetails> _purchases = [];
  List<PurchaseDetails> get purchases => _purchases;

  set purchases(List<PurchaseDetails> value) {
    _purchases = value;
    notifyListeners();
  }

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;
  set products(List<ProductDetails> value) {
    _products = value;
    notifyListeners();
  }

  void initialize() async {
    available = await _iap.isAvailable();
    if (available) {
      await _getProducts();

      subscription = _iap.purchaseStream.listen(
        onListenPurchase,
        onDone: () {
          subscription?.cancel();
        },
        onError: (error) {},
      );

      await _iap.restorePurchases();
    }
  }

  void onListenPurchase(purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        debugPrint("IAP" "Purchase is still pending!");
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint("IAP" "An error has occurred!");
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        debugPrint("IAP" "Purchased or restored successfully!");

        await InAppPurchase.instance.completePurchase(purchaseDetails);
        isPurchased = true;
        debugPrint("IAP" "Purchase marked as completed");
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        isPurchased = true;
        debugPrint("IAP" "Purchase marked as completed");
      }
    });
    notifyListeners();
  }

  Future<void> verifyPurchase() async {
    PurchaseDetails? purchase = hasPurchased(myProductID);
    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      isPurchased = true;
    }

    debugPrint("IAP ${purchase?.status}");
    notifyListeners();
  }

  Future<bool> buyProduct() async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: products.first);
    final result = await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    return result;
  }

  PurchaseDetails? hasPurchased(String productID) {
    return purchases
        .firstWhereOrNull((purchase) => purchase.productID == productID);
  }

  Future<void> _getProducts() async {
    Set<String> ids = {myProductID};
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    products = response.productDetails;
  }
}
