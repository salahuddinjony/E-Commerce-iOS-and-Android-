import 'package:flutter/material.dart';
import 'package:local/app/global/helper/device_utils/device_utils.dart';
import 'package:local/app/view/screens/features/client/user_home/user_profile/payment_methods/subscriptions/services/stripe_service.dart';

import 'my_app.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await StripeServicePayment.setup();
  DeviceUtils.lockDevicePortrait();
  runApp(const MyApp());
}



























