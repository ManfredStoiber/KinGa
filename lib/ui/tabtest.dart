import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabTest extends StatefulWidget {
  const TabTest({Key? key}) : super(key: key);

  @override
  State<TabTest> createState() => _TabTestState();

}

class _TabTestState extends State<TabTest> with TickerProviderStateMixin{

  TabController? _tabController;
  List<Widget> tabs = [];

  @override
  void initState() {
    _tabController = TabController(length: tabs.length + 1, vsync: this);
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    //_tabController.dispose();
    super.dispose();
  }

  Future getTabController() {
    return Future(() {
      //while(_tabController == null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(builder: (ctx, snapshot) {
        if (_tabController == null) {
          return Center(child: Text('Nicht initialisiert'),);
        } else {
          return TabBarView(
            controller: _tabController,
            children: [
              Center(child: TextButton(child: Text('Add'), onPressed: () {
                setState(() {
                  tabs.add(Center(child: Text('Tab ${tabs.length}'),));
                  _tabController = TabController(length: tabs.length + 1, vsync: this);
                });
              },),)
            ]..addAll(tabs),
          );
        }
      }, future: getTabController(),)
    );
  }
}
