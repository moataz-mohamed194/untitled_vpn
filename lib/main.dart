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
  static OpenVPN openVPN = OpenVPN();
  var key = "SQbFynwQ.o854l5m5Mj.S3LdyXuLTXp53ezrCPh60MW9jgsMu9";
  List<VpnServer> vpnServerList = [];

  Future<void> _incrementCounter() async {
    openVPN.initializeOneConnect(context, key);
    List<VpnServer> x = await openVPN.fetchOneConnect(OneConnect.pro);
    List<VpnServer> x2 = await openVPN.fetchOneConnect(OneConnect.free);
    print('vpnServerList:${x.length}');
    print('vpnServerList:${x2.length}');

    setState(() {
      vpnServerList.addAll(x);
      vpnServerList.addAll(x2);
    });
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                vpnServerList.length,
                (index) => GestureDetector(
                      onTap: () {
                        var vpnProvider = VpnProvider.read(context);

                        vpnProvider.vpnConfig0(vpnServerList[index]);
                        vpnProvider.connect();
                      },
                      child: Column(
                        children: [
                          Text(
                            vpnServerList[index].isFree,
                          ),
                          Text(
                            vpnServerList[index].serverName,
                          ),
                          Text(
                            vpnServerList[index].vpnUserName,
                          ),
                          Text(
                            vpnServerList[index].vpnPassword,
                          ),
                        ],
                      ),
                    ))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
