class Venue {
  final String id;
  String name;
  double lat;
  double lng;
  int distance;
  List<dynamic> address;

  Venue(this.id, this.name, this.lat, this.lng, this.distance, this.address);

  factory Venue.fromJson(Map<String, dynamic> json) {
    //print(json);

      Venue newVenue = Venue(
          json["id"],
          json["name"],
          json["location"]["lat"],
          json["location"]["lng"],
          json["location"]["distance"],
          json["location"]["formattedAddress"]);

    return newVenue;
  }


  @override
  String toString() {
    return this.id +
        ", " +
        this.name +
        ", " +
        this.lat.toString() +
        ", " +
        this.lng.toString() +
        ", " +
        this.distance.toString() +
        ", " +
        this.address.toString();
  }
}