class MovieListResponse {
  int? page;
  List<MovieData>? results;
  int? totalPages;
  int? totalResults;

  MovieListResponse({this.page, this.results, this.totalPages, this.totalResults});

  MovieListResponse.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    if (json['results'] != null) {
      results = <MovieData>[];
      json['results'].forEach((v) {
        results!.add(new MovieData.fromJson(v));
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['total_pages'] = this.totalPages;
    data['total_results'] = this.totalResults;
    return data;
  }
}

class MovieData {
  int? id;
  String? releaseDate;
  String? title;
  int? voteCount;

  MovieData(
      {this.id,
        this.releaseDate,
        this.title,
        this.voteCount});

  MovieData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    releaseDate = json['release_date'];
    title = json['title'];
    voteCount = json['vote_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['release_date'] = this.releaseDate;
    data['title'] = this.title;
    data['vote_count'] = this.voteCount;
    return data;
  }
}