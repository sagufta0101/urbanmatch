class RepositoriesModel {
  String? name, committer, messege, html_url, watchers_count;
  String? description;
  String? date;
  String? avatar_url;
  bool flag;
  bool show = false;
  RepositoriesModel(
      {this.avatar_url,
      this.description,
      this.name,
      this.committer,
      this.flag = true,
      this.show = false,
      this.messege,
      this.date,
      this.watchers_count,
      this.html_url});
}
