
# Chat Application

Improved version of the open source Flutter project
Chat with friends.
Thanks to previous author.


## Features : 

- Sign in - SignUp - logout
- linking with Firebase Authentication system
- client and backend validation during logging and register
- search by name of users
- real-time send and receive messages using stream and linking with Firebaes Firestore database
- viewing profile page and able to edit info and upload images
- use pagination for showing the messages and also for friends list
- nice looking UI and user-friendly animation with a splash screen at the beginning
- using [Bloc](https://bloclibrary.dev/) for state management
- using [Get-it](https://pub.dev/packages/get_it) as a Service Locator for dependency injection
- added media messages, video, images, player
- upload media to firestore account
- cash all media and messages by [Hive](https://pub.dev/packages/hive)
- image network cache manager [cached_network_image](https://pub.dev/packages/cached_network_image) with dependencies (flutter, flutter_cache_manager, octo_image)
- cache video player (cached_video_player)
- now works from cache without network connection
