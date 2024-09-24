import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/pages/movies_page.dart';
import 'package:netflix_clone/screens/search_screen.dart';

class HomePage extends StatefulWidget {
  final bool search;
  const HomePage({
    super.key,
    this.search = false,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    _page = widget.search ? 1 : 0;
    super.initState();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leadingWidth: 0.0,
        title: InkWell(
          onTap: () => pageController.jumpToPage(0),
          child: Image.asset(
            'assets/logo.png',
            width: 100,
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          MoviesPage(
            homePageController: pageController,
          ),
          const SearchScreen(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        height: 55,
        iconSize: 30,
        activeColor: Colors.redAccent,
        onTap: navigationTapped,
        backgroundColor: Colors.black,
        currentIndex: _page,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 6),
              child: Icon(Icons.home_filled),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 6),
              child: Icon(Icons.search_rounded),
            ),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}
