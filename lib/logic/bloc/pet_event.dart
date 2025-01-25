import 'package:equatable/equatable.dart';

abstract class PetEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPets extends PetEvent {
  final int page;
  final String query;

  LoadPets({this.page = 1, this.query = ''});

  @override
  List<Object?> get props => [page, query];
}

class SearchPets extends PetEvent {
  final String query;

  SearchPets(this.query);

  @override
  List<Object?> get props => [query];
}
class AdoptPetEvent extends PetEvent {
  final int petId;

  AdoptPetEvent({required this.petId});
}