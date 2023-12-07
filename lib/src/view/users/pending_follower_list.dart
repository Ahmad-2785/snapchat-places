import 'package:flutter/material.dart';
import 'package:snapchat/src/view/users/pending_follower_list_card.dart';

class PendingFollowersLists extends StatefulWidget {
  const PendingFollowersLists({
    super.key,
    required this.pendingFollowers,
  });

  final List pendingFollowers;

  @override
  State<PendingFollowersLists> createState() => _PendingFollowersListsState();
}

class _PendingFollowersListsState extends State<PendingFollowersLists> {
  @override
  Widget build(BuildContext context) {
    return widget.pendingFollowers.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            shrinkWrap: true,
            itemCount: widget.pendingFollowers.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                clipBehavior: Clip.hardEdge,
                color: Theme.of(context).colorScheme.secondary,
                elevation: 0,
                child: PendingFollowersListsCard(userKey: widget.pendingFollowers[index]),
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
