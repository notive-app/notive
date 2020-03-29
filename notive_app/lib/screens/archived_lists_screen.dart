import 'package:flutter/material.dart';
import 'package:notive_app/components/custom_bottom_nav.dart';
import 'package:notive_app/components/dashboard.dart';

class ArchivedListsScreen extends StatelessWidget {
  static const String id = 'archived_lists_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNav(selectedIndex: 1,),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Archived Lists',
        ),
      ),
      body: Dashboard(type:'archived'),
    );
  }
}
