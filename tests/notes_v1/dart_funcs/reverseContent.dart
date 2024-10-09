import 'dart:convert';

class Note {
  int id;
  List<int> index;
  List<dynamic> content;
  List<dynamic> type;

  Note({required this.id, required this.index, required this.content, required this.type});
}

class Hierarchy {
  List<int> index;
  String type;
  List<String> content;

  Hierarchy({required this.index, required this.type, required this.content});
}

Map<String, dynamic> convertNoteAndHierarchy(Note note, Hierarchy hierarchy) {
  // Process note type
  String type = note.type.map((t) => t['content']).join('__5050__');

  // Process note content
  String content = note.content.map((section) {
    if (section.containsKey('content')) {
      return section['content'];
    } else if (section.containsKey('width') && section.containsKey('height') && section.containsKey('alignment')) {
      return '${section['width']},${section['height']},${section['alignment']}';
    }
    return '';
  }).join('__5050__');

  // Process hierarchy content
  String hierarchyContent = hierarchy.content.join(';');

  // Create final structure
  return {
    'note': {
      '${note.id}': {
        'index': note.index,
        'type': type,
        'content': content,
      },
      'hierarchy': {
        'index': hierarchy.index,
        'type': hierarchy.type,
        'content': hierarchyContent,
      }
    }
  };
}

void main() {
  // Sample data
  Note note = Note(
    id: 20241012,
    index: [110210, 120210, 130210, 130220],
    content: [
      {'content': 'Home>Tags'},
      {'width': 'orange', 'height': 'inter%italic', 'alignment': null},
      {'content': 'Hello man?'},
      {'width': 100, 'height': 50, 'alignment': 'left'},
      {'content': 'How have you been since?'},
      {'width': 100, 'height': 50, 'alignment': 'left'},
      {'content': 'I am just enjoying vacation.'},
      {'width': 100, 'height': 50, 'alignment': 'left'},
      {'content': 'f404af09ff317b933ec40c1c9be0925f.png'},
      {'width': 100, 'height': 50, 'alignment': 'center'},
      {'content': ''}
    ],
    type: [
      {'content': 'hierarchy'},
      {'content': 'text'},
      {'content': 'text'},
      {'content': 'text'},
      {'content': 'media'}
    ],
  );

  Hierarchy hierarchy = Hierarchy(
    index: [0],
    type: 'text',
    content: ['Home>Tags', 'Docs>readings>common', 'Note>First>Only', 'Note>Second'],
  );

  // Convert to desired structure
  Map<String, dynamic> result = convertNoteAndHierarchy(note, hierarchy);

  // Print result as JSON
  print(jsonEncode(result));
}
