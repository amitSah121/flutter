import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:notes_v1/appNoteClasses.dart';
import 'package:notes_v1/constants.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:notes_v1/provider.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:http/http.dart' as http;

// String jsonString = '''
// {"id": "20241012010101", "index": [110210110, 120210110, 130210110, 130220110], "content": {"sections": [{"content": "Home>Tags"}, {"width": "orange", "height": "inter%italic", "alignment": "null"}, {"content": "Hello man?"}, {"width": "576", "height": "50", "alignment": "left"}, {"content": "How have you been since?"}, {"width": "576", "height": "50", "alignment": "left"}, {"content": "I am just enjoying vacation."}, {"width": "288", "height": "150", "alignment": "left"}, {"content": "f404af09ff317b933ec40c1c9be0925f.png"}, {"width": "288", "height": "150", "alignment": "center"}, {"content": ""}]}, "type": [{"content": "hierarchy"}, {"content": "text"}, {"content": "text"}, {"content": "text"}, {"content": "media"}]}
// ''';

var deleteUpdateApp = null;
var bgcolor = "255;10;100;255";
var font = "inter";

class Editor extends StatefulWidget {
  Editor({super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  void initState() {
    deleteUpdateApp = deleteMe;

    // final args = ModalRoute.of(context)!.settings.arguments as String;
    // print(args);

    Future.microtask(() async{
      final myModel = Provider.of<CustomProvider>(context, listen: false);
      var temp_t = myModel.currentNote!;
      dynamic jsonObject = jsonDecode(temp_t.toString());
      // print(jsonObject);

      if(jsonObject == null){
        return;
      }
    

      // dynamic jsonObject = jsonDecode(jsonString);

      List<int> indexes = List<int>.from(jsonObject["index"]);
      List<dynamic> content = jsonObject["content"]["sections"];
      bgcolor = content[1]["width"];
      content.removeAt(0);
      content.removeAt(0);
      List<dynamic> type = jsonObject["type"];
      type.removeAt(0);

      List<int> i1 = [];
      for (int i = 0; i < indexes.length; i++) {
        i1.add(i);
      }

      i1.sort((a1, b1) {
        var a = indexes[a1];
        var b = indexes[b1];

        int rowa = (a / 10000000).round() - 10 - 1;
        int cola = ((a % 1000000) / 10000).round() - 20 - 1;
        int rowia = ((a % 10000) / 10).round() - 10 - 1;

        int rowb = (b / 10000000).round() - 10 - 1;
        int colb = ((b % 1000000) / 10000).round() - 20 - 1;
        int rowib = ((b % 10000) / 10).round() - 10 - 1;

        return (rowa * 100 + cola * 10 + rowia) -
            (rowb * 100 + colb * 10 + rowib);
      });

      // print(indexes);
      // print(i1);

      for (int i = 0; i < i1.length; i++) {
        var a = indexes[i1[i]];

        int row = (a / 10000000).round() - 10 - 1;
        int col = ((a % 1000000) / 10000).round() - 20 - 1;
        int rowi = ((a % 10000) / 10).round() - 10 - 1;

        if (row == temp.length) {
          var temp_1 =
              DRow(DRowSize(width: 567.0, height: 120), index: temp.length);
          temp.add(temp_1);
        }

        if (col == 0) {
          if (rowi != 0) {
            temp[row].addVertical(col, rowi);
          }
          temp[row].mat[col][rowi].controller.text =
              content[i1[i] * 2]["content"];
          temp[row].mat[col][rowi].type = type[i1[i]]["content"];
          temp[row].mat[col][rowi].alignment =
              getAlignment(content[i1[i] * 2 + 1]["alignment"]);
          // temp[row].mat[col][rowi].width =
          //     double.parse(content[i1[i] * 2 + 1]["width"]);
          // temp[row].mat[col][rowi].height =
          //     double.parse(content[i1[i] * 2 + 1]["height"]);
          continue;
        }

        if (col == temp[row].mat.length) {
          temp[row].addHorizontal(col - 1);
          if (rowi != 0) {
            temp[row].addVertical(col - 1, rowi - 1);
          }
          temp[row].mat[col][rowi].controller.text =
              content[i1[i] * 2]["content"];
          temp[row].mat[col][rowi].type = type[i1[i]]["content"];
          temp[row].mat[col][rowi].alignment =
              getAlignment(content[i1[i] * 2 + 1]["alignment"]);
          // temp[row].mat[col][rowi].width =
          //     double.parse(content[i1[i] * 2 + 1]["width"]);
          // temp[row].mat[col][rowi].height =
          //     double.parse(content[i1[i] * 2 + 1]["height"]);
        } else {
          if (rowi != 0) {
            temp[row].addVertical(col, rowi - 1);
          }
          temp[row].mat[col][rowi].controller.text =
              content[i1[i] * 2]["content"];
          temp[row].mat[col][rowi].type = type[i1[i]]["content"];
          temp[row].mat[col][rowi].alignment =
              getAlignment(content[i1[i] * 2 + 1]["alignment"]);
          // temp[row].mat[col][rowi].width =
          //     double.parse(content[i1[i] * 2 + 1]["width"]);
          // temp[row].mat[col][rowi].height =
          //     double.parse(content[i1[i] * 2 + 1]["height"]);
        }

        // print('${content[i1[i] * 2]} ${content[i1[i] * 2 + 1]} ${type[i1[i]]}');
      }

      for (int i = 0; i < i1.length; i++) {
        var a = indexes[i1[i]];

        int row = (a / 10000000).round() - 10 - 1;
        int col = ((a % 1000000) / 10000).round() - 20 - 1;
        int rowi = ((a % 10000) / 10).round() - 10 - 1;

        temp[row].mat[col][rowi].width =
            double.parse(content[i1[i] * 2 + 1]["width"]);
        temp[row].mat[col][rowi].height =
            double.parse(content[i1[i] * 2 + 1]["height"]);
        // print('${content[i1[i] * 2]} ${content[i1[i] * 2 + 1]} ${type[i1[i]]}');
      }
      setState(() {
        
      });
    });
  }

  Alignment getAlignment(t) {
    if (t == "center") {
      return Alignment.center;
    }

    if (t == "topcenter") {
      return Alignment.topCenter;
    }

    if (t == "bottomcenter") {
      return Alignment.bottomCenter;
    }

    if (t == "topleft") {
      return Alignment.topLeft;
    }

    if (t == "topright") {
      return Alignment.topRight;
    }

    if (t == "bottomleft") {
      return Alignment.bottomLeft;
    }

    if (t == "bottomright") {
      return Alignment.bottomRight;
    }

    if (t == "centerleft") {
      return Alignment.centerLeft;
    }

    if (t == "centerright") {
      return Alignment.centerRight;
    }
    return Alignment.center;
  }

  var temp = [];

  void deleteMe(id) {
    if (id == temp.length - 1) {
      temp.removeAt(id);
    } else {
      for (int i = id + 1; i < temp.length; i++) {
        temp[i].index -= 1;
      }
      temp.removeAt(id);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var t1 = bgcolor.split(";");
    // print(int.parse(t1[0]));
    var t2 = t1.map((ele){
      return int.parse(ele);
    }).toList();
    // print(t2);
    return Scaffold(
      backgroundColor: Color.fromARGB(t2[3],t2[0],t2[1],t2[2]),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "Get Go",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    alignment: Alignment.topRight,
                    title: const Text('Settings'),
                    content: Container(
                      alignment: Alignment.topLeft,
                      // decoration: BoxDecoration(color:Colors.red),
                      width: 200,
                      height: 150,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: ListTile(
                              title: const Text("Background-Color"),
                              leading: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(color: Color.fromARGB(t2[3],t2[0],t2[1],t2[2])),
                              ),
                              onTap: (){
                                Navigator.pop(context);
                                showDialog(
                                  context: context, 
                                  builder: (context){
                                    var c1 = bgcolor;
                                    return AlertDialog(
                                      content: MaterialColorPicker(
                                        onColorChange: (v){
                                          c1 = '${v.red};${v.green};${v.blue};${v.alpha}';
                                        },
                                        selectedColor: Colors.white,
                                        colors: const [
                                            Colors.red,
                                            Colors.yellow,
                                            Colors.lightGreen,
                                            Colors.grey,
                                            Colors.amber,
                                            Colors.cyan,
                                            Colors.brown,
                                            Colors.indigo,
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: (){
                                            bgcolor = c1;
                                            setState(() {
                                              
                                            });
                                            Navigator.pop(context);
                                          }, 
                                          child: const Text("Submit")
                                        )
                                      ],
                                    );
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: ListTile(
                              leading: const Icon(Icons.font_download),
                              title: Text(font),
                              onTap: (){
                                Navigator.pop(context);
                                showDialog(
                                  context: context, 
                                  builder: (context){
                                    return AlertDialog(
                                      title: const Text("Font Family"),
                                      content: DropdownButton<String>(
                                        value: font,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            font = newValue!;
                                          });
                                          Navigator.pop(context);
                                        },
                                        items: <String>['inter','Roboto', 'Montserrat', 'Lobster']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  }
                                );
                                
                              },
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: ListTile(
                              title: const Text("Save"),
                              leading: const Icon(Icons.save),
                              onTap: (){
                                Future.microtask(()async{
                                  var myModel = Provider.of<CustomProvider>(context,listen: false);
                                  var crr = jsonDecode(myModel.currentNote!.parseContent().toString());
                                  // print(crr);
                                  var sections = [];
                                  sections.add({"content":crr["sections"][0]["content"]});
                                  sections.add({"width":bgcolor,"height":font,"alignment":"null"});
                                  List<int> indexes = [];
                                  List<dynamic> type = [];
                                  type.add({"content":"hierarchy"});
                                  for(int i=0 ; i<temp.length; i++){
                                    var temp_1 = temp[i];
                                    for(int j=0 ; j<temp_1.mat.length; j++){
                                      var temp_2 = temp_1.mat[j];
                                      for(int k=0 ; k<temp_2.length ; k++){
                                        var temp_3 = temp_2[k];
                                        indexes.add((10000000*(i+11)+10000*(j+21)+10*(k+11)));
                                        var t1 = temp_3.toString().split("-");
                                        sections.add({"content":t1[0]});
                                        var t2 = t1[1].split(",");
                                        sections.add({"width":double.parse(t2[0]),"height":double.parse(t2[1]),"alignment":t2[2]});
                                        type.add({"content":temp_3.type});
                                      }
                                    }
                                  }
                                  crr["sections"] = sections;
                                  ReverseNote n1 = ReverseNote(
                                    id: myModel.currentNote!.id,
                                    index: indexes, 
                                    content: sections, 
                                    type: type
                                  );
                                  // print(type);
                                  myModel.addNote(convertNoteAndHierarchy([n1],null));
                                  // print(convertNoteAndHierarchy([n1],null)['"note"']);
                                });
                                Navigator.pop(context);
                              },
                            )
                          )
                        ],
                      )
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.more_vert)
          )
        ],
      ),
      body: ListView.builder(
        itemCount: temp.length + 1,
        itemBuilder: (context, index) {
          if (index < temp.length) {
            return temp[index];
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      var temp_1 = DRow(
                          DRowSize(width: MediaQuery.of(context).size.width, height: 120),
                          index: index);
                      temp.add(temp_1);
                      setState(() {});
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Text")
                  ),
                  const SizedBox(width:12),
                  ElevatedButton.icon(
                    onPressed: () {
                      var temp_1 = DRow(
                          DRowSize(width: MediaQuery.of(context).size.width, height: 120),
                          index: index);
                      temp_1.mat[0][0].type = "media";
                      temp.add(temp_1);
                      setState(() {});
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Media"))
                ],
              ),
            );
          }
        }
      )
    );
  }
}

class DRowSize {
  DRowSize({required this.width, required this.height});
  double width, height;
  var controller = TextEditingController();
  var isPreview = true;
  var alignment = Alignment.center;
  var type = "text";

  bool del(delw, delh) {
    width += delw;
    if (width < 0) {
      width -= delw;
      return false;
    }

    height += delh;
    if (height < 0) {
      width -= delw;
      height -= delh;
      return false;
    }
    return true;
  }

  bool delW(delw) {
    width += delw;
    if (width < 0) {
      width -= delw;
      return false;
    }
    return true;
  }

  bool delH(delh) {
    height += delh;
    if (height < 0) {
      height -= delh;
      return false;
    }
    return true;
  }

  String toString() {
    return '${controller.text}-$width,$height,${alignment.toString().split(".")[1]}';
  }
}

class DRow extends StatefulWidget {
  DRow(DRowSize size, {super.key, required this.index}) {
    List<DRowSize> temp = [];
    var temp_1 = DRowSize(width: size.width, height: size.height);
    temp.add(temp_1);
    mat.add(temp);
  }

  int index;
  List<List<DRowSize>> mat = [];

  void addHorizontal(index) {
    if (index < mat.length) {
      List<DRowSize> temp = [];
      double h = mat[index].fold(0.0, (value, element) {
        return value + element.height;
      });
      var width = mat[index][0].width - 12;
      mat[index].forEach((value) {
        value.width = width / 2;
      });
      var temp_1 = DRowSize(width: width / 2, height: h);
      temp.add(temp_1);
      if (index == mat.length - 1) {
        mat.add(temp);
      } else {
        mat.insert(index + 1, temp);
      }
    }
  }

  void addVertical(index_1, index_2) {
    if (index_1 < mat.length) {
      var temp = mat[index_1];
      if (index_2 < temp.length) {
        double h = temp[index_2].height - 12;
        temp[index_2].height = h / 2;
        var temp_1 = DRowSize(width: temp[0].width, height: h / 2);
        if (index_2 == temp.length - 1) {
          temp.add(temp_1);
        } else {
          temp.insert(index_2 + 1, temp_1);
        }
      }
    }
  }

  void removeChild(index_1, index_2) {
    if (mat.length == 1) {
      if (mat[0].length == 1) {
        deleteUpdateApp(index);
      } else {
        if (index_2 < mat[0].length) {
          if (index_2 == 0) {
            mat[0][index_2 + 1].width += mat[0][index_2].width;
            mat[0][index_2 + 1].width += 12;
          } else {
            mat[0][index_2 - 1].width += mat[0][index_2].width;
            mat[0][index_2 - 1].width += 12;
          }
          mat[0].removeAt(index_2);
        }
      }
    } else {
      if (index_1 < mat.length) {
        if (mat[index_1].length == 1) {
          var w = mat[index_1][0].width;
          if (index_1 == 0) {
            mat[index_1 + 1].forEach((ele) {
              ele.width += w + 12;
            });
          } else {
            mat[index_1 - 1].forEach((ele) {
              ele.width += w + 12;
            });
          }
          mat.removeAt(index_1);
        } else {
          var h = mat[index_1][index_2].height;
          if (index_2 == 0) {
            mat[index_1][index_2 + 1].height += h + 12;
          } else {
            mat[index_1][index_2 - 1].height += h + 12;
          }
          mat[index_1].removeAt(index_2);
        }
      }
    }
  }

  @override
  State<DRow> createState() => _DRowState();
}

class _DRowState extends State<DRow> {
  String _selectedHValue = "H-Center";
  String _selectedVValue = "V-Center";

  

  @override
  Widget build(BuildContext context) {
    // print(widget.mat);
    // print(widget.mat.fold(0.0, (value, element){
    //     return (value! as double) + element[0].height;
    //   }));
    return Column(
      children: [
        SizedBox(
          width: widget.mat.fold(0.0, (value, element) {
                return value + element[0].width;
              }) +
              (widget.mat.length - 1) * 12,
          height: widget.mat[0].fold(0.0, (value, element) {
                return value + element.height;
              }) +
              (() {
                int i = 0;
                for (int j = 0; j < widget.mat.length; j++) {
                  if (widget.mat[j].length > widget.mat[i].length) {
                    i = j;
                  }
                }
                // print(widget.mat[i].length);
                return ((widget.mat[i].length - 1) * 12);
              })(),
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.mat.length,
              itemBuilder: (context, index_1) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: widget.mat[index_1][0].width,
                        height: widget.mat[index_1].fold(0.0, (value, element) {
                              return value + element.height;
                            }) +
                            (widget.mat[index_1].length - 1) * 12,
                        child: ListView.builder(
                          itemCount: widget.mat[index_1].length,
                          itemBuilder: (context, index_2) {
                            
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.01)
                                  ),
                                  width: widget.mat[index_1][index_2].width,
                                  height: widget.mat[index_1][index_2].height,
                                  child: GestureDetector(
                                      onLongPress: () {
                                        getAlignment(widget
                                            .mat[index_1][index_2].alignment);
                                        modifyChild(index_1, index_2);
                                      },
                                      onTap: (){
                                        if(widget.mat[index_1][index_2].type == "media"){
                                          showDialog(
                                            context: context, 
                                            builder: (context){
                                              return AlertDialog(
                                                content: ListTile(
                                                  leading: const Icon(Icons.upload),
                                                  title: const Text("Upload"),
                                                  onTap: (){
                                                    
                                                  },
                                                ),
                                              );
                                            }
                                          );
                                        }
                                      },
                                      child: DRowChild(
                                          index_1,
                                          index_2,
                                          widget.mat[index_1][index_2].width,
                                          widget.mat[index_1][index_2].height,
                                          widget
                                              .mat[index_1][index_2].isPreview,
                                          widget
                                              .mat[index_1][index_2].controller,
                                          widget.mat[index_1][index_2]
                                              .alignment)),
                                ),
                                if (index_2 != widget.mat[index_1].length - 1)
                                  GestureDetector(
                                    onVerticalDragUpdate: (v) {
                                      changeInternalHeight(
                                          index_1, index_2, v.delta.dy);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.05)),
                                      width: widget.mat[index_1][index_2].width,
                                      height: 12,
                                    ),
                                  )
                              ],
                            );
                          },
                        ),
                      ),
                      if (index_1 != widget.mat.length - 1)
                        GestureDetector(
                          onHorizontalDragUpdate: (v) {
                            changeInternalWidth(index_1, v.delta.dx);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.01)),
                            width: 12,
                            height:
                                widget.mat[index_1].fold(0.0, (value, element) {
                              return value! + element.height;
                            }),
                          ),
                        )
                    ]);
              },
            ),
          ),
        ),
        GestureDetector(
          onVerticalDragUpdate: (v) {
            changeTotalHeight(v.delta.dy);
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.05)),
            width: widget.mat.fold(0.0, (value, element) {
                  return value + element[0].width;
                }) +
                (widget.mat.length - 1) * 12,
            height: 12,
          ),
        )
      ],
    );
  }

  bool isValidImagePath(String imageName){
    var b = File('$imagePathConstant/$imageName').existsSync(); 
    if(!b){
      try {
        Future.microtask(()async{
          var myModel = Provider.of<CustomProvider>(context, listen: false);
          var newpass = sha256.convert(utf8.encode(myModel.password.toString()));
          var url = Uri.parse(getMediaConstant(myModel.username, newpass.toString(),imageName));
          // print(url);
          var response = await http.get(url);
          if (response.statusCode == 200) {
            File file = File('$imagePathConstant/$imageName');
            // print(file);
            await file.writeAsBytes(response.bodyBytes);
            setState(() {
              
            });
          } else {
            // throw Exception('Failed to load data');
            // return false;
          }
        });
      } catch (e) {
        // print('Error: $e');
      }
    }
    return b;
  }

  Widget DRowChild(int index_1, int index_2, double width, double height,
      bool isPreview, TextEditingController controller, alignment) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: alignment,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.1))),
              width: width,
              height: height,
              child: 
              (widget.mat[index_1][index_2].type == "media")
              ? (isValidImagePath(widget.mat[index_1][index_2].controller.text)
                  ? Image.file(
                      File('$imagePathConstant/${widget.mat[index_1][index_2].controller.text}'),
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                    ) 
                  : Container(
                      width: width,
                      height: height,
                      color: Colors.grey, // Dummy placeholder background color
                      child: const Icon(
                        Icons.image, // Placeholder icon
                        color: Colors.white,
                        size: 50,
                      ),
                    )
                )
              : !isPreview
                  ? TextField(
                      controller: controller,
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Write"),
                      onTapOutside: (v) {
                        setState(() {
                          changePreview(index_1, index_2, true);
                        });
                      },
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          changePreview(index_1, index_2, false);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.01)),
                        width: width - 16,
                        height: height - 16,
                        alignment: alignment,
                        child: MarkdownBody(
                          selectable: true,
                          data: controller.text,
                          styleSheet: MarkdownStyleSheet(
                            h1: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: font),
                            h2: TextStyle(fontSize: 24, fontWeight: FontWeight.w600,  fontFamily: font),
                            h3: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,  fontFamily: font),
                            h4: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,  fontFamily: font),
                            h5: TextStyle(fontSize: 13, fontWeight: FontWeight.w300,  fontFamily: font),
                            h6: TextStyle(fontSize: 12, fontWeight: FontWeight.w200,  fontFamily: font),
                            p: TextStyle(fontSize: 16,  fontFamily: font),
                            strong: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,  fontFamily: font),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  void modifyChild(index_1, index_2) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              alignment: Alignment.center,
              actionsAlignment: MainAxisAlignment.start,
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.mat[index_1].length == 1)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.addHorizontal(index_1);
                          Navigator.pop(context);
                        });
                      },
                      child: const Row(
                        children: [Icon(Icons.add), Text("Add Box")],
                      ),
                    ),
                  if (widget.mat[index_1].length == 1)
                    const SizedBox(
                      height: 16,
                    ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.addVertical(index_1, index_2);
                        Navigator.pop(context);
                      });
                    },
                    child: const Row(
                      children: [Icon(Icons.add), Text("Add Column")],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.removeChild(index_1, index_2);
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: const Row(
                      children: [Icon(Icons.delete), Text("Delete Box")],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                          text:
                              (widget.mat[index_1][index_2].controller).text));
                      Navigator.pop(context);
                    },
                    child: const Row(
                      children: [Icon(Icons.select_all), Text("SeleteAll")],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if(widget.mat[index_1][index_2].type != "media")
                    GestureDetector(
                      onTap: () {
                        
                        widget.mat[index_1][index_2].type = "media";
                        setState(() {
                          
                        });
                        Navigator.pop(context);
                      },
                      child: const Row(
                        children: [Icon(Icons.change_circle), Text("To Media")],
                      ),
                    ),
                  if(widget.mat[index_1][index_2].type == "media")
                    GestureDetector(
                      onTap: () {
                        widget.mat[index_1][index_2].type = "text";
                        setState(() {
                          
                        });
                        Navigator.pop(context);
                      },
                      child: const Row(
                        children: [Icon(Icons.change_circle), Text("To Text")],
                      ),
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 2,
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.3)),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GestureDetector(
                          onTap: () {
                            _selectedHValue = "H-Center";
                            _selectedVValue = "V-Center";
                            setState(() {
                              updateAlignment(index_1, index_2);
                              Navigator.pop(context);
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Text("Center"),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Left',
                              groupValue: _selectedHValue,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedHValue = value!;
                                  updateAlignment(index_1, index_2);
                                  Navigator.pop(context);
                                });
                              },
                            ),
                            const Text("Left")
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'H-Center',
                              groupValue: _selectedHValue,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedHValue = value!;
                                  updateAlignment(index_1, index_2);
                                  Navigator.pop(context);
                                });
                              },
                            ),
                            const Text("H-Center")
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Right',
                              groupValue: _selectedHValue,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedHValue = value!;
                                  updateAlignment(index_1, index_2);
                                  Navigator.pop(context);
                                });
                              },
                            ),
                            const Text("Right")
                          ],
                        )
                      ]),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Top',
                              groupValue: _selectedVValue,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedVValue = value!;
                                  updateAlignment(index_1, index_2);
                                  Navigator.pop(context);
                                });
                              },
                            ),
                            const Text("Top")
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'V-Center',
                              groupValue: _selectedVValue,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedVValue = value!;
                                  updateAlignment(index_1, index_2);
                                  Navigator.pop(context);
                                });
                              },
                            ),
                            const Text("V-Center")
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Bottom',
                              groupValue: _selectedVValue,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedVValue = value!;
                                  updateAlignment(index_1, index_2);
                                  Navigator.pop(context);
                                });
                              },
                            ),
                            const Text("Bottom")
                          ],
                        )
                      ]),
                ],
              ));
        });
  }

  void updateAlignment(index_1, index_2) {
    if (_selectedHValue == "H-Center" && _selectedVValue == "V-Center") {
      widget.mat[index_1][index_2].alignment = Alignment.center;
    } else {
      if (_selectedHValue == "Left" && _selectedVValue == "V-Center") {
        widget.mat[index_1][index_2].alignment = Alignment.centerLeft;
      } else if (_selectedHValue == "Right" && _selectedVValue == "V-Center") {
        widget.mat[index_1][index_2].alignment = Alignment.centerRight;
      } else if (_selectedHValue == "H-Center" && _selectedVValue == "Top") {
        widget.mat[index_1][index_2].alignment = Alignment.topCenter;
      } else if (_selectedHValue == "H-Center" && _selectedVValue == "Bottom") {
        widget.mat[index_1][index_2].alignment = Alignment.bottomCenter;
      } else if (_selectedHValue == "Left" && _selectedVValue == "Top") {
        widget.mat[index_1][index_2].alignment = Alignment.topLeft;
      } else if (_selectedHValue == "Right" && _selectedVValue == "Top") {
        widget.mat[index_1][index_2].alignment = Alignment.topRight;
      } else if (_selectedHValue == "Right" && _selectedVValue == "Bottom") {
        widget.mat[index_1][index_2].alignment = Alignment.bottomRight;
      } else if (_selectedHValue == "Left" && _selectedVValue == "Bottom") {
        widget.mat[index_1][index_2].alignment = Alignment.bottomLeft;
      }
    }
  }

  void getAlignment(alignment) {
    if (alignment == Alignment.center) {
      _selectedHValue = "H-Center";
      _selectedVValue = "V-Center";
    } else if (alignment == Alignment.bottomCenter) {
      _selectedHValue = "H-Center";
      _selectedVValue = "Bottom";
    } else if (alignment == Alignment.bottomLeft) {
      _selectedHValue = "Left";
      _selectedVValue = "Bottom";
    } else if (alignment == Alignment.bottomRight) {
      _selectedHValue = "RIGHT";
      _selectedVValue = "Bottom";
    } else if (alignment == Alignment.topCenter) {
      _selectedHValue = "H-Center";
      _selectedVValue = "Top";
    } else if (alignment == Alignment.topLeft) {
      _selectedHValue = "Left";
      _selectedVValue = "Top";
    } else if (alignment == Alignment.topRight) {
      _selectedHValue = "Right";
      _selectedVValue = "Top";
    } else if (alignment == Alignment.centerLeft) {
      _selectedHValue = "Left";
      _selectedVValue = "V-Center";
    } else if (alignment == Alignment.centerRight) {
      _selectedHValue = "Right";
      _selectedVValue = "V-Center";
    }
  }

  void changePreview(index_1, index_2, b) {
    widget.mat[index_1][index_2].isPreview = b;
    setState(() {});
  }

  void changeTotalHeight(del) {
    widget.mat.forEach((element) {
      element[element.length - 1].height += del;
    });
    setState(() {});
  }

  void changeInternalWidth(index_1, del) {
    var temp = widget.mat;
    temp[index_1].forEach((ele) {
      ele.width += del;
    });
    temp[index_1 + 1].forEach((ele) {
      ele.width -= del;
    });
    setState(() {});
  }

  void changeInternalHeight(index_1, index_2, del) {
    var temp = widget.mat[index_1];
    temp[index_2].height += del;
    if (temp[index_2].height < 0) {
      temp[index_2].height -= del;
      return;
    }
    temp[index_2 + 1].height -= del;
    if (temp[index_2 + 1].height < 0) {
      temp[index_2].height -= del;
      temp[index_2 + 1].height += del;
      return;
    }
    setState(() {});
  }
}
