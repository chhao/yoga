import 'package:flutter/material.dart';
import 'package:yoga/generated/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoga/practice_screen.dart';
import 'package:yoga/practice_mode_screen.dart';
import 'package:yoga/poses_screen.dart';
import 'package:yoga/breath_screen.dart';
import 'package:yoga/sequence_builder_screen.dart';
import 'package:yoga/widgets/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      setState(() {
        _locale = Locale(languageCode);
      });
    }
  }

  void changeLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoga App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7FAFA),
        canvasColor: const Color(0xFFF7FAFA),
        primarySwatch: Colors.blue,
      ),
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: {
        '/': (context) => const MyHomePage(),
        PracticeModeScreen.routeName: (context) => const PracticeModeScreen(),
        SequenceBuilderScreen.routeName: (context) =>
            const SequenceBuilderScreen(),
      },
      initialRoute: '/',
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

  String _getTitle(int index, BuildContext context) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.poses;
      case 1:
        return AppLocalizations.of(context)!.practice;
      case 2:
        return AppLocalizations.of(context)!.breath;
      default:
        return '';
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(_selectedIndex, context)),
        backgroundColor: const Color(0xFFF7FAFA),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const MainDrawer(),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
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
