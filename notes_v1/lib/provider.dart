import 'package:flutter/material.dart';
import 'package:notes_v1/appNoteClasses.dart';
import 'package:notes_v1/constants.dart';
import 'package:notes_v1/json.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class CustomProvider extends ChangeNotifier {
  String username = "";
  String password = "";
  Notes? notes;
  NotePlaceHolders? currentNote;
  NoteHierarchy? currentNoteHierarchy;
  

  Future<void> set_auth(us, pa) async{
    username = us;
    password = pa;
    notifyListeners();
  }

  Future<void> set_user(_note) async{
    notes = _note;
  }

  Future<void> update_tags(tags) async{
    notes!.note!["hierarchy"]!.content = tags;
  }

  Future<void> addNote(note) async{
    note = jsonDecode(note.toString());
    for(var entry in note['note'].entries){
      notes!.note![entry.key] = Note(
        content: entry.value['content'],
        type: entry.value['type'],
        index: List<int>.from(entry.value['index']) 
      );
    }
    // print(notes!.note);
  }

  Future<void> deleteNote(id) async{
    notes!.note!.removeWhere((key, value) => key == id);
  }

  Future<void> update_note(formatednote) async{
    try {
      var newpass = sha256.convert(utf8.encode(password.toString()));
      var url = Uri.parse(notesUrl);
      Map<String,dynamic> temp = {};
      temp["notes"] = jsonDecode(formatednote['"note"'].toString());
      temp["username"] = username;
      temp["password"] = newpass.toString();
      // print(jsonEncode(temp).toString());
      var response = await http.post(
        url,
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(temp)
      );
      if (response.statusCode == 200) {
        // print(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> save_notes() async{
    try {
      var newpass = sha256.convert(utf8.encode(password.toString()));
      var url = Uri.parse(notesUrl);
      Map<String,dynamic> temp = {};
      temp["notes"] = notes!.toJson()["note"];
      temp["username"] = username;
      temp["password"] = newpass.toString();
      // print(jsonEncode(temp).toString());
      var response = await http.post(
        url,
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(temp)
      );
      if (response.statusCode == 200) {
        // print(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}
