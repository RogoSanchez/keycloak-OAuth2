/// Stub for dart:html to allow compilation on non-web platforms
/// This file provides empty implementations of web-specific APIs
library;

class Window {
  Location get location => Location();
  History get history => History();
}

class Location {
  String get href => '';
  set href(String value) {}
}

class History {
  void replaceState(dynamic data, String title, String? url) {}
}

final window = Window();
