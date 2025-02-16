import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

 class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'Get ready to\naccess maps\nanywhere',
      subtitle: 'with advanced military mapping capabilities',
    ),
    OnboardingContent(
      title: 'Mark and track\ncoordinates with\nprecision',
      subtitle:ScreenUtil().screenWidth > 600? 'offline support for field operations':'offline support\nfor field\noperations',
    ),
    OnboardingContent(
      title: 'Draw tactical\npatterns with\nease',
      subtitle: ScreenUtil().screenWidth > 600? 'secure and reliable mapping solution':'secure and\nreliable mapping\nsolution',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9800),
      body: SafeArea(
        child: Column(
          children: [
            // Animated Logo
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.5),
                  end: Offset.zero,
                ).animate(_animationController),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/app_icon/icon_in.svg',
                        width: 30.w, // Scales width based on screen width
                        height: 30.h, // Scales height based on screen height
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'milmap',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Animated PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _contents.length,
                itemBuilder: (context, index) => AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) => FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.5, 0),
                        end: Offset.zero,
                      ).animate(_animationController),
                      child: OnboardingPage(
                        content: _contents[index],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Animated Page Indicator
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _contents.length,
                  (index) => TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    tween: Tween(
                      begin: 0.0,
                      end: _currentPage == index ? 1.0 : 0.5,
                    ),
                    builder: (context, value, child) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CircleAvatar(
                        radius: 4 + (value * 2),
                        backgroundColor: Colors.white.withOpacity(value),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Animated Get Started Button
            if (_currentPage == _contents.length - 1)
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(_animationController),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 300),
                      tween: Tween(begin: 0.8, end: 1.0),
                      builder: (context, value, child) => Transform.scale(
                        scale: value,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                                   // Mark first launch as completed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    
    if (context.mounted) {
      // Navigate to main app
      Navigator.pushReplacementNamed(context, '/home');
    }
  
                              // Add navigation logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // elevation: 8 * value,
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String subtitle;

  OnboardingContent({
    required this.title,
    required this.subtitle,
  });
}
 


 

class OnboardingPage extends StatelessWidget {
  final OnboardingContent content;

  const OnboardingPage({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = ScreenUtil().screenWidth;

    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start, // Changed from start to center
        children: [
          SizedBox(height: isPortrait ? 20.h : 20.h),
          Text(
            content.title,
            // textAlign: TextAlign.center, // Added text alignment
            style: TextStyle(
              color: Colors.white,
              fontSize: isPortrait 
                ? (screenWidth < 600 ? 60.sp : 28.sp)
                : 24.sp,
              fontWeight: FontWeight.bold,
              height: 1.2,
              letterSpacing: 0.5.w,
            ),
          ),
          SizedBox(height: isPortrait ? 16.h : 10.h),
          Flexible(
            child: Text(
              content.subtitle,
              // textAlign: TextAlign.center, // Added text alignment
              style: TextStyle(
                fontWeight: FontWeight.bold,
            
                color: const Color(0xffFFE0B2),
                fontSize: isPortrait 
                  ? (screenWidth < 600 ? 30.sp : 18.sp)
                  : 16.sp,
                height: 1.4,
                letterSpacing: 0.3.w,
              ),
            ),
          ),
          // SizedBox(height: screenWidth > 600 ? 0 : 16.h),
        ],
      ),
    );
  }
}