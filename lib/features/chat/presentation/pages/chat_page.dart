import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/message.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final uuid = Uuid();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatBloc>().add(SubscribeMessages());
    });
  }

  void _send() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final msg = Message(
      id: uuid.v4(),
      senderId: user.uid,
      senderName: user.email ?? 'Anonymous',
      text: _controller.text.trim(),
      timestamp: DateTime.now(),
    );
    context.read<ChatBloc>().add(NewMessageSent(msg));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) return const Center(child: CircularProgressIndicator());
                if (state is ChatLoaded) {
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (ctx, i) {
                      final m = state.messages[i];
                      return ListTile(
                        title: Text(m.senderName),
                        subtitle: Text(m.text),
                        trailing: Text(
                          TimeOfDay.fromDateTime(m.timestamp).format(context),
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  );
                }
                if (state is ChatError) return Center(child: Text(state.message));
                return const SizedBox.shrink();
              },
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Type a message')),
                  ),
                ),
                IconButton(onPressed: _send, icon: const Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}
