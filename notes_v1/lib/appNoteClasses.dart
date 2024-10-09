
class Tag {
  Map<String, Tag> children = {};

  void addTag(List<String> path) {
    if (path.isEmpty) return;
    String currentTag = path.first;
    if (!children.containsKey(currentTag)) {
      children[currentTag] = Tag();
    }

    if (path.length > 1) {
      children[currentTag]!.addTag(path.sublist(1));
    }
  }

  bool removeTag(List<String> path) {
    if (path.isEmpty) return false;

    String currentTag = path.first;

    if (!children.containsKey(currentTag)) return false;

    if (path.length == 1) {
      children.remove(currentTag);
      return true;
    } else {
      bool removed = children[currentTag]!.removeTag(path.sublist(1));
      
      if (children[currentTag]!.children.isEmpty) {
        children.remove(currentTag);
      }

      return removed;
    }
  }

  // void printHierarchy([String indent = ""]) {
  //   children.forEach((key, tag) {
  //     print('$indent$key');
  //     tag.printHierarchy(indent + " $key ");
  //   });
  // }

  String toFormattedString([String parent = '']) {
    List<String> result = [];

    children.forEach((key, tag) {
      String currentPath = parent.isEmpty ? key : '$parent>$key';
      if (tag.children.isEmpty) {
        result.add(currentPath);
      } else {
        result.addAll(tag.toFormattedString(currentPath).split(';'));
      }
    });

    return result.join(';');
  }
}

Tag parseTagHierarchy(String input, Tag root) {
  List<String> siblingGroups = input.split(';');

  for (String group in siblingGroups) {
    List<String> path = group.split('>');
    root.addTag(path);
  }

  return root;
}



class NotePlaceHolders {
  String id;  // Represents the date of the note creation
  List<int> index;  // Hierarchical index
  String type;  // Type of the note content: hierarchy, text, media, or hidden
  String content;  // Content of the note
  
  NotePlaceHolders({
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
      '"sections"': typeSections.map((section) {
        //   print(index);
          if(index % 2 != 0){
            List<String> attributes = section.split(',');
              index += 1;
            return {
              '"width"': attributes.length > 0 ? '"${attributes[0]}"' : '"-1"',
              '"height"': attributes.length > 1 ? '"${attributes[1]}"' : '"-1"',
              '"alignment"': attributes.length > 2 ? '"${attributes[2]}"' : '"center"',
            };
          }else{
              index += 1;
              return {
                  '"content"': '"$section"'
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
      parsedContent.add({'"content"': '"$section"'});
    }
    
    return parsedContent;
  }

  // Convert the NotePlaceHolders object to a readable string format
  @override
  String toString() {
    return '{"id": "$id", "index": $index, "content": ${parseContent()}, "type": ${parseType()}}';
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
    return content.split(';').map((e) => '"${e.trim()}"').toList();
  }

  // Convert the NoteHierarchy object to a readable string format
  @override
  String toString() {
    return '{"index": $index, "type": "$type", "content": ${parseHierarchy()}}';
  }
}


class ReverseNote {
  String id;
  List<int> index;
  List<dynamic> content;
  List<dynamic> type;

  ReverseNote({required this.id, required this.index, required this.content, required this.type});
}

class ReverseHierarchy {
  List<int> index;
  String type;
  List<String> content;

  ReverseHierarchy({required this.index, required this.type, required this.content});
}

Map<String, dynamic> convertNoteAndHierarchy(List<ReverseNote> notes, ReverseHierarchy? hierarchy) {
  
  Map<String,dynamic> temp = {};
  temp['"note"'] = {};
  // Process note type
  for(var note in notes){
    // print(note.type);
    String type = note.type.map((t) => t['content']).join('__5050__');
    
    // Process note content
    String content = note.content.map((section) {
      if (section.containsKey('content')) {
        return '${section['content']}';
      } else if (section.containsKey('width') && section.containsKey('height') && section.containsKey('alignment')) {
        return '${section['width']},${section['height']},${section['alignment']}';
      }
      return '';
    }).join('__5050__');

    temp['"note"']['"${note.id}"'] = {
      '"index"': note.index,
      '"type"': '"$type"',
      '"content"': '"$content"', 
    };

  }

  if(hierarchy != null){
  // Process hierarchy content
    String hierarchyContent = hierarchy.content.join(';');
    temp['"note"']['"hierarchy"'] ={
      '"index"': hierarchy.index,
      '"type"': '"${hierarchy.type}"',
      '"content"': '"${hierarchyContent}"',
    };
  }

  // Create final structure
  return temp;
}