import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:notive_app/screens/archived_lists_screen.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/screens/dashboard_screen.dart';
import 'package:notive_app/screens/mapview_screen.dart';
import 'package:notive_app/screens/profile_screen.dart';

class CustomBottomNav extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  @override
  Widget build(BuildContext context) {
    var _selectedIndex = 0;
    return Container(
      decoration: BoxDecoration(color: Colors.black, boxShadow: [
        BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
      ]),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
              gap: 8,
              color: Colors.grey[800],
              activeColor: kGrayColor,
              iconSize: 24,
              tabBackgroundColor: kLightBlueColor.withOpacity(0.1),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              duration: Duration(milliseconds: 1000),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.archive,
                  text: 'Archive',
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Search',
                ),
                GButton(
                  icon: Icons.account_circle,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex = 0,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                  switch (_selectedIndex) {
                    case 0:
                      {
                        // Navigate to Dashboard
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardScreen()),
                        );
                      }
                      break;

                    case 1:
                      {
                        // Navigate to Archived List
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArchivedListsScreen()),
                        );
                      }
                      break;
                    case 2:
                      {
                        // Map
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapViewScreen()),
                        );
                      }
                      break;
                    case 3:
                      {
                        // Profile
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()),
                        );
                      }
                      break;
                    default:
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardScreen()),
                        );
                      }
                      break;
                  }
                });
              }),
        ),
      ),
    );
  }
}
