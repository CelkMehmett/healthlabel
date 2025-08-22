// lib/models/history_item.dart

enum RiskLevel { safe, attention, risky }

class HistoryItem {
  final String id;
  final String name;
  final DateTime date;
  final RiskLevel riskLevel;
  final String ocrText;
  final String? imagePath;

  HistoryItem({
    required this.id,
    required this.name,
    required this.date,
    required this.riskLevel,
    required this.ocrText,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date': date.toIso8601String(),
        'riskLevel': riskLevel.name,
        'ocrText': ocrText,
        'imagePath': imagePath,
      };

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
        id: json['id'] as String,
        name: json['name'] as String,
        date: DateTime.parse(json['date'] as String),
        riskLevel: RiskLevel.values.firstWhere(
          (e) => e.name == json['riskLevel'],
          orElse: () => RiskLevel.safe,
        ),
        ocrText: json['ocrText'] as String,
        imagePath: json['imagePath'] as String?,
      );
}
