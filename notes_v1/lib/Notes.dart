import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:notes_v1/constants.dart';
import 'package:notes_v1/helper.dart';
import 'package:notes_v1/json.dart';
import 'dart:convert';

import 'package:notes_v1/provider.dart';
import 'package:provider/provider.dart';
import 'package:notes_v1/appNoteClasses.dart';
import 'package:path_provider/path_provider.dart';


Future<String> getNotes(username, password) async {
  try {
    var b = File('$imagePathConstant/js.json').existsSync(); 
    if(b){
      // print("kk");
      return File('$imagePathConstant/js.json').readAsString();
    }
    var newpass = sha256.convert(utf8.encode(password.toString()));

    var keys = generateRSAKeyPair();

    var url = Uri.parse(getNoteConstant(username, newpass.toString(),keys.publicKey.modulus.toString(),keys.publicKey.exponent.toString()));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      if(response.body == 'Invalid') return response.body;
      // print(response.body);
      final message = response.body.split("--");
      // print(message);
      var temp = [];
      for(int i=0 ; i<message.length ; i++){
        try{
          temp.add(rsaDecrypt(message[i], null, keys.privateKey));
        }catch (e){
          // print(e);
        }
      }
      // print(newpass);
      // print(temp.join(""));
      File('$imagePathConstant/js.json').writeAsString(temp.join());
      return temp.join();
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    return 'Error: $e';
  }
}

Map<String,Map<String,String>> findNotePlaceholder(currentHierarchy, temp){
  Map<String,Map<String,String>> res = {};

  String temp_1 = "";
  for(var i in currentHierarchy){
    temp_1 += '$i>';
  }
  if(currentHierarchy.length > 0){
    temp_1 = temp_1.substring(0,temp_1.length-1);
  }

  // print(temp_1);

  for(var entry in temp["note"].entries){
    if(entry.key != "hierarchy"){
      NotePlaceHolders note = NotePlaceHolders(
        id: entry.key,
        index: List<int>.from(entry.value["index"]!),
        type: entry.value["type"]! as String,
        content: entry.value["content"]! as String,
      );
      // print(jsonDecode(note.toString())["content"]["sections"][0]["content"]);
      // print("\n");
      if(jsonDecode(note.toString())["content"]["sections"][0]["content"] == temp_1){
        var p1;
        try{
          p1 = jsonDecode(note.toString())["content"]["sections"][2]["content"];
          if(p1.length >= 24){
            p1 = jsonDecode(note.toString())["content"]["sections"][2]["content"].substring(0,24);
            p1 += "...";
          }
        }catch(e){
          p1 = "nothing";
        }

        res[entry.key] = {
          "title": '$p1'
        };
      }
      // notesAll.add(note);
    } 
  }

  return res;
}



class NotesHome extends StatefulWidget {
  const NotesHome({super.key});

  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String profileName = 'username';
  String saved = " saved";
  IconData icon = Icons.save;
  Tag? tagHierarchy;
  List<String> currentHierarchySiblings = [];
  List<String> currentHierarchy = [];
  List<String> currentNotePlaceHolder = [];


  @override
  void initState(){
    super.initState();

    Future.microtask(() async{
      final myModel = Provider.of<CustomProvider>(context, listen: false);
      var temp = jsonDecode(await getNotes(myModel.username,myModel.password)) as Map<String, dynamic>;
      // print(temp);
      await myModel.set_user(Notes.fromJson(temp['note']));
      setState(() {
        tagHierarchy = parseTagHierarchy(myModel.notes!.note!["hierarchy"]!.content as String, Tag());
        currentHierarchySiblings = [];
        tagHierarchy!.children.forEach((key, value){
          currentHierarchySiblings.add(key);
        });
        var temp_1 = findNotePlaceholder(currentHierarchy, temp); 
        currentNotePlaceHolder = [];
        for(var entry in temp_1.entries){
          String t1 = entry.key;
          t1 += ';${entry.value["title"]}';
          currentNotePlaceHolder.add(t1);
        }
      });
      
    });
  }


  @override
  Widget build(BuildContext content){

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
                // print("Hello");
              },
              icon: const Icon(Icons.menu)),
          title: const Text(
            "Get Go",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        drawer: customDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // search 
                Center(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/search');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(color:Colors.amber.withOpacity(0.5), borderRadius: const BorderRadius.all(Radius.circular(16))),
                        width: MediaQuery.of(context).size.width*0.8,
                        height: 32,
                        alignment: Alignment.center,
                        child: const Text("Search"),  
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.only(left:16),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: currentHierarchySiblings.length*32,
                    child: ListView.builder(
                      itemCount: currentHierarchySiblings.length,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: (){

                            currentHierarchy.add(currentHierarchySiblings[index]);
                            setState(() {
                              var temp = tagHierarchy;
                              for(int i=0 ; i<currentHierarchy.length; i++){
                                  temp = temp!.children[currentHierarchy[i]];
                              }
                              currentHierarchySiblings = [];
                              temp!.children.forEach((key, value){
                                currentHierarchySiblings.add(key);
                              });
                            });

                            Future.microtask(() async{
                              final myModel = Provider.of<CustomProvider>(context, listen: false);
                              var temp = myModel.notes!.toJson();
                              var temp_1 = findNotePlaceholder(currentHierarchy, temp);
                              currentNotePlaceHolder = [];
                              for(var entry in temp_1.entries){
                                String t1 = entry.key;
                                t1 += ';${entry.value["title"]}';
                                currentNotePlaceHolder.add(t1);
                              }
                              setState(() {
                                
                              });
                            });
                          },
                          onLongPress: (){
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Wrap(
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.delete),
                                      title: const Text(' Delete'),
                                      onTap: () {
                                        String temp_1 = "";
                                        for(var key in currentHierarchy){
                                          temp_1 += '$key>';
                                        }
                                        temp_1 += currentHierarchySiblings[index];
                                        tagHierarchy!.removeTag(temp_1.split(">"));
                                        setState(() {
                                          currentHierarchySiblings = [];
                                          tagHierarchy!.children.forEach((key, value){
                                            currentHierarchySiblings.add(key);
                                          });
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ]
                                );
                              }
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.centerLeft,
                              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
                              // height: 100,
                              child: Row(
                                children: [
                                  const Icon(Icons.folder),
                                  Text(' ${currentHierarchySiblings[index]}'),
                                ]
                              )
                            ),
                          ),
                        );
                      }
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:16),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: currentNotePlaceHolder.length*64,
                    child: ListView.builder(
                      itemCount: currentNotePlaceHolder.length,
                      itemBuilder: (context, index){
                        List<String> temp = currentNotePlaceHolder[index].split(";");
                        DateTime date = DateTime.parse(temp[0].substring(0,8));
                        return ListTile(
                          leading: const Icon(Icons.note),
                          title: Text(temp[1]),
                          subtitle: Text('${date.year}-${date.month}-${date.day}'),
                          onTap: (){
                            Future.microtask(() async{
                              final myModel = Provider.of<CustomProvider>(context, listen: false);
                              var temp_1 = myModel.notes!.toJson()["note"][temp[0]];
                              NotePlaceHolders note = NotePlaceHolders(
                                id: temp[0],
                                index: List<int>.from(temp_1["index"]!),
                                type: temp_1["type"]! as String,
                                content: temp_1["content"]! as String,
                              );
                              myModel.currentNote = note;
                              // print(jsonDecode(note.toString()));
                              // print(note.parseContent());
                              Navigator.pushNamed(context, "/editor");
                            });
                          },
                          onLongPress: (){
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Wrap(
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.delete),
                                      title: const Text(' Delete'),
                                      onTap: () {
                                        Future.microtask(() async{
                                          final myModel = Provider.of<CustomProvider>(context, listen: false);                                          
                                          myModel.deleteNote(currentNotePlaceHolder[index].split(";")[0]);
                                          var temp = myModel.notes!.toJson();
                                          var temp_1 = findNotePlaceholder(currentHierarchy, temp);
                                          currentNotePlaceHolder = [];
                                          for(var entry in temp_1.entries){
                                            String t1 = entry.key;
                                            t1 += ';${entry.value["title"]}';
                                            currentNotePlaceHolder.add(t1);
                                          }
                                          setState(() {
                                            
                                          });
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ]
                                );
                              }
                            );
                          },
                        );
                      },
                    )
                  )
                )
              ],
            ),
            
          )
        ),

      );
  }

  Drawer customDrawer() {
    return Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person_2_rounded),
              title: TextButton(
                onPressed: () {
                  var temp_1 = tagHierarchy!.toFormattedString();
                  Future.microtask(() async{
                    final myModel = Provider.of<CustomProvider>(context, listen: false);
                    // await myModel.set_user(Notes.fromJson(temp['note']));
                    await myModel.update_tags(temp_1);
                    await myModel.save_notes();
                  });
                  Future.microtask(() async{
                    final myModel = Provider.of<CustomProvider>(context, listen: false);
                    var temp = myModel.notes!.toJson();
                    NoteHierarchy hierarchy = NoteHierarchy(
                      index: List<int>.from(temp["note"]!["hierarchy"]!["index"]!),
                      type: temp["note"]!["hierarchy"]!["type"]! as String,
                      content: temp["note"]!["hierarchy"]!["content"]! as String,
                    );

                    List<NotePlaceHolders> notesAll = [];

                    for(var entry in temp["note"].entries){
                      if(entry.key != "hierarchy"){

                        NotePlaceHolders note = NotePlaceHolders(
                          id: entry.key,
                          index: List<int>.from(entry.value["index"]!),
                          type: entry.value["type"]! as String,
                          content: entry.value["content"]! as String,
                        );
                        notesAll.add(note);
                      } 
                    }

                    var t1 = jsonDecode(hierarchy.toString());
                    var tempH = ReverseHierarchy(
                      index: List<int>.from(t1["index"]),
                      type: t1["type"], 
                      content: List<String>.from(t1["content"])
                    );
                    List<ReverseNote> tempN = [];
                    for(NotePlaceHolders entry in notesAll){
                      var t1 = jsonDecode(entry.toString());
                      tempN.add(ReverseNote(
                        id: t1["id"], 
                        index: List<int>.from(t1["index"]), 
                        content: t1["content"]["sections"], 
                        type: t1["type"]
                        )
                      );
                    }
                    var formatednote = convertNoteAndHierarchy(tempN, tempH);
                    // print(formatednote);
                    await myModel.update_note(formatednote);
                  });
                }, 
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(profileName),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(left:12),
                child:Row(
                  children:[
                    Icon(icon, size: 12,),
                    Text(' $saved', style: const TextStyle(fontSize: 12)),    
                  ],
                ),
              )
            ),
            ListTile(
                leading: const Icon(Icons.home),
                title: TextButton(
                    onPressed: () {
                        currentHierarchySiblings = [];
                        tagHierarchy!.children.forEach((key, value){
                          currentHierarchySiblings.add(key);
                        });
                      currentHierarchy = [];
                      Future.microtask(() async{
                        final myModel = Provider.of<CustomProvider>(context, listen: false);
                        var temp = myModel.notes!.toJson();
                        var temp_1 = findNotePlaceholder(currentHierarchy, temp);
                        currentNotePlaceHolder = [];
                        for(var entry in temp_1.entries){
                          String t1 = entry.key;
                          t1 += ';${entry.value["title"]}';
                          currentNotePlaceHolder.add(t1);
                        }
                        setState(() {
                          
                        });
                      });
                      _scaffoldKey.currentState!.closeDrawer();
                    }, 
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Home'),
                    ),)
            ),
            ListTile(
                leading: const Icon(Icons.note),
                title: TextButton(
                    onPressed: () {
                      var temp = TextEditingController();
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: const Text("Title"),
                          content: TextField(
                            controller: temp,
                            decoration: const InputDecoration(hintText: "New Note"),
                          ),
                          actions: [
                            TextButton(
                              onPressed: (){
                                String temp_1 = "";
                                for(var key in currentHierarchy){
                                  temp_1 += '$key>';
                                }
                                if(temp_1.isNotEmpty){
                                  temp_1 = temp_1.substring(0,temp_1.length-1);
                                }
                                var date = DateTime.now();
                                var day = date.day.toString();
                                if(day.length == 1){
                                  day = '0$day';
                                } 
                                var month = date.month.toString();
                                if(month.length == 1){
                                  month = '0$month';
                                } 
                                var hour = date.hour.toString();
                                if(hour.length == 1){
                                  hour = '0$hour';
                                } 
                                var minute = date.hour.toString();
                                if(minute.length == 1){
                                  minute = '0$minute';
                                } 
                                var second = date.second.toString();
                                if(second.length == 1){
                                  second = '0$second';
                                } 
                                var temp_2 = ReverseNote(
                                  id: '${date.year}$month$day$hour$minute$second',
                                  index: [110210110],
                                  content: [
                                    {"content":temp_1},
                                    {"width": "255;255;255;255", "height": "inter", "alignment": "null"},
                                    {"content": temp.text},
                                    {"width": MediaQuery.of(context).size.width, "height": "150", "alignment": "left"},
                                  ],
                                  type: [
                                    {"content":"hierarchy"},
                                    {"content":"text"}
                                  ],
                                );
                                var p1 = convertNoteAndHierarchy([temp_2],null);
                                // print(p1);
                                Future.microtask(() async{
                                  final myModel = Provider.of<CustomProvider>(context, listen: false);
                                  var temp = myModel.notes!.toJson();
                                  myModel.addNote(p1);
                                  temp = myModel.notes!.toJson();
                                  var temp_1 = findNotePlaceholder(currentHierarchy, temp);
                                  currentNotePlaceHolder = [];
                                  for(var entry in temp_1.entries){
                                    String t1 = entry.key;
                                    t1 += ';${entry.value["title"]}';
                                    currentNotePlaceHolder.add(t1);
                                  }
                                  setState(() {
                                    
                                  });
                                });
                                Navigator.of(context).pop();
                              }, 
                              child: const Text("Submit")
                            ),
                            TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              }, 
                              child: const Text("Cancel")
                            )
                          ],
                        );
                      });
                    }, 
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('New Note'),
                    ),)
            ),
            ListTile(
                leading: const Icon(Icons.folder),
                title: TextButton(
                    onPressed: () {
                      // parseTagHierarchy(, root)
                      var temp = TextEditingController();
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: const Text("Add Hierarchy"),
                          content: TextField(
                            controller: temp,
                            decoration: const InputDecoration(hintText: "Home"),
                          ),
                          actions: [
                            TextButton(
                              onPressed: (){
                                String temp_1 = "";
                                for(var key in currentHierarchy){
                                  temp_1 += '$key>';
                                }
                                temp_1 += temp.text;
                                parseTagHierarchy(temp_1, tagHierarchy!);


                                var temp_2 = tagHierarchy;
                                for(int i=0 ; i<currentHierarchy.length; i++){
                                    temp_2 = temp_2!.children[currentHierarchy[i]];
                                }
                                setState(() {
                                  currentHierarchySiblings = [];
                                  temp_2!.children.forEach((key, value){
                                    currentHierarchySiblings.add(key);
                                  });
                                  // currentHierarchy.add(temp.text);
                                });
                                Navigator.of(context).pop();
                              }, 
                              child: const Text("Submit")
                            ),
                            TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              }, 
                              child: const Text("Cancel")
                            )
                          ],
                        );
                      });
                    }, 
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Add Tag Hierarchy'),
                    ),)
            ),
            ListTile(
                leading: const Icon(Icons.settings),
                title: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/settings");
                    }, 
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Settings'),
                    ),)
            ),
            ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/");
                    }, 
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Log Out'),
                    ),)
            )
          ],
        ),
      );
  }
}
