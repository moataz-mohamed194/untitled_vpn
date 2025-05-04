import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oneconnect_flutter/openvpn_flutter.dart';
import 'package:provider/provider.dart';
import 'package:untitled_vpn/vpn_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => VpnProvider()..initialize(context)),
        ],
        builder: (context, child) => MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: const MyHomePage(title: 'Flutter Demo Home Page'),
            ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var key = Platform.isIOS
      ? "SQbFynwQ.o854l5m5Mj.S3LdyXuLTXp53ezrCPh60MW9jgsMu9"
      : "sqeJxWNkQZ.UUG8zQ79.8WsGrBqZqWxrLRGIyhPC1E5TWK3.iN";
  List<VpnServer> vpnServerList = [];
  bool isLoading = false;

  Future<void> _incrementCounter() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final vpnProvider = context.read<VpnProvider>();
      await vpnProvider.engine.initializeOneConnect(context, key);

      List<VpnServer> x =
          await vpnProvider.engine.fetchOneConnect(OneConnect.pro);
      List<VpnServer> x2 =
          await vpnProvider.engine.fetchOneConnect(OneConnect.free);

      print('Pro servers: ${x.length}');
      print('Free servers: ${x2.length}');

      setState(() {
        vpnServerList.clear();
        vpnServerList.addAll(x);
        vpnServerList.addAll(x2);
      });
    } catch (e) {
      print('Error fetching servers: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _incrementCounter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : vpnServerList.isEmpty
                ? const Text('No VPN servers available')
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        vpnServerList.length,
                        (index) => GestureDetector(
                              onTap: () async {
                                final vpnProvider = VpnProvider.read(context);
                                vpnProvider.vpnConfig0(vpnServerList[index]);

                                // Wait for the VPN configuration to be set
                                await Future.delayed(
                                    const Duration(milliseconds: 100));

                                // Connect to VPN
                                vpnProvider.connect();
                              },
                              child: Card(
                                margin: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Server: ${vpnServerList[index].serverName}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Type: ${vpnServerList[index].isFree == "1" ? "Free" : "Pro"}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Refresh Servers',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
