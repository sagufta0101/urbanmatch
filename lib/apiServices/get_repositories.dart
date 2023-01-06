import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:urbanmatch/apiServices/url.dart';
import 'package:urbanmatch/models/repositories_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

void mylaunchUrl({dynamic link}) async {
  // if (!await launchUrl(Uri.parse(link))) throw 'Could not launch $link';
  if (await canLaunch(link)) {
    await launch(link);
    throw 'Could not launch url';
  }
}

class GithubRepositories {
  Future<List<RepositoriesModel>> getRepositories() async {
    String apiUrl = ApiUrl().api;
    List<RepositoriesModel> clist = [];
    var response = await http.get(
      Uri.parse(apiUrl),
    );
    print('object---------------${response.statusCode}');
    // if (response.statusCode == 200) {
    dynamic data = jsonDecode(response.body);
    for (var i in data) {
      print(i['html_url']);

      clist.add(
        RepositoriesModel(
            name: i['name'] ?? '',
            html_url: i['html_url'].toString(),
            watchers_count: i['watchers_count'].toString(),
            avatar_url: i['owner']['avatar_url'] ?? '',
            description: i['description'] ?? ''),
      );
      print("-------------------${clist.last.html_url}");
    }
    return clist;
    // } else {
    //   return [];
    // }
  }

  Future<List<RepositoriesModel>> getLastCommit(
      {@required String? repoName}) async {
    String apiUrl = ApiUrl().api;
    List<RepositoriesModel> clist = [];
    var response = await http.get(
      Uri.parse('https://api.github.com/repos/freeCodeCamp/$repoName/commits'),
    );
    print('object---------------${response.statusCode}');
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);

      clist.add(
        RepositoriesModel(
            committer: data.first['commit']['committer']['name'] ?? '',
            messege: data.first['commit']['message'] ?? '',
            date: DateFormat("yyyy-MM-dd HH:mm").format(
                DateTime.parse(data.first['commit']['committer']['date']))),
      );
      return clist;
    } else {
      return [];
    }
  }
}
