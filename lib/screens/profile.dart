import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home.dart';
import '../user.dart' as MyUser;
import 'list.dart';
import 'ListsOnlyPage.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;

  MyUser.User currentUser = MyUser.User(
    name: "Loading...",
    email: "Loading...",
    groceryLists: [],
  );

  bool pushNotif = true;
  bool darkMode = false;
  bool autoSync = true;

  final Color switchColor = const Color(0xFFFA8801);

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    // get lists
    final response = await supabase
        .from('grocery_lists')
        .select('name')
        .eq('user_id', user.id);

    List<String> groceryLists = [];

    if (response != null) {
      groceryLists = (response as List)
          .map((item) => item['name'].toString())
          .toList();
    }

    // generate a username if none exists
    String generatedName = user.userMetadata?['name'] ??
        "User${user.id.substring(0, 5)}"; // first 5 chars of user ID

    setState(() {
      currentUser = MyUser.User(
        name: generatedName,
        email: user.email ?? "No Email",
        groceryLists: groceryLists,
      );
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD1FBF2),
      body: Stack(
        children: [
          Container(color: Colors.white.withOpacity(0.33)),

          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: const [
                      Text(
                        "Grocer",
                        style: TextStyle(
                          color: Color(0xFF4E8E81),
                          fontSize: 25,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "Ease",
                        style: TextStyle(
                          color: Color(0xFFFA8801),
                          fontSize: 25,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Container(
                  width: 263,
                  height: 145,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0xFFA0DDD1),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentUser.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        currentUser.email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFA3AFAD),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const SectionTitle(title: "Account"),

                Center(
                  child: Column(
                    children: [
                      ProfileOption(
                        title: "Edit Profile",
                        subtitle: "Edit your information",
                        icon: Icons.edit,
                        trailing: const Icon(Icons.chevron_right, size: 18),
                        onTap: () {},
                      ),
                      ProfileOption(
                        title: "Sharing and Collaboration",
                        subtitle: "Manage shared lists",
                        icon: Icons.group_outlined,
                        trailing: const Icon(Icons.chevron_right, size: 18),
                        onTap: () {},
                      ),
                      ProfileOption(
                        title: "Shopping History",
                        subtitle: "View your shopping history",
                        icon: Icons.history,
                        trailing: const Icon(Icons.chevron_right, size: 18),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const SectionTitle(title: "Preferences"),

                Center(
                  child: Column(
                    children: [
                      ProfileOption(
                        title: "Push Notifications",
                        subtitle: "Enable notifications",
                        icon: Icons.notifications_none,
                        trailing: Switch(
                          activeColor: switchColor,
                          value: pushNotif,
                          onChanged: (val) {
                            setState(() {
                              pushNotif = val;
                            });
                          },
                        ),
                      ),
                      ProfileOption(
                        title: "Dark Mode",
                        subtitle: "Switch to dark mode",
                        icon: Icons.dark_mode_outlined,
                        trailing: Switch(
                          activeColor: switchColor,
                          value: darkMode,
                          onChanged: (val) {
                            setState(() {
                              darkMode = val;
                            });
                          },
                        ),
                      ),
                      ProfileOption(
                        title: "Auto Sync",
                        subtitle: "Keep lists updated across devices",
                        icon: Icons.sync,
                        trailing: Switch(
                          activeColor: switchColor,
                          value: autoSync,
                          onChanged: (val) {
                            setState(() {
                              autoSync = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                GestureDetector(
                  onTap: () async {
                    await supabase.auth.signOut();
                    if (mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/login",
                            (_) => false,
                      );
                    }
                  },
                  child: Container(
                    width: 143,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF206355),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Log Out",
                        style: TextStyle(
                          color: Color(0xFFAEBFBC),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 90),
              ],
            ),
          ),

          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(activePage: 'profile'),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF4F8E81),
            fontSize: 15,
            fontFamily: 'Pathway Extreme',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ProfileOption({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: 263,
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (icon != null)
              Icon(icon, size: 20, color: const Color(0xFF4F8E81)),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFA3AFAD),
                      fontSize: 9,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),

            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final String activePage;

  const BottomNavBar({super.key, required this.activePage});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, Icons.home, "Home", activePage == "home"),
          _navItem(context, Icons.groups, "List", activePage == "list"),
          _navItem(context, Icons.favorite, "Favorites", activePage == "favorites"),
          _navItem(context, Icons.person, "Profile", activePage == "profile"),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, bool active) {
    final inactiveColor = Colors.grey[600]; // gray color same as HomePage
    return GestureDetector(
      onTap: () {
        if (label == "Home") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
          );
        }
        if (label == "List") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ListsOnlyPage()),
          );
        }
        if (label == "Favorites") {
          Navigator.pushReplacementNamed(context, "/favorites");
        }
        // Profile is current page
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: active ? const Color(0xFF4F8E81) : inactiveColor, // <-- use inactiveColor
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Pathway Extreme',
              fontWeight: FontWeight.w500,
              color: active ? const Color(0xFF4F8E81) : inactiveColor, // <-- use inactiveColor
            ),
          ),
        ],
      ),
    );
  }
}