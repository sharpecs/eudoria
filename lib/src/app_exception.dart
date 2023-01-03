/// A specialised exception class for application errors allowing for logging
/// and audit purposes.
class AppException {
  late int id;
  late String code;
  late String text;

  AppException({
    required this.id,
    required this.code,
    required this.text,
  });

  factory AppException.fromJson(Map<String, dynamic> json) {
    return AppException(
      id: json['i'] as int,
      code: json['c'] as String,
      text: json['t'] as String,
    );
  }

  /// A function to convert the current object to a map for storing as JSON.
  Map<String, dynamic> toJson() => {
        "i": id,
        "c": code,
        "t": text,
      };
}

/// Exception thrown from Platform Services.
class PlatformServiceException extends AppException {
  PlatformServiceException(
      {required super.id, required super.code, required super.text});
}

/// Exception thrown from Scheme Services.
class SchemeServiceException extends AppException {
  SchemeServiceException(
      {required super.id, required super.code, required super.text});
}
