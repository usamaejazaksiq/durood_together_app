class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;

  @override
  String toString() {
    return 'PushNotification{title: $title, body: $body, dataTitle: $dataTitle, dataBody: $dataBody}';
  }
}
