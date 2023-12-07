import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:snapchat/src/data/users/users_services.dart';
import 'package:snapchat/src/view/profile/components/custom_input_decoration.dart';
import 'package:snapchat/src/view/users/UserCard.dart';

class UserSearchMenu extends StatefulWidget {
  const UserSearchMenu({super.key, required this.username});
  final username;
  @override
  State<UserSearchMenu> createState() => _UserSearchMenuState();
}

class _UserSearchMenuState extends State<UserSearchMenu> {
  List usersLists = [];
  final TextEditingController _textFieldController = TextEditingController();
  void searchUsers() async {
    final searchText = _textFieldController.value.text;
    if (searchText != "") {
      final users = await UserServices.searchUsers(searchText, widget.username);
      setState(() {
        usersLists = users;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      // color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 50,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  child: FormBuilderTextField(
                controller: _textFieldController,
                name: 'search',
                showCursor: false,
                onEditingComplete: () {
                  setState(() {
                    usersLists = [];
                  });
                  searchUsers();
                },
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
                decoration: CustomInputDecoration(
                    'Search',
                    const Icon(
                      Icons.search,
                      color: Color(0xFFA7ACAF),
                      size: 24,
                    ),
                    fillColor: Theme.of(context).colorScheme.tertiary),
              )),
              const SizedBox(
                width: 16,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _textFieldController.clear();
                  });
                },
                child: Container(
                  width: 48,
                  height: 48,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48),
                    ),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 24,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: usersLists.isNotEmpty
                ? ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    shrinkWrap: true,
                    itemCount: usersLists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        clipBehavior: Clip.hardEdge,
                        color: Theme.of(context).colorScheme.secondary,
                        elevation: 0,
                        child: UserCard(userKey: usersLists[index]),
                      );
                    },
                  )
                : Center(
                    child: Text(
                    "There are no users",
                    style: Theme.of(context).textTheme.titleSmall,
                  )),
          ),
        ],
      ),
    );
  }
}
