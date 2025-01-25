

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/presentation/pet_detail_screen.dart';
import 'package:pet_adoption_app/presentation/pet_list.dart';

import 'data/repository/pet_repository.dart';
import 'logic/bloc/pet_bloc.dart';
import 'logic/bloc/pet_event.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PetBloc(PetRepository())..add(LoadPets()),  // Create the PetCubit at the root level
      child: MaterialApp(
        title: 'Pet Adoption App',
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => PetList(), // HomePage route

          '/pet_details': (context) => const PetDetailScreen(),// HistoryPage route
        },
      ),
    );
  }
}
