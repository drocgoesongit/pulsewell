class DonationCampaignModel {
  final String donationId; // Added donationId field
  final String patientName;
  final String patientImage;
  final String description;
  final String disease;
  final String deadline;
  final int amountRequired;
  final List<String> prescriptionImages;
  final String consultingDoctor;
  final String hospitalName;
  final List<String> donations;
  final String status;
  final int totalFundRaised;

  DonationCampaignModel({
    required this.donationId, // Added donationId field
    required this.patientName,
    required this.patientImage,
    required this.description,
    required this.disease,
    required this.deadline,
    required this.amountRequired,
    required this.prescriptionImages,
    required this.consultingDoctor,
    required this.hospitalName,
    required this.donations,
    required this.status,
    required this.totalFundRaised,
  });

  factory DonationCampaignModel.fromJson(Map<String, dynamic> json) {
    return DonationCampaignModel(
      donationId: json['donationId'] as String, // Added donationId field
      patientName: json['patientName'] as String,
      patientImage: json['patientImage'] as String,
      description: json['description'] as String,
      disease: json['disease'] as String,
      deadline: json['deadline'] as String,
      amountRequired: json['amountRequired'] as int,
      prescriptionImages: (json['prescriptionImages'] as List<dynamic>)
          .map((image) => image as String)
          .toList(),
      consultingDoctor: json['consultingDoctor'] as String,
      hospitalName: json['hospitalName'] as String,
      donations: (json['donations'] as List<dynamic>)
          .map((donation) => donation as String)
          .toList(),
      status: json['status'] as String,
      totalFundRaised: json['totalFundRaised'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'donationId': donationId, // Added donationId field
      'patientName': patientName,
      'patientImage': patientImage,
      'description': description,
      'disease': disease,
      'deadline': deadline,
      'amountRequired': amountRequired,
      'prescriptionImages': prescriptionImages,
      'consultingDoctor': consultingDoctor,
      'hospitalName': hospitalName,
      'donations': donations,
      'status': status,
      'totalFundRaised': totalFundRaised,
    };
  }
}
