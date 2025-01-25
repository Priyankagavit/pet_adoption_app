// lib/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/logic/bloc/pet_event.dart';
import 'package:pet_adoption_app/logic/bloc/pet_state.dart';
import '../../logic/bloc/pet_bloc.dart';
import 'pet_detail_screen.dart';

class PetList extends StatefulWidget {
  @override
  _PetListState createState() => _PetListState();
}

class _PetListState extends State<PetList> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PetBloc>().add(LoadPets(page: _currentPage));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final state = context.read<PetBloc>().state;
      if (state is PetLoaded && state.hasMore) {
        _currentPage++;
        context.read<PetBloc>().add(LoadPets(page: _currentPage, query: _query));
      }
    }
  }

  void _onSearch(String query) {
    _query = query;
    _currentPage = 1;
    context.read<PetBloc>().add(SearchPets(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Adoption'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search pets...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<PetBloc, PetState>(
        builder: (context, state) {
          if (state is PetLoading && _currentPage == 1) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PetLoaded) {
            final pets = state.pets.results ?? [];
            return ListView.builder(
shrinkWrap: true,
              controller: _scrollController,
              itemCount: pets.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= pets.length) {
                  return Center(child: CircularProgressIndicator());
                }
                final pet = pets[index];
                return ListTile(
                  leading: Image.network(pet.image ?? ''),
                  title: Text(pet.name ?? ''),
                  subtitle: Text(pet.species ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetDetailScreen(),
                        settings: RouteSettings(
                          arguments: pet,  // Pass pet object using arguments
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No pets found.'));
          }
        },
      ),
    );
  }
}
