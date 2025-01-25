import 'package:equatable/equatable.dart';
import 'package:pet_adoption_app/data/models/pet_model.dart';

abstract class PetState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PetLoading extends PetState {}

class PetLoaded extends PetState {
  final PetModel pets;
  final bool hasMore;

  PetLoaded(this.pets, {this.hasMore = true});

  @override
  List<Object?> get props => [pets, hasMore];
}

class PetError extends PetState {}

class AdoptPet extends PetState {}