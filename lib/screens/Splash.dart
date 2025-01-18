import 'dart:async';
import 'package:flutter/material.dart';

import 'Place/Locations.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  bool position = false;
  var opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Start the animation
    Future.delayed(Duration.zero, () {
      animator();
    });
  }

  animator() async {
    if (opacity == 0) {
      opacity = 1;
      position = true;
    } else {
      opacity = 0;
      position = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              top: position ? 60 : 150,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const TextWidget("Complete", 35, Colors.black, FontWeight.bold,
                        letterSpace: 5),
                    const SizedBox(height: 5),
                    const TextWidget("Health", 35, Colors.black, FontWeight.bold,
                        letterSpace: 5),
                    const SizedBox(height: 5),
                    const TextWidget("Solution", 35, Colors.black, FontWeight.bold,
                        letterSpace: 5),
                    const SizedBox(height: 20),
                    TextWidget("Early Protection for\nFamily Health", 18,
                        Colors.black.withOpacity(.7), FontWeight.bold),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: 0,
              left: position ? 50 : 150,
              duration: const Duration(milliseconds: 400),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: opacity,
                child: Container(
                  height: currentWidth < 600 ? 510:1300,
                  width: currentWidth < 600 ? 405:1000,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/nurseaid.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: 60,
              duration: const Duration(milliseconds: 400),
              left: position ? 20 : -100,
              child: InkWell(
                onTap: () {
                  position = false;
                  opacity = 0;
                  setState(() {});
                  Timer(const Duration(milliseconds: 400), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlacesMapPage(),
                      ),
                    );
                  });
                },
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    width: currentWidth < 600 ? 150:250,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: TextWidget(
                        "Get Started",
                        currentWidth < 600 ? 17:25,
                        Colors.white,
                        FontWeight.bold,
                        letterSpace: 1,
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

// Your custom TextWidget
class TextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final double letterSpace;

  const TextWidget(this.text, this.fontSize, this.color, this.fontWeight, {super.key, this.letterSpace = 0.0});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        letterSpacing: letterSpace,
      ),
    );
  }
}