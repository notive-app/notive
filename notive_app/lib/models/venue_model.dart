class Venue {
  final int id;
  final int itemId;
  String name;
  double lat;
  double lng;
  int distance;
  List<dynamic> address;

  Venue(this.id, this.itemId, this.name, this.lat, this.lng, this.distance, this.address);

  factory Venue.fromJson(int itemId, Map<String, dynamic> json) {
      Venue newVenue = Venue(
          int.tryParse(json["id"]),
          itemId,
          json["name"],
          json["location"]["lat"],
          json["location"]["lng"],
          json["location"]["distance"],
          json["location"]["formattedAddress"]);

    return newVenue;
  }


  @override
  String toString() {
    return this.id.toString() +
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