import 'package:flutter/material.dart';
import 'package:notes_v1/appNoteClasses.dart';
import 'dart:convert';
import 'package:notes_v1/provider.dart';
import 'package:provider/provider.dart';

List<String> searchInJson(dynamic jsonObject, String searchText, [String currentPath = '']) {
  List<String> matchingPaths = [];

  if (jsonObject is Map) {
    jsonObject.forEach((key, value) {
      String newPath = currentPath.isEmpty ? key : '$currentPath->$key';
      if (value is String && value.toUpperCase().contains(searchText.toUpperCase())) {
        matchingPaths.add(newPath); 
      } else {
        matchingPaths.addAll(searchInJson(value, searchText, newPath));
      }
    });
  } else if (jsonObject is List) {
    for (var i = 0; i < jsonObject.length; i++) {
      String newPath = '$currentPath[$i]';
      matchingPaths.addAll(searchInJson(jsonObject[i], searchText, newPath));
    }
  }

  return matchingPaths;
}


Map<String,Map<String,String>> findNotePlaceholder(temp, searchText){
  Map<String,Map<String,String>> res = {};

  // print(temp_1);

  for(var entry in temp["note"].entries){
    if(entry.key != "hierarchy"){
      NotePlaceHolders note = NotePlaceHolders(
        id: entry.key,
        index: List<int>.from(entry.value["index"]!),
        type: entry.value["type"]! as String,
        content: entry.value["content"]! as String,
      );
      var temp_1 = jsonDecode(note.toString());
      List<String> result = searchInJson(temp_1, searchText);
      if(result.isNotEmpty){
        res[entry.key] = {
          "title": temp_1["content"]["sections"][2]["content"]
        };
      }
      
    } 
  }

  return res;
}



class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var searchController = TextEditingController();
  List<String> currentNotePlaceHolder = [];
  

  @override
  Widget build(BuildContext content){

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "Get Go",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // search 
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // decoration: BoxDecoration(color:Colors.amber.withOpacity(0.5), borderRadius: const BorderRadius.all(Radius.circular(16))),
                      width: MediaQuery.of(context).size.width*0.8,
                      // height: 32,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: searchController,
                        autofocus: true,
                        decoration: const InputDecoration(hintText: "Search"),
                        onSubmitted: (value){
                          Future.microtask(() async{
                            final myModel = Provider.of<CustomProvider>(context, listen: false);
                            var temp = myModel.notes!.toJson();
                            var temp_1 = findNotePlaceholder(temp,searchController.text);
                            currentNotePlaceHolder = [];
                            for(var entry in temp_1.entries){
                              String t1 = entry.key;
                              t1 += ';${entry.value["title"]}';
                              currentNotePlaceHolder.add(t1);
                            }
                            // print(currentNotePlaceHolder);
                            setState(() {
                              
                            });
                          });
                        },
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
                    height: currentNotePlaceHolder.length*64,
                    child: ListView.builder(
                      itemCount: currentNotePlaceHolder.length,
                      itemBuilder: (context, index){
                        List<String> temp = currentNotePlaceHolder[index].split(";");
                        DateTime date = DateTime.parse(temp[0].substring(0,8));
                        var p1 = temp[1];
                        if(p1.length > 24){
                          temp[1] = temp[1].substring(0,24);
                          temp[1] += "...";
                        }
                        return ListTile(
                          leading: const Icon(Icons.note),
                          title: Text(temp[1]),
                          subtitle: Text('${date.year}-${date.month}-${date.day}'),
                          onTap: (){
                            Navigator.pushNamed(context, "/editor");
                          },
                        );
                      },
                    )
                  )
                )
              ]
            )
          )
      )
    );
  }
}