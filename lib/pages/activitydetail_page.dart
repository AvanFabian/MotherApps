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
              // Calculate total duration for each day
              Map<String, int> totalDurations = {};
              Map<String, String> sportNames = {};
              Map<String, String> sportMovements = {};
              for (var record in snapshot.data!) {
                String date = DateFormat('yyyy-MM-dd').format(record.createdAt);
                if (totalDurations.containsKey(date)) {
                  totalDurations[date] =
                      totalDurations[date]! + record.duration;
                } else {
                  totalDurations[date] = record.duration;
                  sportNames[date] = record.sportName;
                  sportMovements[date] = record.sportMovement;
                }
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Date'),
                    ),
                    DataColumn(
                      label: Text('Total Duration'),
                    ),
                    DataColumn(
                      label: Text('Sport Name'),
                    ),
                    DataColumn(
                      label: Text('Sport Movement'),
                    ),
                  ],
                  rows: totalDurations.keys
                      .map((date) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(date)),
                              DataCell(Text('${totalDurations[date]}')),
                              DataCell(Text('${sportNames[date]}')),
                              DataCell(Text('${sportMovements[date]}')),
                            ],
                          ))
                      .toList(),
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ));
  }
}
