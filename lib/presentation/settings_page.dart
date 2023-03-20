import 'package:flutter/material.dart';
import 'package:flutter_app_2/common/firebase_instances.dart';
import 'package:flutter_app_2/presentation/accountPage.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  final currentUser = FirebaseInstances.firebaseAuth.currentUser;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Notifications'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Dark Mode'),
            trailing: Switch(
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Account'),
            subtitle: Text('${widget.currentUser!.email}'),
            leading: Icon(Icons.person),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Get.to(() => AccountPage());
              // TODO: Navigate to account page
            },
          ),
          ListTile(
            title: Text('Privacy'),
            leading: Icon(Icons.lock),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // TODO: Navigate to privacy page
            },
          ),
          ListTile(
            title: Text('Help & Feedback'),
            leading: Icon(Icons.help),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // TODO: Navigate to help & feedback page
            },
          ),
        ],
      ),
    );
  }
}
