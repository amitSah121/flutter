import 'package:dart_frog/dart_frog.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class Notes {
  Notes({this.username, this.user});

  Username? user;
  String? username;

  void addNote(Notes note) {
    user = note.user;
    username = note.username;
  }

  factory Notes.fromJson(Map<String, dynamic> json,String username) {
    return Notes(
      user: json[username] != null
          ? Username.fromJson(json[username] as Map<String, dynamic>)
          : null,
        username: username,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      username! : user?.toJson(),
    };
  }
}

class Username {
  Username({this.title, this.dateOfModification, this.cells});

  String? title;
  String? dateOfModification;
  List<Cell>? cells;

  factory Username.fromJson(Map<String, dynamic> json) {
    return Username(
      title: json['title'] as String,
      dateOfModification: json['date_of_modification'] as String,
      cells: (json['cells'] as List<dynamic>?)
          ?.map((cell) => Cell.fromJson(cell as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date_of_modification': dateOfModification,
      'cells': cells?.map((cell) => cell.toJson()).toList(),
    };
  }
}

class Cell {
  Cell({
    this.type,
    this.content,
    this.width,
    this.height,
    this.color,
    this.alignment,
  });

  String? type;
  String? content;
  int? height;
  int? width;
  String? color;
  String? alignment;

  // Deserialization method for Cell
  factory Cell.fromJson(Map<String, dynamic> json) {
    return Cell(
      type: json['type'] as String,
      content: json['content'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      color: json['color'] as String,
      alignment: json['alignment'] as String,
    );
  }

  // Serialization method for Cell
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      'width': width,
      'height': height,
      'color': color,
      'alignment': alignment,
    };
  }
}


Future<Response> onRequest(RequestContext context) async {
  var res = Response.json(body: 'Sorry');

  final request = context.request;
  final params = request.uri.queryParameters;

  if (params['req'] == 'read_note') {
    final value = await File('./res/json/Notes.json').readAsString();
    final jsonMap = jsonDecode(value) as Map<String, dynamic>;
    
    final username = params['username'];
    
    if (username != null && jsonMap.containsKey(username)) {
      final notes = Notes.fromJson(jsonMap, username);
      res = Response.json(body: notes.toJson());
    } else {
      res = Response.json(body: 'User not found');
    }
  } else if (params['req'] == 'write_note') {
    final body = await request.body();
    final jsonMap = jsonDecode(body) as Map<String, dynamic>;
    final username = params['username'];
    final value = await File('./res/json/Notes.json').readAsString();
    final jsonMap2 = jsonDecode(value) as Map<String, dynamic>;
    
    if (username != null && jsonMap.containsKey(username)) {
      final notes = Notes.fromJson(jsonMap,username);
      final updatedNote = Notes.fromJson(jsonMap2, username);
      updatedNote.addNote(notes);
      jsonMap2.addAll(updatedNote.toJson());

      await File('./res/json/Notes.json').writeAsString(jsonEncode(jsonMap2));
      res = Response.json(body: 'written');
    } else {
      res = Response.json(body: 'User not found');
    }
  }

  return res;
}
