class User {
  int? id;
  String? name;
  String? image;
  String? email;
  String? token;
  int? totalPoints;

  User(
      {this.id,
      this.name,
      this.image,
      this.email,
      this.token,
      this.totalPoints});

  // function to convert json data to user model

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        email: json['email'],
        token: json['token'],
        totalPoints: json['activity_records'] != null
            ? json['activity_records'].fold(
                0,
                (sum, record) =>
                    sum + record['duration'] + record['total_calories_burned'])
            : 0);
  }

  // factory User.fromJson(Map<String, dynamic> json){
  //   return User(
  //     id: json['user']['id'],
  //     name: json['user']['name'],
  //     image: json['user']['image'],
  //     email: json['user']['email'],
  //     token: json['token'],
  //     totalPoints: json['user']['activity_records'].fold(0, (sum, record) => sum + record['duration'] + record['total_calories_burned'])
  //   );
  // }
}
