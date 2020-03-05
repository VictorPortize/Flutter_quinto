import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:quinto_projeto/ui/gif-page.dart';

const url = 'https://api.giphy.com/v1/gifs/trending?api_key=H89UOLafS8aUYc1nCUxYJTBtl35XCuKb&limit=24&rating=G';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _search;
  int _offset = 0;
  
  void _changeSearch( text ){
    setState(() {
      _search = text;
      _offset = 0;
    });
  }

  void _loadMore(){
    setState(() {
      _offset += 24;
    });
  }


  Future<Map> _getGifs() async {
    http.Response response;

    if( _search == null || _search.isEmpty ){
      response = await http.get(url);
    }else{
      response = await http.get('https://api.giphy.com/v1/gifs/search?api_key=H89UOLafS8aUYc1nCUxYJTBtl35XCuKb&q=$_search&limit=25&offset=$_offset&rating=G&lang=en');
    }
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title : Image.network('https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              onSubmitted: _changeSearch,
              decoration: InputDecoration(
                labelText: 'Pesquise aqui',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: ( context, snapshot){
                switch( snapshot.connectionState ){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,

                      ),
                    );
                  default:
                    if( snapshot.hasError ){
                      return Container(

                      );
                    }else return _createGifTable(context, snapshot);
                }
              },
            ),
          )
        ],
      )
    );
  }
 
  int _getCount( List data){
    if( _search == null){
      return data.length;
    }else{
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index){
        if( _search == null || index < snapshot.data["data"].length ){
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data['data'][index]["images"]["fixed_height"]['url'],
              height: 300.0,
              fit: BoxFit.cover
            ),
            onTap: (){
              Navigator.push( context, 
              MaterialPageRoute(builder: ( context ){
                return GifPage(snapshot.data['data'][index]);
              }));
            },
            onLongPress: (){
              Share.share(
                snapshot.data['data'][index]["images"]["fixed_height"]['url']
              );              
            },
          );
        }else{
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 70,),
                  Text("Carregar mais...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0
                    ),
                  )
                ],
              ),
              onTap: _loadMore,
            ),
          );
        }
      }
    );
  }
}


// Image.network(
//               snapshot.data['data'][index]["images"]["fixed_height"]['url'],
//               height: 300.0,
//               fit : BoxFit.cover
//               ),

