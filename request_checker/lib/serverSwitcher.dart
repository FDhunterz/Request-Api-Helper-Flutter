import 'package:flutter/material.dart';
import 'request_api_helper.dart';

class ServerSwitcher extends StatefulWidget{
  /// List > Map Data [{'name' : 'Server 1','id' : 'http://192.168.0.101/myproject' //root folder project}]
  final List servers;
  ServerSwitcher({this.servers});
  button(context){
    return _ServerSwitcher().button(context);
  }
  @override
  _ServerSwitcher createState()=>_ServerSwitcher();
}

class _ServerSwitcher extends State<ServerSwitcher>
{
  String _selected;
  List _servers;
  TextEditingController _searching = TextEditingController();

  button(context)
  {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () async {
        await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.white.withOpacity(0),
          context: context,
          builder: (BuildContext context) => select(context),
        );
      },
    );
  }

  selected(id,context){
    _selected = id;
    Env(
        confnoapiurl: id,
        confurl: id+'api/',
      ).save();
    Navigator.pop(context);
    setState((){});
  }

  select(context)
  {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7 + MediaQuery.of(context).viewInsets.bottom,
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
        decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(10.0))),
        child : SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(
                  thickness: 2,
                  indent: MediaQuery.of(context).size.width * 0.35,
                  endIndent: MediaQuery.of(context).size.width * 0.35,
                ),
                Text(
                  'Select Server',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height:20),
                
                TextField(
                  controller: _searching,
                  onChanged: (val){
                    _searching = TextEditingController(text:val);
                    setState((){});
                  },
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: 'Searching...',
                      icon: Icon(Icons.search),
                      hintStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.black87)),
                      border:
                      OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                      )
                    ),
                  ),

                SizedBox(height:20),

                Container(
                  // height: MediaQuery.of(context).size.height * 0.5,
                  child: SingleChildScrollView(
                    child: Column(
                      children:_servers.length == 0 ? [] : _servers.where((value)=> value['name'].toString().toUpperCase().contains(_searching.text.toUpperCase())).map((value)=> 
                        ListTile(
                          leading: Icon(Icons.check, color: _selected == value['id'].toString() ? Colors.green : Colors.transparent,),
                          title: Text(value['name'],
                            style: TextStyle(
                              color: _selected == value['id'].toString() ? Colors.green : Colors.black,
                            )
                          ),
                          onTap: (){
                            selected(value['id'],context);
                          },
                        )
                      ).toList(),  
                    ),
                  ),
                )
              ],
            ), 
          ),
        )
      ),
    );
  }
  @override
  void initState() { 
    super.initState();
    _servers = widget.servers;
    _searching = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return button(context);
  }
}