import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_hamil/services/user_service.dart';
import 'package:monitoring_hamil/res/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 22.0, // Adjust the size as needed
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // This centers the title
        backgroundColor: signatureAppColor,
        elevation: 0, // z-coordinate of the app bar
        actions: <Widget>[
          IconButton(
            // settings icon
            icon: const Icon(Icons.settings, size: 30.0),
            color: Colors.black,
            onPressed: () {
              // Handle the button's onPressed event
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1554151228-14d9def656e4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=386&q=80",
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "John DoeBian",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("App Developer"),
              const SizedBox(height: 10), // Add some space
              ElevatedButton(
                onPressed: () {
                  // Handle the button's onPressed event
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          24.0), // Adjust this to make the border less rounded
                    ),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.black), // This makes the text color black
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.yellow), // This makes the button color yellow
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.only(
                          left: 44, right: 44, top: 16, bottom: 16)),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                      fontSize: 16.0), // Adjust the font size as needed
                ),
              ),
            ],
          ),
          // ignore: prefer_const_constructors
          const SizedBox(height: 35),
          ...List.generate(
            customListTiles.length,
            (index) {
              final tile = customListTiles[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Card(
                  // width of the card
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 0),
                  // bg-color
                  color: const Color.fromARGB(
                      255, 255, 255, 255), // Adjust the color as needed
                  // border radius
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4,
                  shadowColor: const Color.fromARGB(102, 29, 29, 29),
                  child: ListTile(
                    leading: Icon(tile.icon),
                    title: Text(
                      tile.title,
                      style: TextStyle(
                        // bold
                        fontWeight: FontWeight.w500,
                        color: tile.title == 'Logout'
                            ? Colors.red
                            : null, // This makes the title color red if the title is 'Logout'
                      ),
                    ),
                    // right arrow icon
                    trailing: const Icon(Icons.arrow_right_rounded),
                    onTap: tile.onTap(context),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class CustomListTile {
  final IconData icon;
  final String title;
  final Function(BuildContext) onTap;
  CustomListTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

List<CustomListTile> customListTiles = [
  CustomListTile(
    icon: Icons.accessibility_new,
    title: "Your Activity",
    onTap: (context) {},
  ),
  CustomListTile(
    title: "Friend Lists",
    // icon of people
    icon: Icons.people,
    onTap: (context) {
      // Handle tap
    },
  ),
  CustomListTile(
    title: "Information",
    // exclamation point icon
    icon: CupertinoIcons.exclamationmark_triangle,
    onTap: (context) {
      // Handle tap
    },
  ),
  CustomListTile(
    title: "Logout",
    icon: Icons.logout,
    onTap: (context) => () => logout(context), // Use a lambda function to call logout(context)
  ),
];
