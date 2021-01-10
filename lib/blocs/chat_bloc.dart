import 'package:dash_chat/dash_chat.dart';
import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/chat.model.dart';
import 'package:goedit/models/message.dart';
import 'package:goedit/models/name.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/repositories/job.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc {
  BehaviorSubject<List<Chat>> _chatsController;

  Stream get chats => _chatsController.stream;

  init() {
    _chatsController = BehaviorSubject<List<Chat>>();
  }

  getChats() async {
    try {
      // construct query first
      Map<String, dynamic> queryParams = {
        'sender': mainBloc.userProfileObject.sId
      };

      // make the call
      var res = await JobRepo.getAllChats(queryParams);
      List<Chat> chats = res['entries'];
      // res['entries'].forEach((v) {
      //   chats.add();
      //   messages.add(ChatMessage(
      //     text: v.text,
      //     user: ChatUser(name: v.sender.unifiedName, avatar: v.sender.imageUrl),
      //   ));
      // });
      _chatsController.sink.add(chats);
    } catch (exc) {
      /// check if error was due to auth token
      if (exc is RequestException) {
        if (exc.errorKey == 'JWT_MISSING' ||
            exc.errorKey == 'JWT_EXPIRED' ||
            exc.errorKey == 'JWT_INVALID') {
          mainBloc.logout();
        }
        // alert(exc.message);
      } else {
        // alert(exc.toString());
      }
    } finally {
      // _isLoadingUsersController.add(false);
    }
    // List<Chat> _chats = [
    //   new Chat(
    //     user: User(
    //       name: Name(firstName: 'Ali', lastName: 'Hussam'),
    //     ),
    //     messages: [
    //       Message(text: 'Hi'),
    //       Message(text: 'Hi'),
    //       Message(text: 'Hi'),
    //     ],
    //   ),
    // ];
  }

  dispose() {
    _chatsController.close();
  }
}

final chatBloc = new ChatBloc();

class MessagesBloc {
  User _user;
  User currentUser = mainBloc.userProfileObject;
  BehaviorSubject<List<ChatMessage>> _messagesController;

  Stream get messages => _messagesController.stream;

  init(User user) {
    _user = user;
    _messagesController = BehaviorSubject<List<ChatMessage>>();
  }

  createMessage(ChatMessage message) async {
    try {
      // construct query first
      Message newMessage = Message(text: message.text, recieverId: _user.sId);

      // make the call
      var res = await JobRepo.createMessage(newMessage);
      Message temp = res['message'];
      List<ChatMessage> messages = _messagesController.value;
      messages.add(ChatMessage(
          text: temp.text,
          user: ChatUser(
              name: temp.sender.unifiedName,
              avatar: temp.sender.imageUrl,
              uid: temp.sender.sId)));
      _messagesController.add(messages);
    } catch (exc) {
      /// check if error was due to auth token
      if (exc is RequestException) {
        if (exc.errorKey == 'JWT_MISSING' ||
            exc.errorKey == 'JWT_EXPIRED' ||
            exc.errorKey == 'JWT_INVALID') {
          mainBloc.logout();
        }
        // alert(exc.message);
      } else {
        // alert(exc.toString());
      }
    } finally {
      // _isLoadingUsersController.add(false);
    }
  }

  getAllMessages() async {
    try {
      // construct query first
      Map<String, dynamic> queryParams = {'user': _user.sId};

      // make the call
      var res = await JobRepo.getAllMessages(queryParams);
      List<ChatMessage> messages = new List<ChatMessage>();
      res['entries'].forEach((Message v) {
        messages.add(ChatMessage(
          text: v.text,
          user: ChatUser(
              name: v.sender.unifiedName,
              avatar: v.sender.imageUrl,
              uid: v.sender.sId),
        ));
      });
      _messagesController.add(messages);
    } catch (exc) {
      /// check if error was due to auth token
      if (exc is RequestException) {
        if (exc.errorKey == 'JWT_MISSING' ||
            exc.errorKey == 'JWT_EXPIRED' ||
            exc.errorKey == 'JWT_INVALID') {
          mainBloc.logout();
        }
        // alert(exc.message);
      } else {
        // alert(exc.toString());
      }
    } finally {
      // _isLoadingUsersController.add(false);
    }
  }

  dispose() {
    _messagesController.close();
  }
}

final messagesBloc = new MessagesBloc();
