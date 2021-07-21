import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  final data = ["manzana", "piña", "durazno", "piña", "calabaza", "tomate"];
  final recentData = ["durazno"];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, query);
        },
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation));
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> allData = data
        .where((specificElement) =>
            specificElement.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
              title: RichText(
                text: TextSpan(
                    text: allData[index]
                        .substring(0, allData[index].indexOf(query)),
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                          text: allData[index].substring(
                              allData[index].indexOf(query),
                              allData[index].indexOf(query) + query.length),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: allData[index].substring(
                              allData[index].indexOf(query) + query.length),
                          style: TextStyle(color: Colors.grey))
                    ]),
              ),
              onTap: () {
                query = allData[index];
                print(query);
                close(context, query);
              },
            ),
        itemCount: allData.length);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final lowerCaseQuery = query.toLowerCase();
    final suggestionList = query.isEmpty
        ? recentData
        : data
            .where((specificElement) =>
                specificElement.toLowerCase().contains(lowerCaseQuery))
            .toList();

    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
              title: RichText(
                text: TextSpan(
                    text: suggestionList[index].toLowerCase().substring(
                        0,
                        suggestionList[index]
                            .toLowerCase()
                            .indexOf(lowerCaseQuery)),
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                          text: suggestionList[index].toLowerCase().substring(
                              suggestionList[index]
                                  .toLowerCase()
                                  .indexOf(lowerCaseQuery),
                              suggestionList[index]
                                      .toLowerCase()
                                      .indexOf(lowerCaseQuery) +
                                  query.length),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: suggestionList[index].toLowerCase().substring(
                              suggestionList[index]
                                      .toLowerCase()
                                      .indexOf(lowerCaseQuery) +
                                  query.length),
                          style: TextStyle(color: Colors.grey))
                    ]),
              ),
              onTap: () {
                query = suggestionList[index];
                print(query);
                close(context, query);
              },
            ),
        itemCount: suggestionList.length);
  }
}
