import 'dart:typed_data';

class AnsweredQuestAttachment {
  final int questionIndex;
  final String fileName;
  final Uint8List bytes;

  const AnsweredQuestAttachment({
    required this.questionIndex,
    required this.fileName,
    required this.bytes,
  });
}
