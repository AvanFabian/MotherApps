// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:monitoring_hamil/res/constants.dart';
import 'package:monitoring_hamil/models/activity.dart';
import 'package:monitoring_hamil/services/activity_service.dart';
import 'package:intl/intl.dart';

class ActivityDetailPage extends StatefulWidget {
  final int userId;

  const ActivityDetailPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  late Future<List<ActivityRecord>> futureActivityRecords;

  @override
  void initState() {
    super.initState();
    futureActivityRecords = getActivityRecords(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Activity Detail',
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
              // Pop the current route off the navigation stack
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ActivityRecord>>(
        future: futureActivityRecords,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Create a list of records and calculate total duration for each day
            List<Map<String, dynamic>> records = [];
            Map<String, int> totalDurations = {};
            for (var record in snapshot.data!) {
              String date = DateFormat('yyyy-MM-dd').format(record.createdAt);
              records.add({
                'date': date,
                'duration': record.duration,
                'sportName': record.sportName,
                'sportMovement': record.sportMovement,
                'caloriesBurned': record.caloriesPrediction,
              });
              totalDurations[date] =
                  (totalDurations[date] ?? 0) + record.duration;
            }
            return Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text('Date'),
                      ),
                      DataColumn(
                        label: Text('Duration'),
                      ),
                      DataColumn(
                        label: Text('Calories Burned'),
                      ),
                      DataColumn(
                        label: Text('Sport Name'),
                      ),
                      DataColumn(
                        label: Text('Sport Movement'),
                      ),
                    ],
                    rows: records
                        .map((record) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(record['date'])),
                                DataCell(Text('${record['duration']} sec.')),
                                DataCell(Text(
                                    '${record['caloriesBurned'].toStringAsFixed(2)} cal.')),
                                DataCell(Text(record['sportName'])),
                                DataCell(Text(record['sportMovement'])),
                              ],
                            ))
                        .toList(),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 0,
                    columns: <DataColumn>[
                      DataColumn(
                        label: SizedBox(
                          width: MediaQuery.of(context).size.width /
                              2, // Set the width to half of the screen width
                          child: const Text('Date'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: MediaQuery.of(context).size.width /
                              2, // Set the width to half of the screen width
                          child: const Text('Total Duration'),
                        ),
                      ),
                    ],
                    rows: totalDurations.keys
                        .map((date) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(date)),
                                DataCell(Text('${totalDurations[date]} sec.')),
                              ],
                            ))
                        .toList(),
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
