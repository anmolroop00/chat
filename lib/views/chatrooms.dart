import 'package:chat/helper/authenticate.dart';
import 'package:chat/helper/constants.dart';
import 'package:chat/helper/helperfunction.dart';
import 'package:chat/helper/theme.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/services/database.dart';
import 'package:chat/views/chat.dart';
import 'package:chat/views/search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'ChatApp',
          style: GoogleFonts.mcLaren(textStyle: TextStyle(fontWeight: FontWeight.bold)),
        ),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()
            )
          );
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsTile({this.userName,@required this.chatRoomId,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Chat(
            chatRoomId: chatRoomId,
          )
        ));
      },
      child: 
        Card(
          clipBehavior: Clip.antiAlias,
          color: Colors.red[100],
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3.5),
          elevation: 5,
          child: Row(
            children: [
              CircleAvatar(
                radius: 30.0,
                child: Text(
                  userName.substring(0,1).toUpperCase(), 
                  style:GoogleFonts.pacifico(textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                ),
              ),
              SizedBox(width: 20,),
              Text(
                userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

