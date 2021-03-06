import 'package:band_names/services/socker_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/pages/status.dart';
import 'package:band_names/pages/home.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //cuantas instancias quiero de mi objeto
      providers:[
        ChangeNotifierProvider(create: (_)=>SocketService(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: { 
          'home':( _ )=> HomePage(),
          'status':( _ )=> StatusPage(), 
        },
      ),
    );
  }
}