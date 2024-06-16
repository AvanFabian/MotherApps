class User {
  int? id;
  String? name;
  String? image;
  String? email;
  String? token;
  double? totalDuration;
  double? totalCaloriesBurned;
  int? totalPoints;

  User(
      {this.id,
      this.name,
      this.image,
      this.email,
      this.token,
      this.totalDuration,
      this.totalCaloriesBurned,
      this.totalPoints});

  // function to convert json data to user model

  // V3:
  factory User.fromJson(Map<String, dynamic> json) {
    var userData = json.containsKey('user') ? json['user'] : json;
    return User(
        id: userData['id'],
        name: userData['name'],
        image: userData['image'],
        email: userData['email'],
        token: json['token'], // token is not nested
        totalDuration: userData['activity_records'] != null
            ? userData['activity_records']
                .fold(0, (sum, record) => sum + record['duration'])
            : 0,
        totalCaloriesBurned: userData['activity_records'] != null
            ? userData['activity_records']
                .fold(0, (sum, record) => sum + record['total_calories_burned'])
            : 0,
        totalPoints: userData['activity_records'] != null
            ? userData['activity_records'].fold(
                0,
                (sum, record) =>
                    sum + record['duration'] + record['total_calories_burned'])
            : 0);
  }

  // V2:
  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //       id: json['id'],
  //       name: json['name'],
  //       image: json['image'],
  //       email: json['email'],
  //       token: json['token'],
  //       totalPoints: json['activity_records'] != null
  //           ? json['activity_records'].fold(
  //               0,
  //               (sum, record) =>
  //                   sum + record['duration'] + record['total_calories_burned'])
  //           : 0);
  // }

  // V1:
  // factory User.fromJson(Map<String, dynamic> json){
  //   return User(
  //     id: json['user']['id'],
  //     name: json['user']['name'],
  //     image: json['user']['image'],
  //     email: json['user']['email'],
  //     token: json['token'],
  //     totalPoints: json['user']['activity_records'].fold(0, (sum, record) => sum + record['duration'] + record['total_calories_burned'])
  //   );
  // }11
}
