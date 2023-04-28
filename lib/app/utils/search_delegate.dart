import 'package:flutter/material.dart';
import 'package:frappe_mobile_custom/app/api/frappe_api.dart';


class FrappeSearchDelegate extends SearchDelegate {
  String docType;
  String? referenceDoctype;
  Map<String,dynamic>? filters;
  FrappeSearchDelegate({required this.docType, this.referenceDoctype,this.filters}) {}

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<Map>(
      future: FrappeAPI.searchLink(
          doctype: docType, txt: query, refDoctype: referenceDoctype,pageLength: 5),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasData){
            List<dynamic> results = snapshot.data!['results'];

            return results.isEmpty?
            const Center(child: Text('No Results'))
                :
            ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(results[index]['value']!),
                  subtitle: Text(results[index]['description']!),
                  onTap: () {
                    close(context, results[index]['value']!);
                  },
                );
              },
              itemCount: results.length,
            );
          }
          else if (snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          return const Text('No Results');

        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}