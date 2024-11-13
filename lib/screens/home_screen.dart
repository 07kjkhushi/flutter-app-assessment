import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/user_tile.dart';
import 'user_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: UserSearchDelegate(userProvider.users),
              );
            },
          )
        ],
      ),
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userProvider.error.isNotEmpty
              ? Center(child: Text('Error: ${userProvider.errorMessage}'))
              : RefreshIndicator(
                  onRefresh: () async {
                    userProvider.refresh();
                  },
                  child: ListView.builder(
                    itemCount: userProvider.users.length,
                    itemBuilder: (context, index) {
                      final user = userProvider.users[index];
                      return UserTile(
                        user: user,
                        onTap: () {},
                      );
                    },
                  ),
                ),
    );
  }
}

class UserSearchDelegate extends SearchDelegate {
  final List<User> users;

  UserSearchDelegate(this.users);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final result = users
        .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView(
      children: result
          .map((user) => ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailScreen(user: user),
                    ),
                  );
                },
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? users
        : users
            .where((user) =>
                user.name.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView(
      children: suggestionList
          .map((user) => ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                onTap: () {
                  query = user.name;
                  showResults(context);
                },
              ))
          .toList(),
    );
  }
}

class User {
  late String email;

  get name => null;
}
