import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@freezed
abstract class Location with _$Location {
  const Location._();
  factory Location({String? locationLabel, double? latitude, double? longitude}) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  bool get hasLocation => latitude != null && longitude != null;

  String? get coordinates => hasLocation ? '${latitude!.toStringAsFixed(5)}, ${longitude!.toStringAsFixed(5)}' : null;

  String get locationSummary {
    if (locationLabel != null && locationLabel!.isNotEmpty) return locationLabel!;
    if (coordinates != null) return coordinates!;
    return 'No location attached';
  }
}
