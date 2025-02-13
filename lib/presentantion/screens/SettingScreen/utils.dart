  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/presentantion/screens/MapListScreen/map_list_screen.dart';
import 'package:myapp/presentantion/screens/SettingScreen/models/setting_tab.dart';
import 'package:myapp/presentantion/screens/Settings/CoordinateSetting/cordinate_setting_screen.dart';

 
   final List<SettingTab> setting_tabs = [
    // SettingTab(
    //   id: 'profile_settings',
    //   name: 'Profile Settings',
    //   icon: Icons.person,
    //   content: Center(
    //     child: Text(
    //       'Update your profile details such as name, email, and profile picture.',
    //       style: TextStyle(fontSize: 16.sp),
    //       textAlign: TextAlign.center,
    //     ),
    //   ),
    // ),
    SettingTab(
      id: 'coordinate-setting',
      name: 'Coordinates Setting',
      icon: Icons.language,
      content: SettingsScreen()
    // )
      // content: Center(
      //   child: Text(
      //     'Select your preferred language for the application.',
      //     style: TextStyle(fontSize: 16.sp),
      //     textAlign: TextAlign.center,
      //   ),
      // ),
    ),
     SettingTab(
      id: 'maps',
      name: 'Maps',
      icon: Icons.map_outlined,
      content:MapListScreen()
    ),
    SettingTab(
      id: 'privacy',
      name: 'Privacy',
      icon: Icons.lock,
      content: Center(
        child: Text(
          'Adjust your Cordinate setting..',
          style: TextStyle(fontSize: 16.sp),
          textAlign: TextAlign.center,
        ),
      ),
    ),
   
    
    SettingTab(
      id: 'help_support',
      name: 'Help & Support',
      icon: Icons.help,
      content: Center(
        child: Text(
          'Find FAQs, contact support, or report issues with the app.',
          style: TextStyle(fontSize: 16.sp),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ];
