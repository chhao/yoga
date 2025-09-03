
import 'package:flutter/material.dart';
import 'package:yoga/main.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24.0),
                ListTile(
                  title: const Text('English'),
                  onTap: () {
                    MyApp.of(context)?.changeLocale(const Locale('en'));
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('中文'),
                  onTap: () {
                    MyApp.of(context)?.changeLocale(const Locale('zh'));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF7FAFA),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFE8F2ED),
            ),
            child: Text('Settings'),
          ),
          ListTile(
            title: const Text('Audio Setting'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle audio setting tap
            },
          ),
          ListTile(
            title: const Text('Language'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          ListTile(
            title: const Text('Rate Me'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle rate me tap
            },
          ),
          ListTile(
            title: const Text('Suggestion'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle suggestion tap
            },
          ),
        ],
      ),
    );
  }
}
