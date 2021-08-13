import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socker_service.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands=[
    //Band(id: '1',name: 'metallica', votes: 4),
    //Band(id: '2', name: 'aerosmith', votes: 2),
    //Band(id: '3', name: 'queen', votes: 5),
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context,listen: false);

    socketService.socket.on('active-bands',(payload){
      this.bands= (payload as List).map((band) => Band.fromMap(band))
      .toList();
      //para redibujar el widget completo
      setState(() {});
    });

    super.initState();
  }

  //eliminar la escucha cuando se destruya esta vista

  @override
  void dispose() {

    final socketService = Provider.of<SocketService>(context,listen: false);
    socketService.socket.off('active-bands');

    super.dispose();
  }
  
  /*void main() { 
    for (var i = 4; i < 50; i++) {
      this.bands.add(Band(id: '$i',name: 'metallica', votes: 4));
      print(i);
    }
  } */

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Band names',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child:
              socketService.serverStatus==ServerStatus.Online
              ?Icon(Icons.check_circle,color: Colors.blue[300],)
              :Icon(Icons.offline_bolt,color: Colors.red,)
          )
        ] ,
      ),
      body: Column(
        children:[
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context, int index)=>_bandTile(bands[index]),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
   );
  }

  Widget _bandTile(Band band) {

    //listen en false, por q no necesito redibujar este widget
    final socketService=Provider.of<SocketService>(context,listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        socketService.emit('delete-band',{'id':band.id});
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
          socketService.socket.emit('vote-band',{'id':band.id});
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
      final socketService=Provider.of<SocketService>(context,listen: false);
      socketService.emit('new-band',{'name':name});
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    this.bands.forEach((band) { 
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });
    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(dataMap: dataMap),
    ); 
  }

}