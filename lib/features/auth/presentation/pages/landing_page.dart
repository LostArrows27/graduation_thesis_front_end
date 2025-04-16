import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/widgets/lottie_loader.dart';
import 'package:graduation_thesis_front_end/core/keys/testing_key.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:graduation_thesis_front_end/core/theme/app_pallete.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<Map<String, dynamic>> slides = [
    {
      'title': 'Powerful',
      'description': 'Save all your photos and videos in one place.'
    },
    {
      'title': 'Seamless Access',
      'description': 'Access your memories anytime, anywhere.'
    },
    {
      'title': 'High Quality',
      'description': 'Store your photos in the best possible resolution.'
    },
    {
      'title': 'Stay Organized',
      'description': 'Easily find and categorize your favorite moments.'
    },
  ];

  List<Image> images = [
    Image.asset('assets/images/slide1.jpg'),
    Image.asset('assets/images/slide2.jpg'),
    Image.asset('assets/images/slide3.jpg'),
    Image.asset('assets/images/slide4.jpg'),
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    for (var image in images) {
      precacheImage(image.image, context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthSuccess) {
          return LottieLoader();
        }

        return Scaffold(
          body: Stack(
            children: [
              // image slider
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: double.infinity,
                  viewportFraction: 1.0,
                  autoPlay: false,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _currentIndex = index;
                      });
                    });
                  },
                ),
                itemCount: slides.length,
                itemBuilder: (context, index, realIndex) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: images[index].image,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 480,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Text(
                              slides[index]['title']!,
                              style: TextStyle(
                                color: AppPallete.whiteColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              slides[index]['description']!,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppPallete.secondaryTextColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              // static overlay
              StaticOverlay(slides: slides, currentIndex: _currentIndex),
            ],
          ),
        );
      },
    );
  }
}

class StaticOverlay extends StatelessWidget {
  const StaticOverlay({
    super.key,
    required this.slides,
    required int currentIndex,
  }) : _currentIndex = currentIndex;

  final List<Map<String, dynamic>> slides;
  final int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const SizedBox(height: 200),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: const Text("Smart Gallery",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: Colors.white,
                )),
          ),
          const SizedBox(height: 300),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(slides.length, (dotIndex) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == dotIndex ? Colors.white : Colors.white38,
                ),
              );
            }),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: OutlinedButton(
                key: TestingKey.loginScreenButton,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  context.push(Routes.loginPage);
                },
                child: const Text(
                  "Log in",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Not a Smart Gallery member?",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              TextButton(
                key: TestingKey.signUpScreenButton,
                onPressed: () {
                  context.push(Routes.signUpPage);
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text("Sign up",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
