import 'package:flutter/material.dart';
import 'tutorial_content.dart';
import 'slide.dart';
import 'slide_dots.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainTutorialPage extends StatefulWidget {
  @override
  _MainTutorialPageState createState() => _MainTutorialPageState();
}

class _MainTutorialPageState extends State<MainTutorialPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController(
    initialPage: 0
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 40),
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    PageView.builder(
                      onPageChanged: _onPageChanged,
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      itemCount: slideList.length,
                      itemBuilder: (ctx, idx) => TutorialContent(idx)
                    ),
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 35),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for(int i = 0; i < slideList.length; i++)
                                (i == _currentPage)
                                    ? SlideDots(true) : SlideDots(false)
                            ],
                          ),
                        )
                      ],
                    )
                  ]
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed: () => _finish(),
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Text(
                      _currentPage == 2 ? 'Finish' : 'Skip'
                    ),
                  ),
                  if(_currentPage <= 1) RaisedButton(
                    onPressed: () => _nextPage(),
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Text(
                        'Next'
                    )
                  )
                ]
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  _nextPage() {
    setState(() {
      _currentPage++;
    });
    
    _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn);
  }

  _finish() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("tutorialSeen", true);

    Navigator.of(context).popAndPushNamed("/googleLogin");
  }

}
