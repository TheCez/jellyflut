part of 'sections.dart';

class TranscodeCodecPopupButton extends StatefulWidget {
  final String? initialValue;
  final Setting setting;
  final Database database;
  final GlobalKey<PopupMenuButtonState<String>>? popupButtonKey;

  const TranscodeCodecPopupButton(
      {super.key,
      required this.setting,
      required this.database,
      this.popupButtonKey,
      this.initialValue});

  @override
  State<TranscodeCodecPopupButton> createState() =>
      _TranscodeCodecPopupButtonState();
}

class _TranscodeCodecPopupButtonState extends State<TranscodeCodecPopupButton> {
  String? currentValue;

  Future<Setting> get getCurrentSettings =>
      widget.database.settingsDao.getSettingsById(userApp!.settingsId);

  @override
  void initState() {
    super.initState();
    currentValue =
        widget.initialValue ?? widget.setting.preferredTranscodeAudioCodec;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      key: widget.popupButtonKey,
      initialValue: currentValue,
      onSelected: (String? codec) => setValue(codec),
      itemBuilder: (BuildContext c) => _playerListTile(c),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(currentValue ?? '', style: TextStyle()),
        Icon(Icons.arrow_drop_down),
      ]),
    );
  }

  List<PopupMenuEntry<String>> _playerListTile(BuildContext context) {
    final languageItems = <PopupMenuEntry<String>>[];
    getTranscodeAudioCodecOptions()
        .forEach((String codec) => languageItems.add(CheckedPopupMenuItem(
              value: codec,
              checked: currentValue == codec,
              child: Text(codec),
            )));
    return languageItems;
  }

  void setValue(String? value) async {
    if (value != null) {
      final selectedValue = value.toLowerCase();
      final setting = await getCurrentSettings;
      final s = setting
          .toCompanion(true)
          .copyWith(preferredTranscodeAudioCodec: Value(selectedValue));
      await widget.database.settingsDao.updateSettings(s);
      setState(() {
        currentValue = value;
      });
    }
  }

  List<String> getTranscodeAudioCodecOptions() {
    return TranscodeAudioCodec.values.map((e) => e.name).toList();
  }
}
