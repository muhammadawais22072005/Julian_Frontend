class MailBody {
  final String to;
  final String subject;
  final String text;

  MailBody({required this.to, required this.subject, required this.text});

  Map<String, dynamic> toJson() {
    return {
      'to': to,
      'subject': subject,
      'text': text,
    };
  }
}