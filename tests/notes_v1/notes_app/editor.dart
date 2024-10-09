import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // final GlobalKey _markdownKey = GlobalKey();
  // double _markdownHeight = 0.0;
  // double _markdownWidth = 0.0;
  List<customBox> boxes = [];

  void initState(){
    // var temp = customBox(490.0);
    // temp.id = identityHashCode(temp);
    // boxes.add(temp);
    // temp.addChild("BOX", 0);
    // temp.addChild("COLUMN", 0);
    // (temp.children[1] as customBox).addChild("BOX",0);
    // temp.addChild("COLUMN", 0);
    // (temp.children[1] as customBox).addChild("BOX",0);
    // (temp.children[1] as customBox).addChild("BOX",0);
    // temp.addChild("BOX",2);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Testing'),
        ),
        body: ListView.builder(
          itemCount: boxes.length + 1,
          itemBuilder: (context, index){
            if(index == boxes.length){
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: (){
                        var temp = customBox(MediaQuery.of(context).size.width);
                        temp.id = identityHashCode(temp);
                        boxes.add(temp);
                        setState(() {});
                      },
                      icon:const Icon(Icons.add),
                      label: const Text("Add Text"),
                    ),
                    const SizedBox(width: 32,),
                    ElevatedButton.icon(
                      onPressed: (){},
                      icon:const Icon(Icons.add),
                      label: const Text("Add Media"),
                    )
                  ],
                ),
              );
            }
            return boxes[index];
          },
        ),
      )
    );
  }
  // void _getMarkdownHeight() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final RenderBox renderBox =
  //         _markdownKey.currentContext!.findRenderObject() as RenderBox;
  //     setState(() {
  //       _markdownHeight = renderBox.size.height;
  //       _markdownWidth = renderBox.size.width;
  //     });
  //   });
  // }
}

Map<int,Function?> updates = {};
Map<int,Function?> changeOnevarUpdate = {};
Map<int,Function?> changeMultivarUpdate = {};
// customBox? currentObject;

// int p1 = 0;

class customBox extends StatefulWidget{
  customBox(size,{super.key, this.type = "ROW", this.parent, this.id=0}){
    children.add(TextEditingController());
    kindOfChildren.add('BOX');
    oneVar = 120; // width for column
    multVar.add(size); // height for column
    isPreview.add(true);
    updates[identityHashCode(this)] = null;
    childids.add(-1);
    changeMultivarUpdate[identityHashCode(this)] = null;
    changeOnevarUpdate[identityHashCode(this)] = null;
    alignments.add(Alignment.center);
    print(identityHashCode(this));
  }

  customBox? parent;
  int? id;
  List<Object> children = [];
  List<String> kindOfChildren = [];
  String type;
  late double oneVar;
  List<double> multVar = [];
  List<bool> isPreview = [];
  List<int> childids = [];
  List<Alignment> alignments = [];
  // List<GlobalKey<_customBoxState>?> _childKeys = [];

  void addChild(kindOfChild, numChild){
    if(type == "ROW"){
      if(kindOfChild == "BOX"){
        if(numChild == children.length - 1){
          children.add(TextEditingController());
          kindOfChildren.add('BOX');
          var size = multVar[numChild];
          multVar[numChild] = size*0.5;
          multVar.add(size*0.5);
          isPreview.add(true);
          childids.add(-1);
          alignments.add(Alignment.center);
          // _childKeys.add(null);
        }else{
          children.insert(numChild+1,TextEditingController());
          kindOfChildren.insert(numChild+1,'BOX');
          var size = multVar[numChild+1];
          multVar[numChild+1] = size*0.5;
          multVar.insert(numChild+1, size*0.5);
          isPreview.insert(numChild+1,true);
          childids.insert(numChild+1, -1);
          alignments.insert(numChild+1,Alignment.center);
          // _childKeys.insert(numChild+1,null);
        }
      }else if(kindOfChild == "COLUMN"){
        if(numChild == children.length - 1){
          // print("ff");
          multVar[numChild] = multVar[numChild]/2;
          multVar.add(multVar[numChild]);
          var temp = customBox(oneVar, type: "COLUMN", parent: this);
          // print("kk");
          temp.id = identityHashCode(temp);
          temp.oneVar = multVar[numChild];
          // _childKeys.add(GlobalKey<_customBoxState>());
          children.add(temp);
          kindOfChildren.add('COLUMN');
          isPreview.add(true);
          updates[identityHashCode(temp)] = null;
          childids.add(identityHashCode(temp));
          changeMultivarUpdate[identityHashCode(this)] = null;
          changeOnevarUpdate[identityHashCode(this)] = null;
          alignments.add(Alignment.center);
          // print(numChild);
          // currentObject = temp;
        }else{
          multVar[numChild] = multVar[numChild]/2;
          multVar.insert(numChild+1,multVar[numChild]);
          var temp = customBox(oneVar, type: "COLUMN", parent: this);
          temp.id = identityHashCode(temp);
          temp.oneVar = multVar[numChild];
          // _childKeys.insert(numChild+1,GlobalKey<_customBoxState>());
          children.insert(numChild+1,temp);
          kindOfChildren.insert(numChild+1,'COLUMN');
          isPreview.insert(numChild+1,true);
          updates[identityHashCode(temp)] = null;
          childids.insert(numChild+1,identityHashCode(temp));
          changeMultivarUpdate[identityHashCode(this)] = null;
          changeOnevarUpdate[identityHashCode(this)] = null;
          alignments.insert(numChild+1,Alignment.center);
          // currentObject = temp;
        }
      }
      // else if(kindOfChild == "ROW"){
      //   if(type != "ROW"){
      //   var size = multVar[numChild];
      //   children.add(customBox(size, type: "ROW", parent: this));
      //   kindOfChildren.add('ROW');
      //   }
      // }
    }else if(type == "COLUMN"){
      if(kindOfChild == "BOX"){
        if(numChild == children.length - 1){
          // print("kk");
          children.add(TextEditingController());
          kindOfChildren.add('BOX');
          var size = multVar[numChild] - 12;
          multVar[numChild] = size*0.5;
          multVar.add(size*0.5);
          isPreview.add(true);
          childids.add(-1);
          alignments.add(Alignment.center);
          // _childKeys.add(null);
        }else{
          children.insert(numChild+1,TextEditingController());
          kindOfChildren.insert(numChild+1,'BOX');
          var size = multVar[numChild+1] - 12;
          multVar[numChild+1] = size*0.5;
          multVar.insert(numChild+1, size*0.5);
          isPreview.insert(numChild+1,true);
          childids.insert(numChild+1, -1);
          alignments.insert(numChild+1,Alignment.center);
          // _childKeys.insert(numChild+1,null);
        }
      }
    }
  }

  void removeChild(numChild){
    if(type == "ROW" || type == "COLUMN"){
      if(children.length > 1){
        if(numChild == 0){
          multVar[numChild+1] += multVar[numChild] + ((type == "COLUMN") ? 6 : 0);
        }else{
          multVar[numChild-1] += multVar[numChild] + ((type == "COLUMN") ? 6 : 0);
        }
        multVar.removeAt(numChild);
        isPreview.remove(numChild);
        childids.removeAt(numChild);
        alignments.removeAt(numChild);
        kindOfChildren.removeAt(numChild);
        children.removeAt(numChild);
      }else{
        var temp_1 = -1;
        for(var i=0 ; i<parent!.childids.length ; i++){
          var temp = parent!.childids[i];
          if(temp == id){
            temp_1 = i;
            break;
          }
        }
        if(temp_1 > 0){
          // print(id);
          updates.remove(id);
          changeMultivarUpdate.remove(id);
          changeOnevarUpdate.remove(id);
          // print((type,parent!.childids,temp_1,id,numChild));
          parent!.removeChild(temp_1);
          updates[parent!.id]!();
          // print(updates);
          // print((parent!.childids,parent!.children));
        }
      }
    }
  }



  @override
  State<customBox> createState() => _customBoxState();
}

class _customBoxState extends State<customBox>{
  String _selectedHValue = "H-Center";
  String _selectedVValue = "V-Center";

  void initState(){
    print((widget.id));
    updates[widget.id!] = update;
    changeMultivarUpdate[widget.id!] = changeMultiVar;
    changeOnevarUpdate[widget.id!] = changeOneVar;
  }

  void update(){
    // print(widget.type);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context){
  
    return widget.type == "ROW" ? customRow() : customColumn();
  }

  void changePreview(numChild, b){
    widget.isPreview[numChild] = b;
  }

  void changeOneVar(del){
    widget.oneVar += del;
    if(widget.oneVar < 0){
      widget.oneVar -= del;
      return;
    }
    for(var i in widget.children){
      if( i.runtimeType == TextEditingController) continue;
      var temp = i as customBox;
      if(temp.type == "COLUMN"){
        temp.multVar[temp.multVar.length-1] += del;
        if(temp.multVar[temp.multVar.length-1] < 0){
          widget.oneVar -= del;
          temp.multVar[temp.multVar.length-1] -= del;
          return;
        }
        // print(widget.children);
        if(updates[temp.id] != null){
          updates[temp.id]!();
        }
      }
    }
  }

  void changeMultiVar(numChild, del){
    if(numChild < widget.kindOfChildren.length - 1){
      widget.multVar[numChild] += del;
      if(widget.multVar[numChild] < 0){
        widget.multVar[numChild] -= del;
        return;
      }
      widget.multVar[numChild+1] -= del;
      if(widget.multVar[numChild+1] < 0){
        widget.multVar[numChild] -= del;
        widget.multVar[numChild+1] += del;
        return;
      }
      for(var i in widget.children){
        if( i.runtimeType == TextEditingController) continue;
        var temp = i as customBox;
        if(temp.type == "COLUMN"){
          print(updates);
          // print(("gg",updates[temp.id]));
          if(updates[temp.id] != null){
            updates[temp.id]!();
          }
        }
      }
    }
  }

  void updateAlignment(index){
    if(_selectedHValue == "H-Center" && _selectedVValue == "V-Center"){
      widget.alignments[index] = Alignment.center;
    }else{
      if(_selectedHValue == "Left" && _selectedVValue == "V-Center"){
        widget.alignments[index] = Alignment.centerLeft;
      }else if(_selectedHValue == "Right" && _selectedVValue == "V-Center"){
        widget.alignments[index] = Alignment.centerRight;
      }else if(_selectedHValue == "H-Center" && _selectedVValue == "Top"){
        widget.alignments[index] = Alignment.topCenter;
      }else if(_selectedHValue == "H-Center" && _selectedVValue == "Bottom"){
        widget.alignments[index] = Alignment.bottomCenter;
      }else if(_selectedHValue == "Left" && _selectedVValue == "Top"){
        widget.alignments[index] = Alignment.topLeft;
      }else if(_selectedHValue == "Right" && _selectedVValue == "Top"){
        widget.alignments[index] = Alignment.topRight;
      }else if(_selectedHValue == "Right" && _selectedVValue == "Bottom"){
        widget.alignments[index] = Alignment.bottomRight;
      }else if(_selectedHValue == "Left" && _selectedVValue == "Bottom"){
        widget.alignments[index] = Alignment.bottomLeft;
      }
    }
    setState((){
    });
  }

  Widget customRow(){
    // print(widget.children);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
        widget.children.length,
        (index){
          if(widget.kindOfChildren[index] == "BOX"){
            return GestureDetector(
              onLongPress: ()async {
                await cellDialog(index);
              },
              child: customChild(index, widget.multVar[index], widget.oneVar, widget.isPreview[index], widget.children[index] as TextEditingController, widget.alignments[index])
            );
            // return Text("");
          }else if(widget.kindOfChildren[index] == "COLUMN"){
            var temp = (widget.children[index] as customBox);
            temp.oneVar = widget.multVar[index];
            // temp.multVar[temp.multVar.length-1] = widget.oneVar;
            if(updates[widget.childids[index]] != null){
              // print("jj");
              updates[widget.childids[index]]!();
            }
            // print(("a",widget.childids[index]));
            return widget.children[index] as customBox;
            // return Text("data");
          }
          return const Text("Something row");
        }
      )
    );
  }

  Future<dynamic> cellDialog(int index) async{
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.start,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  widget.addChild("BOX", index);
                  Navigator.pop(context);
                });
              },
              child: const Row(
                children: [
                  Icon(Icons.add),
                  Text("Add Box")
                ],
              ),
            ),
            const SizedBox(height: 16,),
            if(widget.type == "ROW")
              GestureDetector(
                onTap: (){
                  setState(() {
                    widget.addChild("COLUMN", index);
                    Navigator.pop(context);
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.add),
                    Text("Add Column")
                  ],
                ),
              ),
            if(widget.type == "ROW")
              const SizedBox(height: 16,),
            GestureDetector(
              onTap: (){
                widget.removeChild(index);
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: const Row(
                children: [
                  Icon(Icons.delete),
                  Text("Delete Box")
                ],
              ),
            ),
            const SizedBox(height: 16,),
            GestureDetector(
              onTap: (){
                Clipboard.setData(ClipboardData(text:(widget.children[index] as TextEditingController).text));
                Navigator.pop(context);
              },
              child: const Row(
                children: [
                  Icon(Icons.select_all),
                  Text("SeleteAll")
                ],
              ),
            ),
            const SizedBox(height: 16,),
            Container(
              height: 2,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  onTap: (){
                    _selectedHValue = "H-Center";
                    _selectedVValue = "V-Center";
                    setState(() {
                      updateAlignment(index);
                      Navigator.pop(context);
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left:12.0),
                    child: Text("Center"),
                  )
                ),
              ],
            ),
            const SizedBox(height: 8,),
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
                          updateAlignment(index);
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
                          updateAlignment(index);
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
                          updateAlignment(index);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    const Text("Right")
                  ],
                )
              ]
            ),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children:[
                Row(
                  children: [
                    Radio<String>(
                      value: 'Top',
                      groupValue: _selectedVValue,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedVValue = value!;
                          updateAlignment(index);
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
                          updateAlignment(index);
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
                          updateAlignment(index);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    const Text("Bottom")
                  ],
                )
                
              ]
            ),
          ],
        )
      );
    });
  }

  Widget customColumn(){
    // print(widget.children);
    // return Text("Hello");
    // print("Hello");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.children.length,
        (index){
          if(widget.kindOfChildren[index] == "BOX"){
            // print((widget.oneVar, widget.multVar));
            return GestureDetector(
              onLongPress: (){
                cellDialog(index);
              },
              child: customChild(index, widget.oneVar, widget.multVar[index], widget.isPreview[index], widget.children[index] as TextEditingController,widget.alignments[index])
            );
            // return Text("data");
          }else{
            return widget.children[index] as customBox;
          }
        }
      )
    );
  }

  Widget customChild(int numChild, double width,double height,bool isPreview, TextEditingController controller, alignment){

    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: alignment,
              decoration: BoxDecoration(border: Border.all(color: Colors.black.withOpacity(0.2))),
              width: width-12,
              height: height,
              child: !isPreview
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
                    contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Write"
                  ),
                onTapOutside: (v) {
                  setState(() {
                    // isPreview = true;
                    changePreview(numChild,true);
                  });
                },
              )
              : GestureDetector(
                onTap: () {
                  setState(() {
                    // isPreview = false;
                    changePreview(numChild,false);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.01)),
                  width: width-16,
                  height: height-16,
                  alignment: alignment,
                  padding: const EdgeInsets.all(16),
                  child: MarkdownBody(
                    selectable: true,
                    data: controller.text,
                    styleSheet: MarkdownStyleSheet(
                      h1: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      h2: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                      p: const TextStyle(fontSize: 16),
                      strong: const TextStyle(fontSize: 18,fontWeight:FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onVerticalDragUpdate: (v){
                // height = height + v.delta.dy;
                if(widget.type == "ROW"){
                  changeOneVar(v.delta.dy);
                }else{
                  if(numChild == widget.children.length - 1 && widget.parent != null){
                    var temp = widget.parent!;
                    changeOnevarUpdate[temp.id]!(v.delta.dy);
                    updates[temp.id]!();
                    // widget.multVar[numChild] += v.delta.dy;
                  }else{
                    changeMultiVar(numChild,v.delta.dy);
                  }
                }
                setState(() {
                });
              },
              child: Container(
                decoration: const BoxDecoration(color: Colors.orange),
                child: SizedBox(height: 12, width:width-12)),
            )
          ],
        ),
        GestureDetector(
          onHorizontalDragUpdate: (v){
            // width = width! + v.delta.dx;
            if(widget.type == "COLUMN"){
              if(widget.parent != null){
                var temp = widget.parent!;
                var temp_1 = -1;
                for(var i =0 ; i<temp.children.length ; i++){
                  if(temp.children[i].runtimeType == TextEditingController) continue;
                  var t1 = temp.children[i] as customBox;
                  if(t1.id == widget.id){
                    temp_1 = i;
                    break;
                  }
                }
                if(temp_1 >=0 && temp_1 < temp.children.length - 1){
                  changeMultivarUpdate[temp.id]!(temp_1, v.delta.dx);
                  updates[temp.id]!();
                }
              }else{
                changeOneVar(v.delta.dx);
              }
            }else{
              changeMultiVar(numChild,v.delta.dx);
            }
            setState(() {
            });
          },
          child: Container(
            decoration: const BoxDecoration(color: Colors.orange),
            child: SizedBox(height:height , width:12)),
        )
      ],
    );
  }
}