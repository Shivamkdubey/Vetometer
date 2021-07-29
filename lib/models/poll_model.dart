class PollModel {
  late var title;
  late var pollDescription;
  List pollOptions = [];
  bool accessibility = false;
  int responseLimit = 1;
  late var password;
  late var userId;

  void addPoll(String pollOptionText) {
    pollOptions.add(pollOptionText);
  }

  void clear() {
    this.title = null;
    this.pollDescription = null;
    this.pollOptions = [];
    this.accessibility = false;
    this.responseLimit = 1;
    this.password = null;
    this.userId = null;
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'pollDescription': pollDescription,
        'pollOptions': pollOptions,
        'accessibility': accessibility,
        'responseLimit': responseLimit,
        'password': password,
        'userId': userId,
      };

  void fromJson(document) {
    this.title = document['title'];
    this.pollDescription = document['pollDescription'];
    this.pollOptions = document['pollOptions'];
    this.accessibility = document['accessibility'];
    this.responseLimit = document['responseLimit'];
    this.password = document['password'];
    this.userId = document['userId'];
  }
}
