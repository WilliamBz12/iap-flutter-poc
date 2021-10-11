import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iap_flutter/app_provider.dart';
import 'package:iap_flutter/payment_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ProviderListener<InAppPurchaseService>(
        provider: iapProvider,
        onChange: (context, value) {
          if (value.isPurchased) {
            showDialog(
              context: context,
              builder: (_) => const AlertDialog(
                title: Text("Agora você é PRO"),
              ),
            );
          }
        },
        child: Consumer(
          builder: (context, watch, child) {
            var provider = watch(iapProvider);
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Comprar produto",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Divider(),
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 20,
                  ),
                  !provider.isPurchased
                      ? provider.available
                          ? const Text("produto disponivel")
                          : const Text(
                              "Recursos indisponiveis",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.green,
                              ),
                            )
                      : const Text("já possui o plano PRO"),
                  for (var prod in provider.products)
                    if (provider.hasPurchased(prod.id) != null) ...[
                      const Center(
                        child: FittedBox(
                          child: Text(
                            'Obrigado por comprar nosso relatório <3',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 60, color: Colors.black),
                          ),
                        ),
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: () {
                          context.read(iapProvider).buyProduct();
                        },
                        child: const Text("COMPRAR"),
                      ),
                    ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
