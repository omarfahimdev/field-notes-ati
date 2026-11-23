part of 'site_bloc.dart';
sealed class SiteEvent extends Equatable { const SiteEvent(); @override List<Object?> get props => []; }
class SitesLoaded extends SiteEvent { const SitesLoaded(); }
class SiteAdded extends SiteEvent { final String name,address; final Map<String,dynamic> customerRaw; const SiteAdded({required this.name, required this.address, required this.customerRaw}); }
class SiteUpdated extends SiteEvent { final String localId,name,address; final Map<String,dynamic> customerRaw; const SiteUpdated({required this.localId, required this.name, required this.address, required this.customerRaw}); }
class SiteDeleted extends SiteEvent { final String localId; const SiteDeleted(this.localId); }
