import 'dart:io';

abstract class Serializable {
  /// Returns a serializable object
  Map<String, dynamic> serialize();

  /// Saves a json file in [fileName] file
  Future<File> saveAsJSON(String fileName);
}
