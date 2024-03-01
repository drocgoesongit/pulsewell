class AppointmentModel {
  String apptId;
  String userId;
  String doctorId;
  int timeOfBooking;
  String apptTime;
  String apptDate;
  String feesStatus;
  String apptStatus;
  String username;
  String doctorName;

  AppointmentModel({
    required this.apptId,
    required this.userId,
    required this.doctorId,
    required this.timeOfBooking,
    required this.apptTime,
    required this.apptDate,
    required this.feesStatus,
    required this.apptStatus,
    required this.username,
    required this.doctorName,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      apptId: json['apptId'] as String,
      userId: json['userId'] as String,
      doctorId: json['serviceId'] as String,
      timeOfBooking: json['timeOfBooking'] as int,
      apptTime: json['apptTime'] as String, // Changed the type to String
      apptDate: json['apptDate'] as String, // Added new variable
      feesStatus: json['feesStatus'] as String,
      apptStatus: json['apptStatus'] as String, // Added new variable
      username: json['username'] as String, // Added new variable
      doctorName: json['doctorName'] as String, // Added new variable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apptId': apptId,
      'userId': userId,
      'serviceId': doctorId,
      'timeOfBooking': timeOfBooking,
      'apptTime': apptTime,
      'apptDate': apptDate, // Added new variable
      'feesStatus': feesStatus,
      'apptStatus': apptStatus, // Added new variable
      'username': username, // Added new variable
      'doctorName': doctorName, // Added new variable
    };
  }
}
