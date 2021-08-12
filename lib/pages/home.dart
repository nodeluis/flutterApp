import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands=[
    Band(id: '1',name: 'metallica', votes: 4),
    Band(id: '2', name: 'aerosmith', votes: 2),
    Band(id: '3', name: 'queen', votes: 5),
  ];
  
  /*void main() { 
    for (var i = 4; i < 50; i++) {
      this.bands.add(Band(id: '$i',name: 'metallica', votes: 4));
      print(i);
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Band names',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index)=>_bandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
   );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        print('${band.id}');
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete band', style: TextStyle(color: Colors.white),),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title:Text(band.name),
        trailing: Text('${band.votes}',style: TextStyle(fontSize: 20),),
        onTap: (){
          print(band.name);
        },
      ),
    );
  }

  addNewBand(){

    final textController=new TextEditingController();

    if(Platform.isAndroid){
      return showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: Text('New band'),
            content:  TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: ()=>addBandToList(textController.text),
                elevation: 5,
                textColor: Colors.blue,
                child: Text('add'),
              )
            ],
          );
        },
        
      );
    }
    showCupertinoDialog(context: context, builder: ( _ ){
      return CupertinoAlertDialog(
        title: Text('new band name'),
        content: TextField(
          controller: textController,
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child:Text('Add'),
            onPressed: ()=>addBandToList(textController.text),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child:Text('dismiss'),
            onPressed: ()=>Navigator.pop(context),
          )
        ],
      );
    });
  }

  void addBandToList(String name){
    if(name.length>1){
      this.bands.add(new Band(id:DateTime.now().toString(),name:name,votes:0));
      setState(() {});
    }
    Navigator.pop(context);
  }

}