
import 'package:dartchat/models/user_chat.dart';
import 'package:dartchat/models/user_presentation.dart';
import 'package:dartchat/services/hive_service/adapters/adapter-models/user_presentation_hive.dart';
import 'package:dartchat/utils/functions.dart';
import 'package:dartchat/view/friends/bloc/friends_bloc.dart';
import 'package:dartchat/view/friends/widgets/friends_list_item.dart';
import 'package:dartchat/view/utils/constants.dart';
import 'package:dartchat/view/utils/device_config.dart';
import 'package:dartchat/view/widgets/fade_in_widget.dart';
import 'package:dartchat/view/widgets/progress_indicator.dart';
import 'package:dartchat/view/widgets/try_again_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({Key key}) : super(key: key);
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  List<UserPresentation> allUsers;
  List<UserPresentation> filterdUsers;

  ScrollController _scrollController;
  bool noMoreFriends = false;
  FriendsBloc friendsBloc;
  @override
  void initState() {
    friendsBloc = BlocProvider.of<FriendsBloc>(context)
      ..add(FriendsStartFetching());
    _scrollController = ScrollController();
    _scrollController.addListener(() => _scrollListener());
    _initHive();
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange &&
          !noMoreFriends) {
        friendsBloc.add(MoreFriendsFetched(_scrollController.position.pixels));
      }
    }
  }

  void _initHive() async {
    var boxVar = await Hive.openBox('users-presentation');
    String imageTypeUser;

    if (allUsers != null) {
      try {
         for (int i = 0; i < boxVar.length; i++) {
            UserPresentationHive userBox = boxVar.get(i);
            UserPresentation userPresentation = new UserPresentation(
              currentUserId: userBox.currentUserId,
              lastMessage: userBox.lastMessage,
              lastMessageSenderId: userBox.lastMessageSenderId,
              lastMessageTime: userBox.lastMessageTime,
              name: userBox.name,
              imgUrl: userBox.imgUrl,
              imageType: userBox.imageType == "assets" ? ImageType.assets: ImageType.network,
              userId: userBox.userId,
              email: userBox.email,
              lastMessageSeen: userBox.lastMessageSeen
            );
            allUsers[i] = userPresentation;
         }
      } catch (e) { print(e); }
    }
  }

  @override
  void dispose() {
    friendsBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DeviceData deviceData = DeviceData.init(context);

    return BlocConsumer<FriendsBloc, FriendsState>(
      listener: (context, state) {
        _mapStateToActions(state);
      },
      builder: (context, state) {
        var users;
        if (filterdUsers != null) {
          users = filterdUsers;
        } else {
          users = allUsers;
        }
        return state is SearchLoading
            ? Padding(
                padding: EdgeInsets.only(top: deviceData.screenHeight * 0.05),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: const CircleProgress(
                      radius: 0.03,
                    )),
              )
            : state is SearchFailed
                ? Padding(
                    padding:
                        EdgeInsets.only(top: deviceData.screenHeight * 0.05),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        state.failure.code,
                        style: TextStyle(
                            color: kBackgroundButtonColor,
                            fontSize: deviceData.screenHeight * 0.02),
                      ),
                    ),
                  )
                : users != null
                    ? users.length < 1
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: state is SearchSucceed
                                    ? deviceData.screenHeight * 0.05
                                    : 0),
                            child: Align(
                              alignment: state is SearchSucceed
                                  ? Alignment.topCenter
                                  : Alignment.center,
                              child: Text(
                                state is SearchSucceed
                                    ? "No users with this name."
                                    : "No users yet.",
                                style: TextStyle(
                                    color: kBackgroundButtonColor,
                                    fontSize: deviceData.screenHeight * 0.019),
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              FadeIn(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: users.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final UserPresentation user = users[index];
                                    return FadeIn(
                                      child: FriendsListItem(user: user),
                                      delay: 50 * index.toDouble(),
                                    );
                                  },
                                ),
                              ),
                              state is MoreFriendsLoading
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              deviceData.screenHeight * 0.01),
                                              child: Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: const CircleProgress(
                                                    radius: 0.03,
                                                  )),
                                    )
                                  : SizedBox.shrink()
                            ],
                          )
                    : state is FriendsLoading
                        ? const Center(child: CircleProgress())
                        : TryAgain(
                            doAction: () => 
                              BlocProvider.of<FriendsBloc>(context).add(FriendsStartFetching())
                          );
      },
    );
  }

  void _mapStateToActions(FriendsState state) {
    if (Functions.modalIsShown) {
      Navigator.pop(context);
      Functions.modalIsShown = false;
    }
    if (state is FriendsLoadFailure) {
      Functions.showBottomMessage(context, state.failure.code);
    }
    if (state is FriendsLoadSuccess) {
      if (_scrollController.hasClients && state.scrollposition != 0) {
        _scrollController.jumpTo(state.scrollposition);
      }
      allUsers = state.friends;
      _saveFriendsHive();
      if (state.noMoreFriends != null) {
        noMoreFriends = state.noMoreFriends;
      }
    } else if (state is MoreFriendsFailure) {
      Functions.showBottomMessage(context, state.failure.code);
    } else if (state is SearchSucceed) {
      filterdUsers = state.friends;
    } else if (state is EmptySearchField) {
      filterdUsers = null;
    }
  }

  void _saveFriendsHive() async {
    var boxVar = await Hive.openBox('users-presentation');
    await boxVar.clear();
    String imageTypeUser;

    for (int i = 0; i < allUsers.length; i++) {
      if (allUsers[i].imageType == ImageType.assets) { 
        imageTypeUser = "assets"; 
      } else imageTypeUser = "network";
      UserPresentationHive allUsersHive = new UserPresentationHive(
        allUsers[i].lastMessage, 
        allUsers[i].lastMessageSenderId, 
        allUsers[i].lastMessageTime, 
        allUsers[i].lastMessageSeen, 
        allUsers[i].name, 
        allUsers[i].email, 
        allUsers[i].imgUrl, 
        imageTypeUser, 
        allUsers[i].userId, 
        allUsers[i].currentUserId
      );
      await boxVar.put(i, allUsersHive);
    }
    boxVar.compact().then((_) => { boxVar.close() });
  }
}
