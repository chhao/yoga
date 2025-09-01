import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoga/breath_screen.dart';
import 'package:yoga/poses_screen.dart';
import 'package:yoga/practice_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoga App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7FAFA),
        canvasColor: const Color(0xFFF7FAFA),
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const PosesScreen(),
    const PracticeScreen(),
    const BreathScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icon_poses.svg'),
            activeIcon: SvgPicture.asset('assets/icon_poses_sel.svg'),
            label: AppLocalizations.of(context)!.poses,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icon_practice.svg'),
            activeIcon: SvgPicture.asset('assets/icon_practice_sel.svg'),
            label: AppLocalizations.of(context)!.practice,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icon_breath.svg'),
            activeIcon: SvgPicture.asset('assets/icon_breath_sel.svg'),
            label: AppLocalizations.of(context)!.breath,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF333333),
        unselectedItemColor: const Color(0xFFC4C7CE),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
