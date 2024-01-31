class RideModel {
  // Attributes
  String? id;
  String userId;
  String username;
  String pickup;
  String dropoff;
  String date;
  String time;
  String price;
  String? pax;
  String? passengerId1;
  String? passengerId2;
  String? passengerId3;
  String? passengerId4;
  String? driverId;
  DateTime bookingDate;
  String? status;
  

  // Constructor
  RideModel({
    this.id,
    required this.userId,
    required this.username,
    required this.pickup,
    required this.dropoff,
    required this.date,
    required this.time,
    required this.price,
    this.pax,
    this.passengerId1,
    this.passengerId2,
    this.passengerId3,
    this.passengerId4,
    this.driverId,
    required this.bookingDate,
    this.status,
  });

  // Static function to create an empty ride model
  static RideModel empty() => RideModel(
        id: '',
        userId: '',
        username: '',
        pickup: '',
        dropoff: '',
        date: '',
        time: '',
        price: '',
        pax: '',
        passengerId1: '',
        passengerId2: '',
        passengerId3: '',
        passengerId4: '',
        driverId: '',
        bookingDate: DateTime.now(),
        status: '',
      );

  // Convert model to JSON structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id, // change rideId to id
      'userId': userId,
      'username': username,
      'pickup': pickup,
      'dropoff': dropoff,
      'date': date,
      'time': time,
      'price': price,

      'pax': pax,
      'passengerId1': passengerId1,
      'passengerId2': passengerId2,
      'passengerId3': passengerId3,
      'passengerId4': passengerId4,
      'driverId': driverId,
      'bookingDate': bookingDate,
      'status': status,
    };
  }

  // Factory method to create a RideModel from a map
  factory RideModel.fromMap(Map<String, dynamic> map) {
    return RideModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      pickup: map['pickup'] ?? '',
      dropoff: map['dropoff'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      price: map['price'] ?? '',
      pax: map['pax'] ?? '',
      passengerId1: map['passengerId1'] ?? '',
      passengerId2: map['passengerId2'] ?? '',
      passengerId3: map['passengerId3'] ?? '',
      passengerId4: map['passengerId4'] ?? '',
      driverId: map['driverId'] ?? '',
      bookingDate: map['bookingDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['bookingDate'].millisecondsSinceEpoch)
          : DateTime.now(),
      status: map['status'] ?? '',
    );
  }

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'userId':
        return userId;
      case 'username':
        return username;
      case 'pickup':
        return pickup;
      case 'dropoff':
        return dropoff;
      case 'date':
        return date;
      case 'time':
        return time;
      case 'price':
        return price;
      case 'pax':
        return pax;
      case 'passengerId1':
        return passengerId1;
      case 'passengerId2':
        return passengerId2;
      case 'passengerId3':
        return passengerId3;
      case 'passengerId4':
        return passengerId4;
      case 'driverId':
        return driverId;
      case 'bookingDate':
        return bookingDate;
      case 'status':
        return status;
      default:
        throw ArgumentError('Invalid key: $key');
    }
  }
}
