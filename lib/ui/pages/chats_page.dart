// import 'package:flutter_chat/chatData.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:goedit/blocs/chat_bloc.dart';
import 'package:goedit/models/chat.model.dart';
import 'package:goedit/models/message.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/ui/widgets/cards.dart';
import 'package:goedit/ui/widgets/loading.dart';
import 'package:goedit/utils/global_navigation.dart';
// import 'package:flutter_chat/chatWidget.dart';

/// ***********************
/// CHAT PAGE
/// ***********************
class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    chatBloc.init();
    chatBloc.getChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildChatTile(Chat chat) {
      return ListTile(
        leading: buildRoundedCornerImage(imageUrl: chat.user.imageUrl),
        title: Text(
          chat.user.unifiedName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          chat.messages.first.text ?? '',
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          // open specific user chat screen
          GlobalNavigation.key.currentState.push(MaterialPageRoute(
              builder: (context) => OneToOneChat(
                    user: chat.user,
                  )));
        },
      );
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: StreamBuilder(
        stream: chatBloc.chats,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LoadSpinner(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return _buildChatTile(snapshot.data.elementAt(index));
              });
        },
      ),
    );
  }
}

/// ***********************
/// ONE TO ONE
/// ***********************
class OneToOneChat extends StatefulWidget {
  final User user;
  OneToOneChat({@required this.user});
  @override
  _OneToOneChatState createState() => _OneToOneChatState();
}

class _OneToOneChatState extends State<OneToOneChat> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    messagesBloc.init(widget.user, _scrollController);
    messagesBloc.getAllMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.unifiedName),
      ),
      body: StreamBuilder(
        stream: messagesBloc.messages,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LoadSpinner(),
            );
          }
          return DashChat(
            user: ChatUser(
                name: messagesBloc.currentUser.unifiedName,
                avatar: messagesBloc.currentUser.imageUrl,
                uid: messagesBloc.currentUser.sId),
            messages: snapshot.data,
            scrollController: _scrollController,
            inputDecoration: InputDecoration(
              hintText: "Type your message here",
              border: InputBorder.none,
            ),
            onSend: (ChatMessage message) {
              messagesBloc.createMessage(message);
            },
            showUserAvatar: false,
          );
        },
      ),
    );
  }
}
