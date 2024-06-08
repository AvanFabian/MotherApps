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
      ),
      body: FutureBuilder<List<ActivityRecord>>(
        future: futureActivityRecords,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Text("No Recent Activity Yet.");
            }
            // Create a list of records and calculate total duration and total calories burned for each day
            List<Map<String, dynamic>> records = [];
            Map<String, int> totalDurations = {};
            Map<String, double> totalCaloriesBurned =
                {}; // New map to store total calories burned
            for (var record in snapshot.data!) {
              String date = DateFormat('yyyy-MM-dd').format(record.createdAt);
              records.add({
                'date': date,
                'duration': record.duration,
                'sportName': record.sportName,
                'sportMovement': record.sportMovement,
                'caloriesBurned': record
                    .totalCaloriesBurned, // Use totalCaloriesBurned instead of caloriesPrediction
              });
              totalDurations[date] =
                  (totalDurations[date] ?? 0) + record.duration;
              totalCaloriesBurned[date] = (totalCaloriesBurned[date] ?? 0.0) +
                  (record
                      .totalCaloriesBurned); // Use totalCaloriesBurned instead of caloriesPrediction
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  PaginatedDataTable(
                    header: const Text('Activity Records'),
                    rowsPerPage: 5,
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
                    source: _DataSource(records),
                  ),
                  PaginatedDataTable(
                    header: const Text('Total Records'),
                    rowsPerPage: 5,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text('Date'),
                      ),
                      DataColumn(
                        label: Text('Total Duration'),
                      ),
                      DataColumn(
                        label: Text('Total Calories Burned'),
                      ),
                    ],
                    source: _TotalDataSource(totalDurations.keys
                        .map((date) => {
                              'date': date,
                              'duration': totalDurations[date],
                              'caloriesBurned': totalCaloriesBurned[date],
                            })
                        .toList()),
                  )
                ],
              ),
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

class _DataSource extends DataTableSource {
  final List<Map<String, dynamic>> _records;

  _DataSource(this._records);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _records.length) return null;
    final record = _records[index];
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(record['date'])),
        DataCell(Text('${record['duration']} sec.')),
        DataCell(Text('${record['caloriesBurned'].toStringAsFixed(2)} cal.')),
        DataCell(Text(record['sportName'])),
        DataCell(Text(record['sportMovement'])),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _records.length;

  @override
  int get selectedRowCount => 0;
}

class _TotalDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _totals;

  _TotalDataSource(this._totals);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _totals.length) return null;
    final total = _totals[index];
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(total['date'])),
        DataCell(Text('${total['duration']} sec.')),
        DataCell(Text('${total['caloriesBurned'].toStringAsFixed(2)} cal.')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _totals.length;

  @override
  int get selectedRowCount => 0;
}
