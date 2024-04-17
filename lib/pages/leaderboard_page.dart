import 'package:flutter/material.dart';
import 'package:monitoring_hamil/my_colors.dart';

class LeaderBoardPage extends StatelessWidget {
  const LeaderBoardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MyColors.calculatorScreen,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          actions: const [
            Icon(
              Icons.grid_view,
              color: Colors.white,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(colors: [
                        Colors.yellow.shade600,
                        Colors.orange,
                        Colors.red
                      ])),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: MyColors.calculatorButton),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Region',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                            Text(
                              'National',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                            Text(
                              'Global',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      WinnerContainer(
                        url: 'assets/1.jpg',
                        winnerName: 'Alina',
                        height: 120,
                        rank: '2',
                        color: Colors.green,
                      ),
                      WinnerContainer(
                        isFirst: true,
                        color: Colors.orange,
                      ),
                      WinnerContainer(
                        winnerName: 'Sofiya',
                        url: 'assets/3.jpg',
                        height: 120,
                        rank: '3',
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                      gradient: LinearGradient(colors: [
                        Colors.yellow.shade600,
                        Colors.orange,
                        Colors.red
                      ])),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 360.0,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                          color: MyColors.calculatorScreen),
                      child: GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio: 3.5,
                        children: const [
                          ContestantList(
                            url: 'assets/8.jpg',
                            name: 'Shona',
                            rank: '1145',
                          ),
                          ContestantList(
                            url: 'assets/9.jpg',
                            name: 'Emily',
                            rank: '1245',
                          ),
                          ContestantList(
                            url: 'assets/7.jpg',
                            name: 'Josheph',
                            rank: '2153',
                          ),
                          ContestantList(
                            url: 'assets/10.jpg',
                            rank: '3456',
                            name: 'Kristine',
                          ),
                          ContestantList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WinnerContainer extends StatelessWidget {
  final bool isFirst;
  final Color? color;
  final String? winnerPosition;
  final String? url;
  final String? winnerName;
  final String? rank;
  final double? height;
  const WinnerContainer(
      {Key? key,
      this.isFirst = false,
      this.color,
      this.winnerPosition,
      this.winnerName,
      this.rank,
      this.height,
      this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.yellow.shade600,
                    Colors.orange,
                    Colors.red
                  ]),
                  border: Border.all(
                    color:
                        Colors.amber, //kHintColor, so this should be changed?
                  ),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    height: 150.0,
                    width: 100.0,
                    decoration: const BoxDecoration(
                      color: MyColors.calculatorButton,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Stack(
              children: [
                if (isFirst)
                  Image.asset(
                    'assets/taj.png',
                    height: 70.0,
                    width: 105.0,
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 15.0),
                  child: ClipOval(
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.yellow.shade600,
                          Colors.orange,
                          Colors.red
                        ]),
                        border: Border.all(
                          color: Colors
                              .amber, //kHintColor, so this should be changed?
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipOval(
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            'assets/5.jpg',
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 115.0, left: 45.0),
                  child: Container(
                    height: 20.0,
                    width: 20.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: const Center(
                        child: Text(
                      '1',
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 150.0,
            child: SizedBox(
              // diganti sizedbox tadinya container
              width: 100.0,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Emma Aria',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ContestantList extends StatelessWidget {
  final String? url;
  final String? name;
  final String? rank;
  const ContestantList({Key? key, this.url, this.name, this.rank})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, bottom: 5.0, top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.red[400] ?? Colors.red,
            Colors.red,
            Colors.yellow[400] ?? Colors.yellow,
          ]),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
              color: MyColors.calculatorButton,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipOval(
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/4.jpg',
                          height: 60.0,
                          width: 60.0,
                          fit: BoxFit.fill,
                        )),
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '@${'Name'}',
                        style: TextStyle(color: Colors.white54, fontSize: 12.0),
                      ),
                    ],
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '1234',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
