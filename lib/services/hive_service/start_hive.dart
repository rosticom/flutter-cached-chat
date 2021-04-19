
// import 'dart:convert';

// import 'package:dartchat/models/user_presentation.dart';

// import 'adapters/adapter-models/chat_hive.dart';
// import 'adapters/adapter-models/last_hive.dart';
// import 'adapters/adapter-models/user_hive.dart';
// import 'adapters/last_messages_adapter.dart';
// import 'adapters/person_adapter.dart';

import 'package:hive/hive.dart';

// import 'adapters/chat_hive_adapter.dart';
// import 'adapters/last_hive_adapter.dart';
// import 'adapters/messages_list_adapter.dart';
import 'adapters/messages_list_adapter.dart';
import 'adapters/user_presentation_adapter.dart';


void startHive() async {
  
  String path = '/storage/emulated/0/Android/data/com.android.providers.cache/chat/test/hive2';
         Hive.init(path);
         Hive.registerAdapter(UserPresentationAdapter());    
         Hive.registerAdapter(MessageHiveAdapter());
      
}
        //   Hive.registerAdapter(LastHiveAdapter());
        //   var persons = await Hive.openBox<LastHive>('lastHiveTestFile');
        //   persons.clear();
          
        //   var mario = LastHive('Mario');
        //   var luna = LastHive('Luna');
        //   var alex = LastHive('Alex');
        //   persons.addAll([mario, luna, alex]);
          
        //   mario.friends = HiveList(persons); // Create a HiveList
        //   mario.friends.addAll([luna, alex]); // Update Mario's friends
        //   print(mario.friends);
          
        //   luna.delete(); // Remove Luna from Hive
        //   print(mario.friends); 

        //   print('mario friends');
        //   mario.friends.addAll([alex]);
        //   // _inventoryList = mario.friends.toList();
        //   // print(_inventoryList);
          
        // await boxVar.compact();
        // await boxVar.close();// Hive


      // Hive.registerAdapter(ChatHiveAdapter());
      // var _personBox = await Hive.openBox('chatHiveBox');
      // var dateTime = DateTime.utc(2020, 6, 6);
      // ChatHive persVas = new ChatHive(true, "Ross", "Hi! @mobs", "avatar", dateTime);
      // _personBox.add(persVas);
      // persVas = new ChatHive(false, "Boss", "Hi! @you", "avatar", dateTime);
      // _personBox.add(persVas);
      // persVas.senderName = "100";
      // persVas = _personBox.get(0);
      // // print(persVas.parsedJson['id']);
      // // Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(persVas));
      // print(persVas.senderName);
      // // friends.add(UserPresentation(currentUserId: ))
      // 
      // Hive.registerAdapter(UserPresentationAdapter());
      // Hive.registerAdapter(MessageHiveAdapter());
      


// @HiveType()
// class Person extends HiveObject {
//   @HiveField(0)
//   String name;

//   @HiveField(1)
//   HiveList friends;

//   Person(this.name);

//   String toString() => name; // For print()
// }

// class PersonAdapter extends TypeAdapter<Person> {
//   @override
//   final typeId = 0;

//   @override
//   Person read(BinaryReader reader) {
//     return Person(reader.read())..friends = reader.read();
//   }

//   @override
//   void write(BinaryWriter writer, Person obj) {
//     writer.write(obj.name);
//     writer.write(obj.friends);
//   }
// }













    // print(boxVar.get('darkMode'));
    // ..registerAdapter(PersonAdapter())
    // ..registerAdapter(LastMessagesAdapter());

  // var boxUser = await Hive.openBox<UserHive>('userBox2');
  // var boxLastMessages = await Hive.openBox<LastMessagesHive>('lastMessagesBox');

  // boxUser.put('david', UserHive('David'));
  // LastMessagesHive lastMessage;
  // lastMessage.chatId = 1;
  // lastMessage.lastMessage = 'last message text';
  // boxLastMessages.put('someStringId', LastMessagesHive('Hi'));

  // LastMessagesHive lastMessageChat = LastMessagesHive(1, 'Last Message', 'avatar', 'chat_time');
  // Hive.box('lastMessagesBox').put(1, "Some message text");

  // boxLastMessages.put('chatIdSomeString', LastMessagesHive(1, 'Last Message', 'avatar', 'chat_time'));
  // print(boxUser.values);
  // print("Box Last Messages: ");
  // print(boxLastMessages.values);
