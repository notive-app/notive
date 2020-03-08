import 'package:flutter/material.dart';
import 'package:notive_app/components/custom_bottom_nav.dart';

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
