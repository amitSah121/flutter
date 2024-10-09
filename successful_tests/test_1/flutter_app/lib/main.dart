import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const username = "lal";

Future<String> getData() async {
  try {
    var url = Uri.parse('http://localhost:8080/?username=$username&req=read_note');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    return 'Error: $e';
  }
}

Future<String> saveData(Notes note) async {
  try {
    /*
    http.post(
        Uri.parse('https://reqres.in/api/users'),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
            'name': name,
            'job': job
        }),
    );
    */
    var url = Uri.parse('http://localhost:8080/?username=$username&req=write_note');
    var response = await http.post(
      url,
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(note.toJson())
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    return 'Error: $e';
  }
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: NewText(),
        ),
      ),
    );
  }
}

class NewText extends StatefulWidget {
  const NewText({super.key});

  @override
  State<NewText> createState() => _NewTextState();
}

class _NewTextState extends State<NewText> {
  String value = "Hello";
  List<TextEditingController> myController = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    String data = await getData();
    setState(() {
      value = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      final json = jsonDecode(value);
      if (json.containsKey(username)) {
        final user = Username.fromJson(json[username]);
        if (myController.length != user.cells?.length) {
          myController = List.generate(user.cells!.length, (i) => TextEditingController(text:user.cells?[i].content));
        }
        return note(user, myController);
      } else {
        return const Text('No data found');
      }
    } catch (e) {
      return Text('Error parsing data: $e');
    }
  }
}


class note extends StatefulWidget{


  note(this.user, this.controller,{super.key});

  Username? user;
  List<TextEditingController>? controller;

  @override
  State<note> createState() => _noteState(this.user, this.controller,);


}

class _noteState extends State<note>{
  
  _noteState(this.user, this.controller);
  Username? user;
  List<TextEditingController>? controller;

  late int length;

  @override
  Widget build(BuildContext context) {
    length =  user?.cells?.length as int;
    return Column(
      children: [
        Text(
          user?.title ?? 'No Title',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(user?.dateOfModification ?? 'No Date'),
        const SizedBox(height: 30),
        Expanded(
          child: ListView.builder(
            itemCount: length,
            itemBuilder: (BuildContext context, int index) {
              final cell = user?.cells![index];
              // print(cell!.toJson());
              final color = Color(int.parse((cell?.color ?? 'FFFFFF').substring(1, 7), radix: 16) + 0xFF000000);
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: color),
                    child: SizedBox(
                      width: (cell!.width ?? 100).toDouble(),
                      height: (cell.height ?? 100).toDouble(),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: controller![index],
                          decoration: null,
                          onChanged: (text) {
                            user?.cells![index].content = text;
                          },
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onVerticalDragUpdate: (DragUpdateDetails details) {
                      // print(details.delta.dy);
                      setState(() {
                        user?.cells![index].height = user!.cells![index].height! + (details.delta.dy).toInt();
                        final textSpan = TextSpan(text: controller![index].text);
                        final textPainter = TextPainter(
                          text: textSpan,
                          textDirection: TextDirection.ltr,
                          maxLines: null, // Allow it to compute height for all lines
                        );

                        textPainter.layout(maxWidth: (user!.cells![index].width!).toDouble());
                        
                        if(user!.cells![index].height! < (textPainter.size.height).toInt()+20){
                          
                          user!.cells![index].height = (textPainter.size.height).toInt()+20;
                        }
                      });
                    },
                    child: Container(
                        decoration: const BoxDecoration(color: Color.fromARGB(255, 255, 0, 0)),
                        child: SizedBox(
                        width: (user?.cells?[index].width ?? 100).toDouble(),
                        height: 10,
                        // child: const Text("hhe")
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
        TextButton(
          onPressed: (){
            setState(() {
              user?.cells?.add(Cell(
              type: "text",
              content: "",
              width: 500,
              height: 100,
              alignment: "center",
              color: "#cccccc"));  
              controller!.add(TextEditingController());
              length += 1;/// user!.cells!.length;
              // print(user?.cells?[2].toJson());
            });
            
          }, 
          child: const Text("Add Text")
        ),
        TextButton(
          onPressed: (){
            print("Save");
          }, 
          child: const Text("Add Media")
        ),
        TextButton(
          onPressed: (){
            Notes n = Notes(user: user, username: username);
            // print(n.toJson());
            saveData(n);
          }, 
          child: const Text("Save")
        ),
      ],
    );
  }

}

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
      title: json['title'] as String?,
      dateOfModification: json['date_of_modification'] as String?,
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

  factory Cell.fromJson(Map<String, dynamic> json) {
    return Cell(
      type: json['type'] as String?,
      content: json['content'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      color: json['color'] as String?,
      alignment: json['alignment'] as String?,
    );
  }

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
