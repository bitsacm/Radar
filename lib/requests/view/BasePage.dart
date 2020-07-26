import 'package:Radar/requests/view/ContactsScreen.dart';
import 'package:Radar/requests/view/RequestsScreen.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  PageController pageController = PageController(initialPage: 0);
  List<String> tabList = [
    'Requests',
    'Chat',
  ];
  var currentPage = 0;
  var isPageChanged = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: tabList.length,
      vsync: this,
    );
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        print(tabController.index);
        onPageChange(tabController.index, p: pageController);
      }
    });
  }

  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      isPageChanged = false;
      await pageController.animateToPage(index,
          duration: Duration(milliseconds: 500),
          curve: Curves
              .ease); 
      isPageChanged = true;
    } else {
      tabController.animateTo(index); 
    }
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TabBar(
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.blueGrey,
              labelStyle: TextStyle(fontSize: 16.0),
              tabs: tabList
                  .map((e) => Container(
                        margin: EdgeInsets.all(16),
                        child: Text(e),
                      ))
                  .toList(),
              controller: tabController,
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  if (isPageChanged) {
                    onPageChange(index);
                  }
                },
                children: <Widget>[
                  RequestsScreen(),
                  ContactsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
