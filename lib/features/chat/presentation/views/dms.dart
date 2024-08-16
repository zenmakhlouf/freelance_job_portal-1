import 'package:flutter/material.dart';
import 'package:freelance_job_portal/features/chat/data/models/chat_model.dart';
import 'package:freelance_job_portal/features/chat/presentation/views/widget/dms_body.dart';

class DMs extends StatelessWidget {
  const DMs({
    super.key,
    required this.room,
  });

  final ChatRoomModel room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DmsBody(chat: room),
    );
  }
}
