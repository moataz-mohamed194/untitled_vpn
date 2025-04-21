import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oneconnect_flutter/openvpn_flutter.dart';

import '../../core/providers/globals/vpn_provider.dart';
import '../../core/resources/environment.dart';
import '../../core/utils/config.dart';
import '../../core/utils/navigations.dart';

class ServerItem extends StatefulWidget {
  final VpnServer config;
  const ServerItem(this.config, {super.key});

  @override
  State<ServerItem> createState() => _ServerItemState();
}

class _ServerItemState extends State<ServerItem>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    super.build(context);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: _itemClick,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.pink, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
                child: Text(widget.config.serverName,
                    style: const TextStyle(color: Colors.white))),
            if (showSignalStrength)
              FutureBuilder(
                  future: Future.microtask(
                      () => Ping(widget.config.server, count: 1).stream.first),
                  builder: (context, snapshot) {
                    var ms = DateTime.now().difference(now).inMilliseconds;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Image.asset("assets/icons/signal0.png",
                          width: 32, height: 32, color: Colors.grey.shade400);
                    }
                    if (ms < 80) {
                      return Image.asset("assets/icons/signal3.png",
                          width: 32, height: 32);
                    } else if (ms < 150) {
                      return Image.asset("assets/icons/signal2.png",
                          width: 32, height: 32);
                    } else if (ms < 300) {
                      return Image.asset("assets/icons/signal1.png",
                          width: 32, height: 32);
                    } else if (ms > 300) {
                      return Image.asset("assets/icons/signal0.png",
                          width: 32, height: 32);
                    }
                    return Image.asset("assets/icons/signal0.png",
                        width: 32, height: 32, color: Colors.grey);
                  }),
          ],
        ),
      ),
    );
  }

  void _itemClick([bool force = false]) async {
    print("_itemClick:${widget.config}");
  }

  @override
  bool get wantKeepAlive => true;
}
