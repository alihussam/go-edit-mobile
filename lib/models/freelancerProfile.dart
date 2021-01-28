class FreelancerProfile {
  String jobTitle;
  double rating;
  int ratingCount;
  int projects;
  int assets;
  String bio;
  List skills;
  double earning;
  double withdrawn;

  FreelancerProfile(
      {this.jobTitle,
      this.assets,
      this.bio,
      this.ratingCount,
      this.projects,
      this.rating,
      this.skills});

  FreelancerProfile.fromJson(Map<String, dynamic> json) {
    jobTitle = json['jobTitle'] ?? '';
    rating = double.parse(json['rating'].toString());
    withdrawn = json['withdrawn'] != null
        ? double.parse(json['withdrawn'].toString())
        : 0;
    ratingCount = json['ratingCount'] ?? 0;
    projects = json['projects'];
    assets = json['assets'];
    bio = json['bio'] ?? '';
    skills = json['skills'];
    earning = double.parse(json['earning'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.jobTitle != null) data['jobTitle'] = this.jobTitle;
    if (this.rating != null) data['rating'] = this.rating;
    if (this.projects != null) data['projects'] = this.projects;
    if (this.assets != null) data['assets'] = this.assets;
    if (this.bio != null) data['bio'] = this.bio;
    if (this.skills != null) data['skills'] = this.skills;
    return data;
  }
}
