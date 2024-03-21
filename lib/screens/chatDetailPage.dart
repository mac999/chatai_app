import 'package:flutter/material.dart';
import 'package:chat_app/models/chatMessageModel.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class ChatDetailPage extends StatefulWidget{
  const ChatDetailPage({super.key});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<ChatMessage> messages = [
    // Use the ChatMessage class
    ChatMessage(messageContent: "Hi.", messageType: "receiver"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(messageContent: "I am doing fine. au?", messageType: "sender"),
    ChatMessage(messageContent: "it's OK.", messageType: "receiver"),
    ChatMessage(messageContent: "What's your business", messageType: "sender"),
  ];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _textFocus = FocusNode();
  final _openAI = OpenAI.instance.build(
    token: '',
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 15),
    ),
    enableLog: true,
  );

  Future<void> getChatResponse(ChatMessage m) async {
    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: [
        {'messageContent': m.messageContent}
      ],
      maxToken: 200,
    );

    try {
      final response = await _openAI.onChatCompletion(request: request);
      for (var element in response!.choices) {
        if (element.message != null) {
          setState(() {
            messages.insert(
              0,
              ChatMessage(
                messageContent: element.message!.content,
                messageType: 'receiver',
              ),
            );
          });
        }
      }

      _scrollController.animateTo(
        _scrollController.position.extentBefore + _scrollController.position.viewportDimension - 60,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    } catch (e) {
      print('Exception type: ${e.runtimeType.toString()}');
      print('Exception details:\n ${e.toString()}');
    }
  }

  void _handleSubmitted(String text) {
    _textController.clear();

    ChatMessage message = ChatMessage(
      messageContent: text,
      messageType: 'sender', // replace with the actual sender's name
    );
    setState(() {
      messages.add(message);
    });

    _scrollController.animateTo(
      _scrollController.position.extentBefore + _scrollController.position.viewportDimension - 60,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );

    getChatResponse(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back,color: Colors.black,),
                ),
                const SizedBox(width: 2,),
                const CircleAvatar(
                  backgroundImage: NetworkImage("https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg3c35gVgzgMrzxptGpIRobw9NCrFAYv9vGtjZ4boBkinbYOtTIvdEVl-eqstSBul1MPx8N65Orf6jePjuV0w24bbvlqyV7K4xqXE2CyXQwRbh6TDU9G4qDXvDuaDeAR9k2f969UymHAM_04o49N_Rl25Qc5kVkvQk_ohS_8tQTNyP0/s220/profile.jpg"),
                  maxRadius: 20,
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("mac",style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                      const SizedBox(height: 6,),
                      Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                    ],
                  ),
                ),
                const Icon(Icons.settings,color: Colors.black54,),
              ],             
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              shrinkWrap: false,
              padding: const EdgeInsets.only(top: 10,bottom: 60),
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return Container(
                  padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                  child: Align(
                    alignment: (messages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messages[index].messageType  == "receiver"?Colors.grey.shade200:Colors.blue[200]),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(messages[index].messageContent, style: const TextStyle(fontSize: 15),),
                    ),
                  ),
                );
              },
            ),        
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: TextField(
                      focusNode: _textFocus,
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none
                      ),
                      onSubmitted: (text) {
                        _handleSubmitted(text);                      
                        _textFocus.requestFocus();
                      },
                    ),
                  ),
                  const SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){
                      _handleSubmitted(_textController.text);
                    },
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    child: const Icon(Icons.send,color: Colors.white,size: 18,),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}