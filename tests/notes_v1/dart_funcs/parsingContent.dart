

class Note {
  String id;  // Represents the date of the note creation
  List<int> index;  // Hierarchical index
  String type;  // Type of the note content: hierarchy, text, media, or hidden
  String content;  // Content of the note
  
  Note({
    required this.id,
    required this.index,
    required this.type,
    required this.content,
  });

  // Parse the type of the note into a structured format
  Map<String, dynamic> parseContent() {
    List<String> typeSections = content.split('__5050__');
    int index = 0;
    return {
      'sections': typeSections.map((section) {
        //   print(index);
          if(index % 2 != 0){
            List<String> attributes = section.split(',');
              index += 1;
            return {
              'width': attributes.length > 0 ? attributes[0] : null,
              'height': attributes.length > 1 ? attributes[1] : null,
              'alignment': attributes.length > 2 ? attributes[2] : null,
            };
          }else{
              index += 1;
              return {
                  'content': section
              };
          }
      }).toList(),
    };
  }

  // Parse the content of the note
  List<Map<String, String>> parseType() {
    List<String> contentSections = type.split('__5050__');
    List<Map<String, String>> parsedContent = [];
    
    for (int i = 0; i < contentSections.length; i++) {
      String section = contentSections[i];
      parsedContent.add({'content': section});
    }
    
    return parsedContent;
  }

  // Convert the Note object to a readable string format
  @override
  String toString() {
    return 'Note{id: $id, index: $index, content: ${parseContent()}, type: ${parseType()}}';
  }
}

// Hierarchical structure for the note
class NoteHierarchy {
  List<int> index;  // Index for hierarchy (spacer row and column format)
  String type;  // Content type for hierarchy: text, media, or hidden
  String content;  // Content of the hierarchy
  
  NoteHierarchy({
    required this.index,
    required this.type,
    required this.content,
  });

  // Parse hierarchy content
  List<String> parseHierarchy() {
    return content.split(';').map((e) => e.trim()).toList();
  }

  // Convert the NoteHierarchy object to a readable string format
  @override
  String toString() {
    return 'Hierarchy{index: $index, type: $type, content: ${parseHierarchy()}}';
  }
}

void main() {
  // Sample JSON data
  var noteData = {
    "note": {
      "20241012": {
        "index": [110210, 120210, 130210, 130220],
        "type": "hierarchy__5050__text__5050__text__5050__text__5050__media",
        "content": "Home>Tags__5050__orange,inter%italic__5050__Hello man?__5050__100,50,left__5050__How have you been since?__5050__100,50,left__5050__I am just enjoying vacation.__5050__100,50,left__5050__f404af09ff317b933ec40c1c9be0925f.png__5050__100,50,center__5050__"
      },
      "hierarchy": {
        "index": [0],
        "type": "text",
        "content": "Home>Tags;Docs>readings>common;Note>First>Only;Note>Second"
      }
    }
  };

  // Create Note object
  Note note = Note(
    id: "20241012",
    index: List<int>.from(noteData["note"]!["20241012"]!["index"]! as List<int>),
    type: noteData["note"]!["20241012"]!["type"]! as String,
    content: noteData["note"]!["20241012"]!["content"]! as String,
  );

  // Create NoteHierarchy object
  NoteHierarchy hierarchy = NoteHierarchy(
    index: List<int>.from(noteData["note"]!["hierarchy"]!["index"]! as List<int>),
    type: noteData["note"]!["hierarchy"]!["type"]! as String,
    content: noteData["note"]!["hierarchy"]!["content"]! as String,
  );

  // Print the parsed objects
  print(note);  // Output for normal note
  print(hierarchy);  // Output for hierarchy
}
