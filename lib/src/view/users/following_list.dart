import 'package:flutter/material.dart';
import 'package:snapchat/src/view/users/UserCard.dart';

class FollowingsLists extends StatefulWidget {
  const FollowingsLists({
    super.key,
    required this.followings,
  });

  final List followings;

  @override
  State<FollowingsLists> createState() => _FollowingsListsState();
}

class _FollowingsListsState extends State<FollowingsLists> {
  @override
  Widget build(BuildContext context) {
    return widget.followings.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            shrinkWrap: true,
            itemCount: widget.followings.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                clipBehavior: Clip.hardEdge,
                color: Theme.of(context).colorScheme.secondary,
                elevation: 0,
                child: UserCard(userKey: widget.followings[index]),
              );
            },
          )
        : Center(
            child: Text(
            "There are no followings",
            style: Theme.of(context).textTheme.titleSmall,
          ));
  }
}
