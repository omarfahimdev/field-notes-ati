import 'package:field_notes/features/customers/domain/customer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'site.freezed.dart';
part 'site.g.dart';

@freezed
abstract class Site with _$Site {
  const Site._();

  factory Site({required int id, required String name, required String address, required Customer customer}) = _Site;

  factory Site.fromJson(Map<String, dynamic> json) => _$SiteFromJson(json);
}
