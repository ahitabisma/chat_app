import 'package:chat_app/screens/chat/chat_screen.dart';
import 'package:chat_app/themes/app_theme.dart';
import 'package:flutter/material.dart';

class ChatListItem extends StatefulWidget {
  final Map<String, dynamic> chat;

  const ChatListItem({super.key, required this.chat});

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.1),
      decoration: BoxDecoration(
        color: widget.chat['unread'] > 0
            ? (Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade200
                  : Colors.grey.shade800)
            : null,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey.shade300
                : Colors.grey.shade800,
            width: 0.1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: widget.chat['avatar'] != null
                  ? NetworkImage(widget.chat['avatar'])
                  : null,
              backgroundColor: Colors.grey[700],
              child: widget.chat['avatar'] == null
                  ? Icon(Icons.person, color: context.scaffoldBackground)
                  : null,
            ),
            if (widget.chat['online'])
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white70, width: 1),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          widget.chat['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.onSurface,
          ),
        ),
        subtitle: Text(
          widget.chat['message'],
          style: TextStyle(color: context.onSurface, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          children: [
            Text(
              widget.chat['time'],
              style: TextStyle(color: context.onSurface, fontSize: 12),
            ),
            // SizedBox(height: 4),
            if (widget.chat['unread'] > 0)
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${widget.chat['unread']}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(chatData: widget.chat),
            ),
          );
        },
      ),
    );
  }
}
