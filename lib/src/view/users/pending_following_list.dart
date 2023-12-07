import 'package:flutter/material.dart';
import 'package:snapchat/src/view/users/UserCard.dart';

class PendingFollowingsLists extends StatefulWidget {
  const PendingFollowingsLists({
    super.key,
    required this.pendingFollowings,
  });

  final List pendingFollowings;

  @override
  State<PendingFollowingsLists> createState() => _PendingFollowingsListsState();
}

class _PendingFollowingsListsState extends State<PendingFollowingsLists> {
  @override
  Widget build(BuildContext context) {
    return widget.pendingFollowings.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            shrinkWrap: true,
            itemCount: widget.pendingFollowings.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                clipBehavior: Clip.hardEdge,
                color: Theme.of(context).colorScheme.secondary,
                elevation: 0,
                child: UserCard(userKey: widget.pendingFollowings[index]),
              );
            },
          )
        : Center(
            child: Text(
            "There are no actions",
            style: Theme.of(context).textTheme.titleSmall,
          ));
  }
}
