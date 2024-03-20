import 'package:flutter/material.dart';
import 'package:chat_app/models/chatUsersModel.dart';
import 'package:chat_app/widgets/conversationList.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsers> chatUsers = [
    ChatUsers(name: "Alice Johnson", messageText: "Just finished the project report!", imageURL: "images/userImage1.jpg", time: "Now"),
    ChatUsers(name: "Bob Smith", messageText: "Let's meet for the team lunch tomorrow.", imageURL: "images/userImage2.jpg", time: "Yesterday"),
    ChatUsers(name: "Charlie Brown", messageText: "Can you review my code?", imageURL: "images/userImage3.jpg", time: "31 Mar"),
    ChatUsers(name: "David Williams", messageText: "The client meeting is rescheduled to 2 PM.", imageURL: "images/userImage4.jpg", time: "28 Mar"),
    ChatUsers(name: "Eva Davis", messageText: "The design assets are updated in the drive.", imageURL: "images/userImage5.jpg", time: "23 Mar"),
    ChatUsers(name: "Frank Miller", messageText: "I'll be working from home tomorrow.", imageURL: "images/userImage6.jpg", time: "17 Mar"),
    ChatUsers(name: "Grace Lee", messageText: "Can we discuss the new feature implementation?", imageURL: "images/userImage7.jpg", time: "24 Feb"),
    ChatUsers(name: "Harry Wilson", messageText: "How about a brainstorming session for the new UI?", imageURL: "images/userImage8.jpg", time: "18 Feb"),
  ]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16,right: 16,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text("Dialog",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
                    Container(
                      padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromARGB(255, 205, 221, 252),
                      ),
                      child: const Row(
                        children: <Widget>[
                          Icon(Icons.add,color: Color.fromARGB(255, 81, 81, 81),size: 20,),
                          SizedBox(width: 2,),
                          Text("Add new member",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ],                  
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),                    

            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return ConversationList(
                  name: chatUsers[index].name,
                  messageText: chatUsers[index].messageText,
                  imageUrl: chatUsers[index].imageURL,
                  time: chatUsers[index].time,
                  isMessageRead: (index == 0 || index == 3)?true:false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}