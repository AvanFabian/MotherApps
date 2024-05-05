// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:monitoring_hamil/Models/leaderboard.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Stack(
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
                          "assets/images/leaderboard/leaderboard.png",
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
            ],
          ),
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
                  itemCount: userItems.length,
                  itemBuilder: (context, index) {
                    final items = userItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, bottom: 15),
                      child: Row(
                        children: [
                          Text(
                            items.rank,
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
                            backgroundImage: AssetImage(items.image),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            items.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            height: 25,
                            width: 70,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                const RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(
                                    Icons.back_hand,
                                    color: Color.fromARGB(255, 255, 187, 0),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  items.point.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ),
          const Positioned(
            top: 30,
            right: 150,
            child: Text(
              "Leaderboard",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // const Positioned(
          //   top: 30,
          //   left: 10,
          //   child: Text(
          //     "Ends in 2d 23Hours",
          //     style: TextStyle(
          //       fontSize: 15,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),
          // Rank 1st
          Positioned(
            top: 80,
            right: 165,
            child: rank(
                radius: 45.0,
                height: 15,
                image: "assets/images/leaderboard/g.jpeg",
                name: "Johnny Rios",
                point: "23131"),
          ),
          // for rank 2nd
          Positioned(
            top: 180,
            left: 45,
            child: rank(
                radius: 30.0,
                height: 10,
                image: "assets/images/leaderboard/k.jpeg",
                name: "Hodges",
                point: "12323"),
          ),
          // For 3rd rank
          Positioned(
            top: 193,
            right: 50,
            child: rank(
                radius: 30.0,
                height: 10,
                image: "assets/images/leaderboard/j.jpeg",
                name: "loram",
                point: "6343"),
          ),
        ],
      ),
    );
  }

  Column rank({
    required double radius,
    required double height,
    required String image,
    required String name,
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
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(
          height: height,
        ),
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
              const Icon(
                Icons.back_hand,
                color: Color.fromARGB(255, 255, 187, 0),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                point,
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
