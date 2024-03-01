class DoctorModel {
  final String doctorName;
  final String doctorSpeciality;
  final String doctorExperience;
  final String doctorId;
  final List<String> doctorPhotos;
  final List<String> hours;
  final int appointmentsInHourCount;
  final String about;
  final String address;
  final int doctorFees;

  DoctorModel({
    required this.doctorName,
    required this.doctorSpeciality,
    required this.doctorExperience,
    required this.doctorId,
    required this.doctorPhotos,
    required this.hours,
    required this.appointmentsInHourCount,
    required this.about,
    required this.address,
    required this.doctorFees, // Added doctorFees parameter
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      doctorName: json['doctorName'],
      doctorSpeciality: json['doctorSpeciality'],
      doctorExperience: json['doctorExperience'],
      doctorId: json['doctorId'],
      doctorPhotos: List<String>.from(json['doctorPhotos']),
      hours: List<String>.from(json['hours']),
      appointmentsInHourCount: json['appointmentsInHourCount'],
      about: json['about'],
      address: json['address'],
      doctorFees: json['doctorFees'], // Added doctorFees assignment
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorName': doctorName,
      'doctorSpeciality': doctorSpeciality,
      'doctorExperience': doctorExperience,
      'doctorId': doctorId,
      'doctorPhotos': doctorPhotos,
      'hours': hours,
      'appointmentsInHourCount': appointmentsInHourCount,
      'about': about,
      'address': address,
      'doctorFees': doctorFees, // Added doctorFees field
    };
  }
}
