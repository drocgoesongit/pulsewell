class DonationModel {
  final int amount;
  final String time;
  final String userid;
  final String paymentid;
  final String donationId;
  final String donorName; // Added donorName field

  DonationModel({
    required this.amount,
    required this.time,
    required this.userid,
    required this.paymentid,
    required this.donationId,
    required this.donorName, // Added donorName field
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'time': time,
      'userid': userid,
      'paymentid': paymentid,
      'donationId': donationId,
      'donorName': donorName, // Added donorName field
    };
  }

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
      amount: map['amount'],
      time: map['time'],
      userid: map['userid'],
      paymentid: map['paymentid'],
      donationId: map['donationId'],
      donorName: map['donorName'], // Added donorName field
    );
  }
}
