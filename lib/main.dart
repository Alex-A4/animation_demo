import 'dart:math' as math;
import 'package:flutter/material.dart';

const images = [
  'https://bipbap.ru/wp-content/uploads/2017/08/04.-risunki-dlya-srisovki-legkie-dlya-devochek.jpg',
  'https://img3.akspic.ru/previews/8/7/7/6/6/166778/166778-spongebob-x750.jpg',
  'http://www.lessdraw.com/wp-content/uploads/2020/12/4-1.jpeg',
  'https://www.spletnik.ru/img/__post/60/60cf0ac41d8c3404a26fb544a0887c1d_994.jpg',
  'https://avatarko.ru/img/kartinka/2/zhivotnye_kot_prikol_ochki_1637.jpg',
];

void main() {
  runApp(MaterialApp(
    title: 'Анимации',
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double opacity = 1.0;

  double size = 100;

  double radius = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Первый экран'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: opacity,
              duration: Duration(seconds: 1),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final random = math.Random();
                  opacity = random.nextDouble();
                  size = random.nextDouble() * 100 + 50;
                  radius = random.nextDouble() * 90;
                });
              },
              child: Text('Tap me'),
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SecondScreen(index: index)),
                    ),
                    child: Hero(
                      tag: images[index],
                      child: Image.network(
                        images[index],
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => SizedBox(width: 10),
              ),
            ),
            SizedBox(height: 30),
            ShimmerAnimation(),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  late PageController controller;

  @override
  void initState() {
    controller = PageController(initialPage: widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Второй экран')),
      body: PageView(
        controller: controller,
        children: images
            .map(
              (e) => Hero(
                tag: e,
                child: Image.network(e, fit: BoxFit.cover),
              ),
            )
            .toList(),
      ),
    );
  }
}

class ShimmerAnimation extends StatefulWidget {
  const ShimmerAnimation({Key? key}) : super(key: key);

  @override
  _ShimmerAnimationState createState() => _ShimmerAnimationState();
}

class _ShimmerAnimationState extends State<ShimmerAnimation> with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 2),
  );
  late Animation<Alignment> animation;

  @override
  void initState() {
    super.initState();
    animation =
        AlignmentTween(begin: Alignment.topLeft, end: Alignment.bottomRight).animate(controller);
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Container(
          height: 50,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: animation.value,
              end: Alignment.center,
              colors: [
                Colors.grey[300]!,
                Colors.white,
                Colors.grey[300]!,
              ],
            ),
          ),
        );
      },
    );
  }
}
