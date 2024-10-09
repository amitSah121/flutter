class Note {
  int id;
  List<int> index;
  List<Map<String, dynamic>> content;
  List<Map<String, dynamic>> type;

  Note({required this.id, required this.index, required this.content, required this.type});
}

class Hierarchy {
  List<int> index;
  String type;
  List<String> content;

  Hierarchy({required this.index, required this.type, required this.content});
}

class NoteWithHierarchy {
  Note note;
  Hierarchy hierarchy;

  NoteWithHierarchy({required this.note, required this.hierarchy});
}

// Function to search Note by hierarchy
List<int> findIdsByHierarchy(List<NoteWithHierarchy> notes, String searchHierarchy) {
  List<int> matchingIds = [];

  for (var noteWithHierarchy in notes) {
    // Join the hierarchy content into a single string for easier comparison
    String hierarchyContent = noteWithHierarchy.hierarchy.content.join('>');
    if (hierarchyContent.contains(searchHierarchy)) {
      matchingIds.add(noteWithHierarchy.note.id);
    }
  }

  return matchingIds;  // Returns a list of matching ids
}

void main() {
  // Sample data for multiple notes
  List<NoteWithHierarchy> notes = [
    NoteWithHierarchy(
      note: Note(
        id: 20241012,
        index: [110210, 120210, 130210, 130220],
        content: [
          {'content': 'Home>Tags'},
          {'width': 'orange', 'height': 'inter%italic', 'alignment': null},
          {'content': 'Hello man?'}
        ],
        type: [
          {'content': 'hierarchy'},
          {'content': 'text'},
          {'content': 'text'},
          {'content': 'media'}
        ],
      ),
      hierarchy: Hierarchy(
        index: [0],
        type: 'text',
        content: ['Home>Tags', 'Docs>readings>common', 'Note>First>Only', 'Note>Second'],
      ),
    ),
    NoteWithHierarchy(
      note: Note(
        id: 20241013,
        index: [110210, 120210, 130210],
        content: [
          {'content': 'Docs>articles'},
          {'width': 'blue', 'height': 'normal', 'alignment': 'center'}
        ],
        type: [
          {'content': 'text'},
          {'content': 'media'}
        ],
      ),
      hierarchy: Hierarchy(
        index: [1],
        type: 'text',
        content: ['Docs>articles', 'Home>Tags', 'Note>Second'],
      ),
    ),
  ];

  // Search for notes with "Home>Tags" in their hierarchy
  List<int> result = findIdsByHierarchy(notes, 'Home>Tags');
  
  // Output the result
  print(result);  // Outputs: [20241012, 20241013]
}
