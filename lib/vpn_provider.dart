import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oneconnect_flutter/openvpn_flutter.dart';
import 'package:provider/provider.dart';

import 'preferences.dart';

class VpnProvider extends ChangeNotifier {
  VPNStage? vpnStage;
  VpnStatus? vpnStatus;
  VpnServer? _vpnConfig;

  VpnServer? get vpnConfig => _vpnConfig;
  vpnConfig0(VpnServer? value) {
    _vpnConfig = value;
    Preferences.instance().then((prefs) {
      prefs.setTrueServer(value);
    });
    notifyListeners();
  }

  ///VPN engine
  late OpenVPN engine;

  ///Check if VPN is connected
  bool get isConnected => vpnStage == VPNStage.connected;
  String groupIdentifier =
      Platform.isIOS ? "com.example.untitledVpn0" : "com.example.untitled_vpn";
  String localizationDescription = "OneConnect VPN";

  String providerBundleIdentifier = Platform.isIOS
      ? "com.example.untitledVpn0.VPNExtension"
      : "com.example.untitled_vpn.VPNExtension";

  ///Initialize VPN engine and load last server
  void initialize(BuildContext context) async {
    engine = OpenVPN(
        onVpnStageChanged: onVpnStageChanged,
        onVpnStatusChanged: onVpnStatusChanged)
      ..initialize(
        lastStatus: onVpnStatusChanged,
        lastStage: (stage) => onVpnStageChanged(stage, stage.name),
        groupIdentifier: groupIdentifier,
        localizedDescription: localizationDescription,
        providerBundleIdentifier: providerBundleIdentifier,
      );

    if (Platform.isAndroid) {
      // Request VPN permission for Android
      bool hasPermission = await engine.requestPermissionAndroid();
      if (!hasPermission) {
        print("VPN permission not granted");
        return;
      }
    }
  }

  ///VPN status changed
  void onVpnStatusChanged(VpnStatus? status) {
    vpnStatus = status;
    notifyListeners();
  }

  ///VPN stage changed
  void onVpnStageChanged(VPNStage stage, String rawStage) {
    vpnStage = stage;
    print("VPN Stage Changed: $stage");
    if (stage == VPNStage.error) {
      print("VPN Error occurred");
      Future.delayed(const Duration(seconds: 3)).then((value) {
        vpnStage = VPNStage.disconnected;
      });
    }
    notifyListeners();
  }

  bool certificateVerify = true;

  ///Connect to VPN server
  void connect() async {
    if (_vpnConfig == null) {
      print("VPN configuration is null");
      return;
    }

    print("Attempting to connect to VPN...");
    print("Server: ${_vpnConfig?.serverName}");
    print("Username: ${_vpnConfig?.vpnUserName}");

    String? config;
    try {
      config = await OpenVPN.filteredConfig(_vpnConfig?.ovpnConfiguration);
      print("VPN Configuration filtered successfully");
    } catch (e) {
      print("Error filtering config: $e");
      config = _vpnConfig?.ovpnConfiguration;
    }

    if (config == null) {
      print("VPN configuration is null after filtering");
      return;
    }
    try {
      engine.connect(
        config,
        _vpnConfig!.serverName,
        certIsRequired: certificateVerify,
        username: _vpnConfig!.vpnUserName,
        password: _vpnConfig!.vpnPassword,
      );
      print("VPN connection initiated");
    } catch (e) {
      print("Error connecting to VPN: $e");
    }
  }

  ///Select server from list
  // Future<VpnServer?> selectServer(
  //     BuildContext context, VpnServer config) async {
  //   vpnConfig = config;
  //   notifyListeners();
  //   return vpnConfig;
  // }

  ///Disconnect from VPN server if connected
  void disconnect() {
    print("Disconnecting VPN...");
    engine.disconnect();
  }

  static VpnProvider watch(BuildContext context) => context.watch();
  static VpnProvider read(BuildContext context) => context.read();
}
