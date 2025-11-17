import 'package:chaty/features/chat/presentation/pages/chats_page.dart';
import 'package:chaty/features/home/presentation/pages/profile_page.dart';
import 'package:chaty/features/home/presentation/pages/stories_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeNavCubit extends Cubit<int> {
  HomeNavCubit() : super(0);


  void changeTab(int index) => emit(index);
}


class HomePage extends StatelessWidget {
   HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeNavCubit(),
      child: BlocBuilder<HomeNavCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            body: _pages[currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => context.read<HomeNavCubit>().changeTab(index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_outlined),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.amp_stories),
                  label: 'Stories',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Screens
  final List<Widget> _pages = [
    const ChatsPage(),
    const StoriesPage(),
    ProfilePage(),
  ];


}



