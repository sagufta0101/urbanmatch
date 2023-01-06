import 'package:flutter/material.dart';
import 'package:urbanmatch/apiServices/get_repositories.dart';
import 'package:urbanmatch/models/repositories_model.dart';
import 'package:urbanmatch/show_commit.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Github Repositories';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: const Text('Github Repositories'),
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: GithubRepositories()
                .getRepositories(), // a previously-obtained Future<String> or null
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
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ShowCommit(repoName: data[index].name),
                                ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                trailing: InkWell(
                                    onTap: () {
                                      print(data[index].html_url);
                                      mylaunchUrl(link: data[index].html_url);
                                    },
                                    child: Image.asset(
                                      'images/github.png',
                                      height: 20,
                                    )),
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Repository : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Expanded(
                                        child: Text(data[index].name ?? '')),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Watchers : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(data[index].watchers_count ?? ''),
                                      ],
                                    )
                                  ],
                                ),
                                leading: CircleAvatar(
                                  // radius: 60,
                                  backgroundImage: NetworkImage(data[index]
                                          .avatar_url ??
                                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
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
                        Icons.error_outline,
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
