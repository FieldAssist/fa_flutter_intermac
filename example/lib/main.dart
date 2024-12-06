import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:honnywellintermecpr3/honnywellintermecpr3.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? error = null;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intermec Testing '),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (error != null)
            Text(
              error!,
              textAlign: TextAlign.center,
            ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: loading
                ? const CircularProgressIndicator.adaptive()
                : OutlinedButton(
                    onPressed: () async {
                      try {
                        //commande to send to printer
                        var cmd = [
                          // "setBold;true",
                          // "setDoubleHigh;true",
                          // "setDoubleWide;true",
                          // "write;Test news",
                          // "setBold;false",
                          // "setDoubleHigh;false",
                          // "setDoubleWide;false",
                          // "newLine;2",
                          // "newLine;2",
                          // "write;ok",
                          // "newLine;2",
                          // "newLine;2",
                          // "offset;80",
                          "width;550",
                          "heigh;500",
                          // "image;iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAIAAAD/gAIDAAAB8klEQVR4nO2dS27DMAwF697/zumCmwL9WCNR5JPz5gIixxMgsI3ker1eH2aMz+4BTsKyAJYFsCyAZQEsC2BZAMsCWBZAVNZ1Xd0j/IKoLE0UZUVWgnEpypJFTtb3oNTikpOljJasnylJxaUlSxwhWX9FpBOXkCx9VGT9n49IXCqyjkBC1kg4CnFJyDqFflnjybTH1S/rIJpl0Vh643JZgE5Zc5k0xuWyAG2yVgLpistlAXpkrafREpfLAjTIyoqiPi6XBaiWlZtDcVwuC1Aqa0cIlXG5LECdrH0JlMXlsgBFsnZf/Jq4XBagQlbNZS84xWUBtsuq/B60+yyXBdgrq/7GwNYTXRZgo6yuO+X7znVZgF2yeh8dbzrdZQG2yGp/3WXTDC4LkC9LIasgfRKXBUiWpZNVkDuPywJkylLLKkicymUB0mRpZhVkzeayADmylLMKUiZ0WYAEWfpZBetzuizAqqxTsgoWp3VZgCVZZ2UVrMzssgDzsk7MKpie3GUBJmWdm1UwN7/LAszIOj2rYGILlwXAsp6RVUB3cVkAJutJWQVoI5cFALKel1UwvpfLAozKempWweB2LgswJOvZWQUjO7oswL2sd8gquN3UZQFuZL1PVsHNj1r676/G8ccQYFkAywJYFsCyAJYFsCyAZQG+ABQaB7S5B3LuAAAAAElFTkSuQmCC"
                        ];
                        if (!mounted) {
                          return;
                        }
                        error = null;
                        loading = true;
                        setState(() {});

                        await Future.delayed(const Duration(milliseconds: 500));
                        final info =
                            await FlutterBluetoothPrinter.selectDevice(context);
                        if (info == null) {
                          return;
                        }
                        final address = info.address;
                        final name = info.name;
                        final string =
                            await convertImageToBase64("assets/crp.jpeg");
                        cmd.add("image;$string");

                        Honnywellintermecpr3 n = Honnywellintermecpr3();
                        for (var i = 0; i < 5; i++) {
                          await n.printGeneral(
                            name ?? "PR3",
                            address,
                            cmd,
                            shouldDisconnect: i == 4,
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green,
                            content: Text("SUCCESS"),
                          ),
                        );
                      } on PlatformException catch (e) {
                        error = e.message.toString();
                        setState(() {});

                        await Future.delayed(const Duration(milliseconds: 500));

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(content: Text("ERROR OCCURED")));
                      } catch (e) {
                        error = e.toString();
                        setState(() {});

                        await Future.delayed(const Duration(milliseconds: 500));

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(content: Text("ERROR OCCURED")));
                      } finally {
                        loading = false;
                        setState(() {});
                      }
                    },
                    child: const Text('Test'),
                  ),
          ),
        ],
      ),
    );
  }
}

Future<String> convertImageToBase64(String assetPath) async {
  try {
    // Load the image file from the asset bundle
    final ByteData imageData = await rootBundle.load(assetPath);

    // Get the bytes from the ByteData
    final List<int> imageBytes = imageData.buffer.asUint8List();

    // Encode the bytes to Base64
    return base64Encode(imageBytes);
  } catch (e) {
    print('Error: $e');
    return '';
  }
}
