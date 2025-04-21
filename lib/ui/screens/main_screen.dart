import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';
import '../../core/providers/globals/vpn_provider.dart';
import '../../core/resources/environment.dart';
import '../../core/utils/utils.dart';
import '../components/connection_button.dart';
import 'server_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            children: [
              _appbarWidget(context),
              _selectVpnWidget(context),
              const Center(child: ConnectionButton()),
              const SizedBox.shrink(),
              // Center(
              //     child: AdsProvider.bannerAd(bannerAdUnitID,
              //         adsize: AdSize.mediumRectangle)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _selectVpnWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _selectVpnClick(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.pink,
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Consumer<VpnProvider>(
                builder: (context, vpnProvider, child) {
                  var config = vpnProvider.vpnConfig;
                  return Row(
                    children: [
                      if (config == null)
                        const SizedBox(
                            width: 32,
                            height: 32,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.white,
                            )),
                      const SizedBox(width: 10),
                      Text(config?.serverName ?? 'select_server',
                          style: const TextStyle(
                            color: Colors.white,
                          )),
                      const Spacer(),
                      const Icon(
                        Icons.expand_more,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appbarWidget(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 50,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Text(
                  appName,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white.withOpacity(1),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void menuClick() {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openEndDrawer();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void _selectVpnClick(BuildContext context) {
    startScreen(context, const ServerListScreen());
  }
}
