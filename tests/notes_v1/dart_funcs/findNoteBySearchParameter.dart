import 'dart:convert';

/// Recursively searches for [searchText] in the given JSON object [jsonObject].
/// It returns a list of paths where the text is found.
List<String> searchInJson(dynamic jsonObject, String searchText, [String currentPath = '']) {
  List<String> matchingPaths = [];

  if (jsonObject is Map) {
    // Traverse each key-value pair in the map
    jsonObject.forEach((key, value) {
      String newPath = currentPath.isEmpty ? key : '$currentPath->$key';
      if (value is String && value.toUpperCase().contains(searchText.toUpperCase())) {
        matchingPaths.add(newPath); // Add the path if a match is found
      } else {
        // Recursively search deeper if it's a nested Map or List
        matchingPaths.addAll(searchInJson(value, searchText, newPath));
      }
    });
  } else if (jsonObject is List) {
    // Traverse each item in the list
    for (var i = 0; i < jsonObject.length; i++) {
      String newPath = '$currentPath[$i]';
      matchingPaths.addAll(searchInJson(jsonObject[i], searchText, newPath));
    }
  }

  return matchingPaths;
}

void main() {
  // Sample JSON data
  String jsonString = '''
    {"id": "20241012", "index": [110210, 120210, 130210, 130220], "content": {"sections": [{"content": "Home>Tags"}, {"width": "orange", "height": "inter%italic", "alignment": "null"}, {"content": "Hello man?"}, {"width": "100", "height": "50", "alignment": "left"}, {"content": "How have you been since?"}, {"width": "100", "height": "50", "alignment": "left"}, {"content": "I am just enjoying vacation."}, {"width": "100", "height": "50", "alignment": "left"}, {"content": "f404af09ff317b933ec40c1c9be0925f.png"}, {"width": "100", "height": "50", "alignment": "center"}, {"content": ""}]}, "type": [{"content": "hierarchy"}, {"content": "text"}, {"content": "text"}, {"content": "text"}, {"content": "media"}]}
''';

  // Parse the JSON string
  dynamic jsonObject = jsonDecode(jsonString);

  // Search for the text "Home>Tags"
  String searchText = "hello";
  List<String> result = searchInJson(jsonObject, searchText);

  // Output the matching paths
  if (result.isNotEmpty) {
    print('Text "$searchText" found at:');
    result.forEach((path) => print(path));
  } else {
    print('Text "$searchText" not found.');
  }
}
