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
  final double? caloriesPrediction;  // This can be null according to your server response
  final double totalCaloriesBurned;  // New field for total calories burned
  final int duration;
  final int? distance;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActivityRecord({
    required this.id,
    required this.userId,
    required this.sportActivityId,
    required this.sportName,
    required this.sportMovement,
    this.caloriesPrediction,  // This can be null according to your server response
    required this.totalCaloriesBurned,  // New field for total calories burned
    required this.duration,
    this.distance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ActivityRecord.fromJson(Map<String, dynamic> json) {
    return ActivityRecord(
      id: json['id'],
      userId: json['user_id'],
      sportActivityId: json['sport_activity_id'],
      sportName: json['sport_name'],
      sportMovement: json['sport_movement'] as String,
      caloriesPrediction: json['calories_prediction'] != null ? json['calories_prediction'].toDouble() : null,  // This can be null according to your server response
      totalCaloriesBurned: json['total_calories_burned'].toDouble(),  // New field for total calories burned
      duration: json['duration'],
      distance: json['distance'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}