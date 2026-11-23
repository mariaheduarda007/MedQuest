import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/theme/theme.dart';
import 'package:file_picker/file_picker.dart';

enum AnswerType { text, file }

class OpenQuestion extends StatefulWidget {
  final String title;
  final String? orientation;
  final int numeration;
  final String? answer;
  final num? value;
  final PlatformFile? selectedFile;
  final AnswerType type;
  final ValueChanged<PlatformFile?>? onFileChanged;
  final bool enabled;
  final bool showValueField;
  final void Function(String answer, num? value)? onChanged;

  const OpenQuestion({
    super.key,
    required this.title,
    required this.numeration,
    required this.type,
    this.onFileChanged,
    this.orientation,
    this.answer,
    this.value,
    this.selectedFile,
    this.onChanged,
    this.enabled = true,
    this.showValueField = true,
  });

  @override
  State<OpenQuestion> createState() => _OpenQuestionState();
}

class _OpenQuestionState extends State<OpenQuestion> {
  late TextEditingController answerController;
  late TextEditingController valueController;
  PlatformFile? selectedFile;

  @override
  void initState() {
    super.initState();
    answerController = TextEditingController(text: widget.answer ?? '');

    valueController = TextEditingController(
      text: widget.value?.toString() ?? '',
    );
    selectedFile = widget.selectedFile;
  }

  @override
  void didUpdateWidget(covariant OpenQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.answer != widget.answer &&
        answerController.text != widget.answer) {
      answerController.text = widget.answer ?? '';
    }

    if (oldWidget.value != widget.value &&
        valueController.text != widget.value?.toString()) {
      valueController.text = widget.value?.toString() ?? '';
    }

    if (oldWidget.selectedFile != widget.selectedFile) {
      selectedFile = widget.selectedFile;
    }
  }

  void notifyChanges() {
    final answer = answerController.text;
    final value = num.tryParse(valueController.text);

    widget.onChanged?.call(answer, value);
  }

  Future<void> pickFile() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
    );

    if (file != null) {
      setState(() {
        selectedFile = file;
      });

      widget.onFileChanged?.call(file);
    }
  }

  @override
  void dispose() {
    answerController.dispose();
    valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.orientation != null)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                widget.orientation!,
                style: context.textStyles.bodyLarge?.withColor(
                  context.colors.primary,
                ),
              ),
            ),

          const SizedBox(height: 10),

          Text(
            '${widget.numeration}. ${widget.title}',
            style: context.textStyles.titleSmall?.withColor(
              context.colors.secondary,
            ),
          ),
          const SizedBox(height: 16),
          if (widget.type == AnswerType.text)
            TextField(
              controller: answerController,
              enabled: widget.enabled,
              minLines: 3,
              maxLines: 6,
              onChanged: (_) => notifyChanges(),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 2,
                  ),
                ),
                hintText: 'Digite a resposta',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton.icon(
                  onPressed: widget.enabled ? pickFile : null,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  icon: Icon(
                    Icons.upload_file,
                    color: context.colors.secondary,
                    size: 26,
                  ),
                  label: Text(
                    'Arquivo',
                    style: context.textStyles.bodyLarge?.withColor(
                      context.colors.secondary,
                    ),
                  ),
                ),

                if (selectedFile != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.insert_drive_file,
                        color: context.colors.secondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedFile!.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        color: context.colors.secondary,
                        onPressed: () {
                          setState(() {
                            selectedFile = null;
                          });

                          widget.onFileChanged?.call(null);
                        },
                        icon: Icon(
                          Icons.close,
                          color: context.colors.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          if (widget.showValueField) ...[
            const SizedBox(height: 16),
            Text(
              'Valor da resposta',
              style: context.textStyles.titleSmall?.withColor(
                context.colors.secondary,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              enabled: widget.enabled,
              controller: valueController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => notifyChanges(),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 2,
                  ),
                ),
                hintText: 'Digite um valor...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
