import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/data/models/pet_model.dart';
import 'package:pet_adoption_app/logic/bloc/pet_event.dart';
import 'package:pet_adoption_app/logic/bloc/pet_state.dart';

import '../../data/repository/pet_repository.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  final PetRepository petRepository;

  PetBloc(this.petRepository) : super(PetLoading()) {
    on<LoadPets>((event, emit) async {
      try {
        final currentState = state;
        final PetModel oldPets =
            currentState is PetLoaded ? currentState.pets :PetModel() ;
        final newPets =
            await petRepository.fetchPets(page: event.page, query: event.query);

        emit(PetLoaded(
          oldPets.merge(newPets) ,
          hasMore: newPets.results?.isNotEmpty ?? false,
        ));
      } catch (e) {
        emit(PetError());
      }
    });

    on<SearchPets>((event, emit) async {
      try {
        emit(PetLoading());
        final pets = await petRepository.fetchPets(query: event.query);
        emit(PetLoaded(pets, hasMore: false));
      } catch (e) {
        emit(PetError());
      }
    });

    on<AdoptPetEvent>((event, emit) {
      if (state is PetLoaded) {
        final currentState = state as PetLoaded;
        // Update the pet's adoption status
        final updatedPets = currentState.pets.results?.map((pet) {
          if (pet.id == event.petId) {
            // Mark the pet as adopted
            pet.isAdopted = true;
          }
          return pet;
        }).toList();

        // Emit updated state with the adopted pet
        emit(PetLoaded(
          PetModel(results: updatedPets), // Assuming PetModel can handle this
          hasMore: currentState.hasMore,
        ));

        // Optionally emit the PetAdopted state
        emit(AdoptPet());
      }
    });
  }
}
