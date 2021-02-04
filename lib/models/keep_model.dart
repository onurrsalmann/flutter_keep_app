class Keep {
  int id;
  String title;
  DateTime date;
  String priority;
  int status;

  Keep({this.title, this.date, this.priority, this.status});
  Keep.withId({this.id, this.title, this.date, this.priority, this.status});

  Map<String, dynamic> toMap(){
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['date'] = date.toIso8601String();
    map['priority'] = priority;
    map['status'] = status;
    return map;
  }

  factory Keep.fromMap(Map<String, dynamic> map) {
    return Keep.withId(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      priority: map['priority'],
      status: map['status'],
    );
  }
}