class Activity {
  final int userId;
  final int activityId;
  final int duration;

  Activity(
      {required this.userId, required this.activityId, required this.duration});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      userId: json['userId'],
      activityId: json['activityId'],
      duration: json['duration'],
    );
  }
}

class SportsActivity {
  final int id;
  final String sportType;

  SportsActivity({
    required this.id,
    required this.sportType,
  });
}

class SportsMovement {
  final int id;
  final String name;

  SportsMovement({
    required this.id,
    required this.name,
  });
}

class ActivityRecord {
  final int id;
  final int userId;
  final int sportActivityId;
  final String sportName;
final String sportMovement;
  final int duration;
  final int? distance;
  final int? caloriesPrediction;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActivityRecord({
    required this.id,
    required this.userId,
    required this.sportActivityId,
    required this.sportName,
    required this.sportMovement, // Changed from sportMovement to sportMovement
    required this.duration,
    this.distance,
    this.caloriesPrediction,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ActivityRecord.fromJson(Map<String, dynamic> json) {
    // print("JSON: $json");
    return ActivityRecord(
      id: json['id'],
      userId: json['user_id'],
      sportActivityId: json['sport_activity_id'],
      sportName: json['sport_name'],
      sportMovement: json['sport_movement'] as String,
      duration: json['duration'],
      distance: json['distance'],
      caloriesPrediction: json['calories_prediction'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
