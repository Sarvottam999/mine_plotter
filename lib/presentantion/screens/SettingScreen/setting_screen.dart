
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/mark_area_screen.dart';
import 'package:myapp/presentantion/screens/SettingScreen/models/setting_tab.dart';
import 'package:myapp/presentantion/screens/SettingScreen/setting_detail_screen.dart';
import 'package:myapp/presentantion/screens/SettingScreen/utils.dart';
import 'package:myapp/presentantion/widgets/download_button.dart';
import 'package:url_launcher/url_launcher.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
   SettingTab selectedTab = setting_tabs[0];



  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold( 
      appBar: AppBar(backgroundColor: Colors.white, actions: [
        

      ],),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back, size: 8.sp,)),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:  0.w),
              child: isTablet
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildSettingsList(isTablet)),
                        SizedBox(width: 20.w),
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            // height: 200.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                   border: Border(
                                left: BorderSide(
                                  color: const Color.fromARGB(255, 235, 235, 235), // Border color
                                  width: 2.0, // BorOder thickness
                                ),
                                   ),)),
                        ),
                        Expanded(flex: 4, child: _buildSettingsDetails()),
                      ],
                    )
                  : _buildSettingsList(isTablet),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> launchUrlSite() async {
  const url = 'https://docs.google.com/forms/d/e/1FAIpQLSe6au-pLHmP-FSavePt8fkMzKGH58vdH3BYoK5hchs9IyTleg/viewform'; // Replace with your Google Form link

  final Uri urlParsed = Uri.parse(url);

  if (await canLaunchUrl(urlParsed)) {
    await launchUrl(urlParsed, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

  Widget _buildSettingsList(bool isTablet) {
 
    return Padding(
      
      padding: const EdgeInsets.only( left: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[ Expanded(
          child: Center(
            child: ListView.builder(
              // shrinkWrap: true,
              // scrollDirection: Axis.vertical,
              itemCount: setting_tabs.length,
              itemBuilder: (context, index) {
                final tab = setting_tabs[index];
            
                return Container(
                  
                  margin: EdgeInsets.symmetric(vertical: 8.h), 
                  child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(isTablet ? 2.w:8.w),
                      decoration: BoxDecoration(
                        color: selectedTab == tab
                            ?   Colors.black
                            : Colors.grey.withOpacity(0.3),
                        // shape: BoxShape.,
                        borderRadius: BorderRadius.circular(4.sp)
                      ),
                      child: Icon(
                        tab.icon,
                        size:isTablet ? 8.sp: 24.sp,
                        color: selectedTab == tab ? Colors.white : Colors.black,
                      ),
                    ),
                    title: Text(
                      tab.name,
                      style: TextStyle(
                        fontSize:isTablet ?6.sp: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: selectedTab == tab ? Colors.black : const Color.fromARGB(255, 81, 81, 81),
                      ),
                    ),
                    onTap: () {
                      if (isTablet) {
                        setState(() {
                          selectedTab = tab;
                        });
                      } else {

                        if (tab == setting_tabs[setting_tabs.length - 1])
                        {
                          launchUrlSite();
                        }else{
                            Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingDetailPage(
                              title: tab.name,
                              content: tab.content  ,
                            ),
                          ),
                        );

                        }
                      
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ),
       ]   ),
    );
  }

  Widget _buildSettingsDetails() {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(16.r),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 10,
        //     offset: Offset(0, 4),
        //   ),
        // ],
      ),
      child: selectedTab.content,
    );
  }

  
}


 

 