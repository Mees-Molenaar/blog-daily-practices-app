import 'dart:math';

import 'package:daily_practices_app/features/home/bloc/bloc/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practices_repository/practices_repository.dart';

final activePractice = Random().nextInt(26) + 1;

class PracticesPage extends StatelessWidget {
  final PracticesRepository practicesRepository;

  const PracticesPage({super.key, required this.practicesRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(practicesRepository: practicesRepository)..add(HomeLoad()),
      child: const PracticesView(),
    );
  }
}

class PracticesView extends StatelessWidget {
  const PracticesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Practices'),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            return const Center(
              // child: CircularProgressIndicator(),
              child: Text('Initial'),
            );
          } else if (state is HomeLoaded) {
            return _buildListView(state.practices);
          } else {
            return const Center(
              child: Text('Error while loading practices'),
            );
          }
        },
      ),
    );
  }
}

Widget _buildListView(List<Practice> practices) {
  return ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: practices.length,
    itemBuilder: (BuildContext context, int index) {
      if (index == activePractice) {
        return Card(
          key: const Key('ActivePractice'),
          elevation: 3,
          color: Theme.of(context).colorScheme.primary,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                practices[index].id.toString(),
              ),
            ),
            title: Text(
              practices[index].practice,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        return Card(
          elevation: 3,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(practices[index].id.toString()),
            ),
            title: Text(practices[index].practice),
          ),
        );
      }
    },
  );
}
