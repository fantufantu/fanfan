class CaptchaSent {
  CaptchaSent({
    required this.sendCaptcha,
  });

  DateTime sendCaptcha;

  factory CaptchaSent.fromJson(Map<String, dynamic> json) => CaptchaSent(
        sendCaptcha: DateTime.parse(json["sendCaptcha"]),
      );

  Map<String, dynamic> toJson() => {
        "sendCaptcha": sendCaptcha.toString(),
      };
}
