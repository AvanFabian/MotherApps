// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:monitoring_hamil/res/constants.dart';
import 'package:monitoring_hamil/models/activity.dart';
import 'package:monitoring_hamil/services/activity_service.dart';

class ActivityDetailPage extends StatefulWidget {
  const ActivityDetailPage({Key? key}) : super(key: key);

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

// table to retrieve activity details
class _ActivityDetailPageState extends State<ActivityDetailPage> {
  late Future<Activity> futureActivity;

  @override
  void initState() {
    super.initState();
    futureActivity = getActivityDetails() as Future<Activity>;
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
              // Handle the button's onPressed event
            },
          ),
        ],
      ),
      body: FutureBuilder<Activity>(
        future: futureActivity,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Field',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Value',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('User ID')),
                    DataCell(Text('${snapshot.data!.userId}')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Activity ID')),
                    DataCell(Text('${snapshot.data!.activityId}')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Duration')),
                    DataCell(Text('${snapshot.data!.duration}')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Sports Activity')),
                    DataCell(Text('${snapshot.data!.sportsActivity.sportType}')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Sports Movements')),
                    DataCell(Text('${snapshot.data!.sportsMovements.map((movement) => movement.name).join(', ')}')),
                  ],
                ),
                // Add more rows for other fields
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}