import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  final String activeNav;

  const NavDrawer({Key? key, this.activeNav = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Logo and App Name Header with padding
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        'assets/officiallogo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Main Navigation
                  _buildDrawerItem(
                    icon: Icons.home_outlined,
                    title: 'Main',
                    isActive: activeNav == 'Main',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/main');
                    },
                  ),

                  // Profile Navigation
                  _buildDrawerItem(
                    icon: Icons.person_outline,
                    title: 'My Profile',
                    isActive: activeNav == '/profile',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),

                  // Forum Navigation
                  _buildDrawerItem(
                    icon: Icons.forum_outlined,
                    title: 'Forum',
                    isActive: activeNav == '/forum',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/forum');
                    },
                  ),
                ],
              ),
            ),

            // Divider
            const Divider(),

            // Logout Button
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              onTap: () {
                // TODO: Implement comprehensive logout logic
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create consistent drawer items
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isActive ? const Color(0xFFD2D9F5) : Colors.white,
        child: Row(
          children: [
            Icon(icon,
                color: isActive ? const Color(0xFF4D8FF8) : Colors.black),
            const SizedBox(width: 10),
            Text(title,
                style: TextStyle(
                  fontSize: 18,
                  color: isActive ? const Color(0xFF4D8FF8) : Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}
