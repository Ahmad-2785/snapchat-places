import 'package:flutter/material.dart';
import 'package:snapchat/src/view/users/UserCard.dart';

class FollowersLists extends StatefulWidget {
  const FollowersLists({
    super.key,
    required this.followers,
  });

  final List followers;

  @override
  State<FollowersLists> createState() => _FollowersListsState();
}

class _FollowersListsState extends State<FollowersLists> {
  @override
  Widget build(BuildContext context) {
    return widget.followers.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            shrinkWrap: true,
            itemCount: widget.followers.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                clipBehavior: Clip.hardEdge,
                color: Theme.of(context).colorScheme.secondary,
                elevation: 0,
                child: UserCard(userKey: widget.followers[index]),
              );
            },
          )
        : Center(
            child: Text(
            "There are no followers",
            style: Theme.of(context).textTheme.titleSmall,
          ));
  }
}
