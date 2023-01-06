import 'package:flutter/material.dart';
import 'package:urbanmatch/apiServices/get_repositories.dart';
import 'package:urbanmatch/models/repositories_model.dart';

class ShowCommit extends StatefulWidget {
  String? repoName;
  ShowCommit({super.key, this.repoName});

  @override
  State<ShowCommit> createState() => _ShowCommitState();
}

class _ShowCommitState extends State<ShowCommit> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: const Text('Last Commit'),
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: GithubRepositories().getLastCommit(
                repoName: widget
                    .repoName), // a previously-obtained Future<String> or null
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                List<RepositoriesModel> data =
                    snapshot.data as List<RepositoriesModel>;
                if (data.isNotEmpty) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Row(
                                children: [
                                  const Text(
                                    'Commited By : ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(data[index].committer ?? '')
                                ],
                              ),
                              subtitle: Container(
                                constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height *
                                            0.08),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Message : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Expanded(
                                            child:
                                                Text(data[index].messege ?? ''))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Commited On : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(data[index].date ?? '')
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('No Data Found'),
                  );
                }
              } else if (snapshot.hasError) {
                return SizedBox(
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Server Error'),
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox(
                    width: size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            color: Colors.purple,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Loading...'),
                        ),
                      ],
                    ));
              }
              // return Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: children,
              //   ),
              // );
            },
          ),
        ),
      ),
    );
  }
}
