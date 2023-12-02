import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // The AnimatedIcon needs an controller
  AnimationController? _animationController;
  late final List<String> imageUrls = [
    'https://cdn.pixabay.com/photo/2017/09/07/09/48/de-haan-2724368_1280.jpg',
    'https://cdn.pixabay.com/photo/2018/01/25/17/48/fantasy-3106688_1280.jpg',
    'https://cdn.pixabay.com/photo/2018/04/22/13/04/hallway-3341001_1280.jpg',
    'https://cdn.pixabay.com/photo/2017/08/16/17/53/lion-2648625_1280.jpg',
    'https://cdn.pixabay.com/photo/2017/08/16/17/53/lion-2648625_1280.jpg',
  ];
  double? _deviceHeight, _deviceWidth;
  int currentIndex = 0;
  Timer? myTimer;
  int? imageCount;
  bool isPlaying = false;
  bool iconVisibility = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    imageCount = imageUrls.length;
    myTimer = _startTimer();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    myTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: _deviceWidth! * .04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Click on Image to Play & Pause'),
            _imageSection(),
          ],
        ),
      ),
    );
  }

  Widget _imageSection() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: _imageTapHandler,
      child: Container(
        width: _deviceWidth,
        height: _deviceHeight! * .4,
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(imageUrls[currentIndex])),
        ),
        child: Visibility(
          visible: iconVisibility,
          child: Center(
            child: AnimatedIcon(
              icon: AnimatedIcons.pause_play,
              progress: _animationController!,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Timer _startTimer() {
    return Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % imageCount!;
      });
    });
  }

  void _imageTapHandler() {
    {
      // if isPlaying is false then set visibility true and run play the animation
      if (!isPlaying) {
        setState(() {
          iconVisibility = true;
        });

        _animationController!.forward().then((value) {
          isPlaying = !isPlaying;
        });
      } else {
        _animationController!.reverse().then((value) {
          isPlaying = !isPlaying;
          setState(() {
            iconVisibility = false;
          });
        });
      }

      if (myTimer!.isActive) {
        myTimer!.cancel();
        log('paused');
        return;
      }

      myTimer = _startTimer();
      log('start');
    }
  }
}
