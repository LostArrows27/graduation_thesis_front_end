class Label {
  final String label;
  final double confidence;

  Label({
    required this.label,
    required this.confidence,
  });

  factory Label.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) {
      throw Exception('Empty label map');
    }
    final entry = map.entries.first;
    return Label(
      label: entry.key,
      confidence: (entry.value as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {label: confidence};
  }
}

class Labels {
  final List<Label> locationLabels;
  final List<Label> actionLabels;
  final List<Label> eventLabels;

  Labels({
    required this.locationLabels,
    required this.actionLabels,
    required this.eventLabels,
  });

  factory Labels.fromJson(Map<String, dynamic> json) {
    return Labels(
      locationLabels: (json['location_labels'] as List<dynamic>)
          .map((e) => Label.fromMap(e as Map<String, dynamic>))
          .toList(),
      actionLabels: (json['action_labels'] as List<dynamic>)
          .map((e) => Label.fromMap(e as Map<String, dynamic>))
          .toList(),
      eventLabels: (json['event_labels'] as List<dynamic>)
          .map((e) => Label.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location_labels': locationLabels.map((e) => e.toMap()).toList(),
      'action_labels': actionLabels.map((e) => e.toMap()).toList(),
      'event_labels': eventLabels.map((e) => e.toMap()).toList(),
    };
  }
}

class LabelResponse {
  final Labels labels;

  LabelResponse({
    required this.labels,
  });

  factory LabelResponse.fromJson(Map<String, dynamic> json) {
    return LabelResponse(
      labels: Labels.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labels': labels.toJson(),
    };
  }
}
