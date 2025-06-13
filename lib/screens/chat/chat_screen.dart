import 'package:chat_app/themes/app_theme.dart';
import 'package:chat_app/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> chatData;

  const ChatScreen({super.key, required this.chatData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [
    {
      'text': "That's awesome! What kind of project was it?",
      'isMe': false,
      'time': '10:33 AM',
      'isRead': true,
      'isSent': true,
    },
    {
      'text':
          "It was a mobile app redesign. Took me about 3 weeks to complete, but I'm really happy with how it turned out.",
      'isMe': true,
      'time': '10:35 AM',
      'isRead': true,
      'isSent': true,
    },
    {
      'text': "Sounds exciting! I'd love to see it when you're ready to share.",
      'isMe': false,
      'time': '10:36 AM',
      'isRead': true,
      'isSent': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = ResponsiveHelper.getScreenWidth(context);

    return Scaffold(
      backgroundColor: context.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: context.scaffoldBackground,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.chatData['avatar']),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatData['name'],
                  style: TextStyle(
                    color: context.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.chatData['online'] ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: widget.chatData['online']
                        ? Colors.green
                        : context.onSurface,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.video_call, color: context.onSurface),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.call, color: context.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: width > 600 ? 30 : 10,
                vertical: 15,
              ),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['isMe'] as bool;

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: width > 600 ? 32 : 12,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? context.primary : context.onPrimary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Text(
                            message['text'],
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.light
                                  ? (isMe ? Colors.white : Colors.black87)
                                  : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            message['time'],
                            style: TextStyle(
                              color: context.onSurface,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Message input field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: context.scaffoldBackground,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: context.onSurface),
                  onPressed: () {},
                ),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: Center(
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(color: context.onSurface),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: context.onSurface),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: context.onSurface),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
