class Activity {
  final int userId;
  final int activityId;
  final int duration;

  Activity({required this.userId, required this.activityId, required this.duration});

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

  // Add methods for serialization and deserialization as needed
}

class SportsMovement {
  final int id;
  final String name;

  SportsMovement({
    required this.id,
    required this.name,
  });

  // Add methods for serialization and deserialization as needed
}