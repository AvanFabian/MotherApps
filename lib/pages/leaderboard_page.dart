import 'package:flutter/material.dart';
import 'package:monitoring_hamil/models/user.dart';
import 'package:monitoring_hamil/services/user_service.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  Future<List<User>>? futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = getUsersDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            List<User> users = snapshot.data!;
            users.sort((a, b) =>
                (b.totalDuration ?? 0).compareTo(a.totalDuration ?? 0));

            return Stack(
              children: [
                Positioned(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 6, // takes 60% of the space
                        child: FractionallySizedBox(
                          widthFactor: 1.0, // 100% of screen width
                          alignment: Alignment.topCenter, // Align to top
                          child: Image.asset(
                            "assets/images/leaderboard/leaderboard-changed-color.png",
                            fit: BoxFit.fill, // Fill the box
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4, // takes 40% of the space
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25,
                              child: Image.asset(
                                "assets/images/leaderboard/line.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            // Add other widgets here to fill the space
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Leaderboard list
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align items at the start
                                children: [
                                  Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage: AssetImage(user.image ??
                                        'assets/images/default_avatar.png'),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.name ?? 'Anonymous',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 10), // Add vertical gap
                                        Text(
                                          'Total Duration: ${user.totalDuration} sec.',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 10), // Add vertical gap
                                        Text(
                                          'Total Calories Burned: ${user.totalCaloriesBurned!.toStringAsFixed(2)} kcal.',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 10), // Add vertical gap
                                        Text(
                                          'Sport Name: ${user.sportName}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 10), // Add vertical gap
                                        Text(
                                          'Sport Movement: ${user.sportMovement}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Leaderboard Text
                const Positioned(
                  top: 55,
                  right: 150,
                  child: Text(
                    "Leaderboard",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

// for rank 1st
                if (users.isNotEmpty)
                  Positioned(
                    top: 150,
                    right: 135,
                    child: rank(
                        radius: 45.0,
                        height: 10,
                        image: users[0].image ??
                            'assets/images/default_avatar.png',
                        name: SizedBox(
                          width: 150, // adjust the width as needed
                          child: Center(
                            child: Text(
                                (users[0].name?.length ?? 0) > 14
                                    ? "${users[0].name!.substring(0, 14)}..."
                                    : users[0].name ?? 'Anonymous',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                )),
                          ),
                        ),
                        totalDuration: users[0].totalDuration.toString(),
                        totalCaloriesBurned: users[0].totalCaloriesBurned !=
                                null
                            ? users[0].totalCaloriesBurned!.toStringAsFixed(2)
                            : '0.00',
                        point: users[0].totalDuration.toString()),
                  ),
// for rank 2nd
                if (users.length > 1)
                  Positioned(
                    top: 240,
                    left: 10,
                    child: rank(
                        radius: 30.0,
                        height: 10,
                        image: users[1].image ??
                            'assets/images/default_avatar.png',
                        name: SizedBox(
                          width: 150, // adjust the width as needed
                          child: Center(
                            child: Text(
                                (users[1].name?.length ?? 0) > 14
                                    ? "${users[0].name!.substring(0, 14)}..."
                                    : users[1].name ?? 'Anonymous',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                )),
                          ),
                        ),
                        totalDuration: users[1].totalDuration.toString(),
                        totalCaloriesBurned: users[1].totalCaloriesBurned !=
                                null
                            ? users[1].totalCaloriesBurned!.toStringAsFixed(2)
                            : '0.00',
                        point: users[1].totalDuration.toString()),
                  ),
// For 3rd rank
                if (users.length > 2)
                  Positioned(
                    top: 270,
                    right: 10,
                    child: rank(
                        radius: 30.0,
                        height: 10,
                        image: users[2].image ??
                            'assets/images/default_avatar.png',
                        name: SizedBox(
                          width: 150, // adjust the width as needed
                          child: Center(
                            child: Text(
                                (users[2].name?.length ?? 0) > 14
                                    ? "${users[0].name!.substring(0, 14)}..."
                                    : users[2].name ?? 'Anonymous',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                )),
                          ),
                        ),
                        totalDuration: users[2].totalDuration.toString(),
                        totalCaloriesBurned: users[2].totalCaloriesBurned !=
                                null
                            ? users[2].totalCaloriesBurned!.toStringAsFixed(2)
                            : '0.00',
                        point: users[2].totalDuration.toString()),
                  ),
              ],
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(64.0),
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // By default, show a loading spinner
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Column rank({
    required double radius,
    required double height,
    required String image,
    required Widget name, // Change this line
    required String totalDuration,
    required String totalCaloriesBurned,
    required String point,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: AssetImage(image),
        ),
        SizedBox(
          height: height,
        ),
        name, // And this line
        SizedBox(
          height: height,
        ),
        // All Users Rank
        Container(
          height: 25,
          width: 70,
          decoration: BoxDecoration(
              color: Colors.black54, borderRadius: BorderRadius.circular(50)),
          child: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "$totalCaloriesBurned kcal.",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
