// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:telegram/ui/categories/Plus_messanger_Page.dart';
import 'package:telegram/ui/categories/bot_Page.dart';
import 'package:telegram/ui/categories/channel_Page.dart';
import 'package:telegram/ui/categories/favourite_Page.dart';
import 'package:telegram/ui/categories/group_Page.dart';
import 'package:telegram/ui/categories/super_group_Page.dart';
import 'package:telegram/ui/categories/users_Page.dart';
import 'package:telegram/ui/widgets/DrawerWidget.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  final GlobalKey<ScaffoldState> _key = GlobalKey();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController? tabController;
  int _currentIndex = 0;
  @override
  void initState() {
    tabController = TabController(length: 7, vsync: this);
    tabController!.addListener(() {
      setState(() {
        _currentIndex = tabController!.index;
      });
    });
    super.initState();
  }

  final List _title = const [
    Text("Plus Messenger"),
    Text("Users"),
    Text("Groups"),
    Text("Super Groups"),
    Text("Channels"),
    Text("Bots"),
    Text("Favourite"),
  ];
  final List<Widget> _screens = const [
    PlusMessengerPage(),
    UsersPage(),
    GroupPage(),
    SuperGroupPage(),
    ChannelsPage(),
    BotPage(),
    FavouritePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._key,
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: _title[tabController!.index],
          leading: IconButton(
              onPressed: () {
                widget._key.currentState!.openDrawer();
              },
              icon: const Icon(Icons.menu)),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
          bottom: TabBar(
              indicatorColor: Colors.white,
              controller: tabController,
              tabs: const [
                Tab(icon: Icon(Icons.border_right_rounded)),
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.people)),
                Tab(icon: Icon(Icons.people_outline)),
                Tab(icon: Icon(Icons.language)),
                Tab(icon: Icon(Icons.bug_report_outlined)),
                Tab(icon: Icon(Icons.star)),
              ])),
      drawer: const DrawerWidget(),
      body: TabBarView(controller: tabController, children: _screens),
    );
  }
}
