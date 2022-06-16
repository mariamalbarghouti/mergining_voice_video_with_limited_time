import 'package:add_voice_over_video_feature/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Video Picker',
      initialRoute: Routes.HOME,
      getPages: AppPages.routes,
    );
  }
}
