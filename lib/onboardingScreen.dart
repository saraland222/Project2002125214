import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';


class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

final _controller = PageController(initialPage: 0);
int currentPage = 0;

List<Widget> _pages = [
  Column(
    children: [
      Expanded(child: Image.asset('assets/images/Delivery.png')),
      Text(
        'Order online drom your Havarti',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  ),
  Column(
    children: [
      Expanded(
          child: Image.asset(
        'assets/images/Delivery.png',
      )),
      Text(
        'Order online drom your favarti',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      )
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('assets/images/Delivery.png')),
      Text(
        'Order online drom your favarti',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      )
    ],
  ),
];

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 120.0, bottom: 50),
              child: PageView(
                controller: _controller,
                children: _pages,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          DotsIndicator(
            dotsCount: _pages.length,
            position: currentPage.toDouble(),
            decorator: DotsDecorator(
              size: Size.square(9.0),
              activeSize: Size(18.0, 9.0),
              color: Colors.black,
              activeColor: Colors.amber,
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
