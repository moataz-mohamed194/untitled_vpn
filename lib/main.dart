// import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'core/providers/globals/vpn_provider.dart';
import 'core/resources/environment.dart';
import 'core/utils/preferences.dart';
import 'ui/screens/main_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();

  // await Firebase.initializeApp();
  // await Future.wait([
  //   // CountryCodes.init(),
  //   // MobileAds.instance.initialize(),
  //   // MobileAds.instance.updateRequestConfiguration(
  //   //   RequestConfiguration(
  //   //     testDeviceIds: [
  //   //       'B3EEABB8EE11C2BE770B684D95219ECB',
  //   //     ],
  //   //   ),
  //   // ),
  // ].map((e) => Future.microtask(() => e)));

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => VpnProvider()..initialize(context)),
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        // title: appName,
        home: const MainScreen(),
      ),
    ),
  );
}
