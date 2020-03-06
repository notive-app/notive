import 'package:flutter/material.dart';
import 'package:notive_app/components/custom_bottom_nav.dart';
import 'package:notive_app/components/dashboard.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/screens/mapview_screen.dart';
import 'package:notive_app/screens/profile_screen.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:notive_app/screens/settings_screen.dart';
import 'package:notive_app/screens/dashboard_screen.dart';
import 'package:notive_app/components/rounded_button.dart';

class ArchivedListsScreen extends StatelessWidget {
  static const String id = 'archived_lists_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNav(selectedIndex: 1,),
      appBar: AppBar(
        title: Text(
          'Archived Lists',
        ),
      ),
      body: Center(
        child: Text(
          'Coming Soon...',
          style: TextStyle(
            //color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
