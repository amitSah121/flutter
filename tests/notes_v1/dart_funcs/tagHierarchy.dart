class Tag {
  Map<String, Tag> children = {};

  // Helper method to add a child tag recursively
  void addTag(List<String> path) {
    if (path.isEmpty) return;

    String currentTag = path.first;

    // If the current tag doesn't exist, add it
    if (!children.containsKey(currentTag)) {
      children[currentTag] = Tag();
    }

    // Recurse into the next tag in the path
    if (path.length > 1) {
      children[currentTag]!.addTag(path.sublist(1));
    }
  }

  // Method to remove a tag based on the path
  bool removeTag(List<String> path) {
    if (path.isEmpty) return false;

    String currentTag = path.first;

    // If the current tag doesn't exist, nothing to remove
    if (!children.containsKey(currentTag)) return false;

    if (path.length == 1) {
      // If this is the last tag in the path, remove it
      children.remove(currentTag);
      return true;
    } else {
      // Recurse into the next tag in the path
      bool removed = children[currentTag]!.removeTag(path.sublist(1));
      
      // If the child tag is empty after removal, remove it from the current level
      if (children[currentTag]!.children.isEmpty) {
        children.remove(currentTag);
      }

      return removed;
    }
  }

  // Debug method to print the hierarchy
  void printHierarchy([String indent = ""]) {
    children.forEach((key, tag) {
      print('$indent$key');
      tag.printHierarchy(indent + " $key ");
    });
  }
  
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
  // Split by ";" to get sibling groups
  List<String> siblingGroups = input.split(';');

  for (String group in siblingGroups) {
    // Split each group by ">" to represent the path
    List<String> path = group.split('>');
    root.addTag(path);
  }

  return root;
}

void main() {
  String input = "Home>tag;Philips>Tag>value";
  Tag rootTag = parseTagHierarchy(input, Tag());

  input = "Home>hello;Home>world";
  rootTag = parseTagHierarchy(input, rootTag);

  // Print the hierarchy before removal
  print("Before removal:");
  rootTag.printHierarchy();

  // Remove "Home>hello" from the hierarchy
  rootTag.removeTag("Home>hello".split('>'));

  // Print the hierarchy after removal
  print("\nAfter removal:");
  rootTag.printHierarchy();
  
  print(rootTag.toFormattedString());
}
