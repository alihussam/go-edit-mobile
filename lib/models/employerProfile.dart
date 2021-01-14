class EmployerProfile {
  double rating;
  int ratingCount;
  int projectsCompleted;
  int assetsBought;

  EmployerProfile({
    this.rating,
    this.ratingCount,
    this.projectsCompleted,
    this.assetsBought,
  });

  EmployerProfile.fromJson(Map<String, dynamic> json) {
    rating = double.parse(json['rating'].toString());
    projectsCompleted = json['projectsCompleted'];
    ratingCount = json['ratingCount'] ?? 0;
    assetsBought = json['assetsBought'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rating != null) data['rating'] = this.rating;
    if (this.projectsCompleted != null)
      data['projectsCompleted'] = this.projectsCompleted;
    if (this.assetsBought != null) data['assetsBought'] = this.assetsBought;
    return data;
  }
}
