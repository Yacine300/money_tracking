import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:money_tracking/screens/home/home_screen.dart';

const List<String> introTexts = [
  "Track expenses, save money, reach goals",
  "Budget, spend wisely, achieve financial dreams",
  "Invest smarter, grow wealth effortlessly"
];
const List<String> images = [
  "assets/images/test.png",
  "assets/images/test2.png",
  "assets/images/test3.png"
];
int currentIndex = 0;

class IntroScreen extends StatefulWidget {
  static const routeName = "/intro";
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            DelayedDisplay(
              delay: const Duration(milliseconds: 600),
              slidingBeginOffset: const Offset(0, 0),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: Image.asset(
                  images[currentIndex],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 800),
              slidingBeginOffset: Offset(0, 0),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentIndex = value;
                    });
                  },
                  itemCount: 3,
                  itemBuilder: (context, index) => AppIntro(),
                ),
              ),
            ),
            Dots(),
            const SizedBox(
              height: 130,
            ),
            const DelayedDisplay(
                delay: Duration(milliseconds: 2500),
                slidingBeginOffset: Offset(0, 0),
                child: Button()),
          ],
        ),
      ),
    );
  }
}

class AppIntro extends StatelessWidget {
  const AppIntro({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IntroTexts();
  }
}

class IntroTexts extends StatelessWidget {
  const IntroTexts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge,
            children: <TextSpan>[
              TextSpan(text: introTexts[currentIndex]),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          "Control And Track What you spend your money on_",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}

class Dots extends StatelessWidget {
  const Dots({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          width: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: currentIndex == index
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(HomeScreen.routeName),
      child: Container(
        height: 50,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          "Get Started",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
