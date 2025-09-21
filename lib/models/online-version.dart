class VersionModel {
  static final VersionModel _instance = VersionModel._internal();

  // Private constructor
  VersionModel._internal();

  // Factory constructor always returns the same instance
  factory VersionModel() => _instance;

  // Fields
  final String _currentVersion = "1.0.0";
  String? version;
  String? message;
  String? updateUrl;
  String? severity;

  // Getter to check version
  bool get isLatest {
    if(version == null){
      return true;
    }
    return version == _currentVersion;
  }

  bool get isNotLatest {
    if(version == null){
      return false;
    }
    return version != _currentVersion;
  }

  bool get isSevereVersionAvailable => _instance.isLatest && _instance.severity == "severe";

  // Update values from JSON
  void updateFromJson(Map<String, dynamic> data) {
    version = data['version'];
    message = data['message'];
    updateUrl = data['update_url'];
    severity = data['severe'];
  }
}
