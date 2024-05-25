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