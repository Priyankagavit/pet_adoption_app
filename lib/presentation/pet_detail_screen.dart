// lib/presentation/screens/pet_detail_screen.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/data/models/pet_model.dart';
import 'package:pet_adoption_app/logic/bloc/pet_bloc.dart';
import 'package:pet_adoption_app/logic/bloc/pet_event.dart';
import 'package:pet_adoption_app/logic/bloc/pet_state.dart';

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    final pet = ModalRoute.of(context)?.settings.arguments as Results;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Adoption'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                pet.image ?? '',
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              pet.name ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Breed: ${pet.species}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'ID: ${pet.id}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),
            BlocBuilder<PetBloc, PetState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    // Trigger the adoption event
                    context.read<PetBloc>().add(AdoptPetEvent(petId: pet.id ?? 0));

                    // Show SnackBar indicating adoption
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Adopted ${pet.name}!')),
                    );
                  },
                  child: Text(pet.isAdopted ?? false
                      ? 'Already Adopted'
                      : 'Adopt Me'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
