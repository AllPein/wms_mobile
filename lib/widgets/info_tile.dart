import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class InfoTile extends StatelessWidget {
  final Widget? trailing;
  final String title;
  final String? subtitle;

  const InfoTile({Key? key, this.trailing, required this.title, this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = <Widget>[Text(title)];
    if (subtitle != null) {
      texts.add(Text(subtitle!, style: TextStyle(color: Color(0xFF6C7292))));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).backgroundColor),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: texts),
            if (trailing != null) trailing!
          ],
        ),
      ),
    );
  }
}

enum EditType { typeAhead, text, select }

class EditableConfiguration {
  final EditType type;
  final SuggestionsCallback? suggestionsCallback;
  final List<String?>? suggestions;
  final ValueChanged? onChanged;

  const EditableConfiguration(
      {required this.type,
      this.suggestionsCallback,
      this.suggestions,
      this.onChanged});
}

class EditableInfoTile extends StatefulWidget {
  final bool editing;
  final InfoTile infoTile;
  final String base;
  final EditableConfiguration configuration;
  const EditableInfoTile(
      {Key? key,
      this.editing = false,
      required this.infoTile,
      String base = '',
      required this.configuration})
      : base = base,
        super(key: key);

  @override
  _EditableInfoTileState createState() => _EditableInfoTileState();
}

class _EditableInfoTileState extends State<EditableInfoTile> {
  bool changed = false;
  bool selected = false;
  late String base;
  late final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    base = widget.infoTile.title;
    _controller.text = base;
    if (widget.configuration.type == EditType.text) {
      _controller.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onChanged() {
    widget.configuration.onChanged!(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!widget.editing) return widget.infoTile;

    switch (widget.configuration.type) {
      case EditType.text:
        return Container(
          child: TextField(
            onChanged: (val) {
              setState(() {
                changed = true;
              });
            },
            controller: _controller,
            style: null,
            decoration: InputDecoration(
              hintText: widget.infoTile.subtitle,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 15, maxWidth: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                ),
              ),
              filled: true,
              // focusColor: Colors.blue,
              focusColor: theme.primaryColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.primaryColor, width: 1)),
              fillColor: Colors.white,
            ),
          ),
        );
      case EditType.select:
        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: InputDecorator(
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                border: OutlineInputBorder(
                    gapPadding: 0,
                    borderRadius: BorderRadius.all(Radius.circular(12)))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      base = value ?? base;
                    });
                    widget.configuration.onChanged!(value);
                  },
                  value: base,
                  items: widget.configuration.suggestions!
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e!),
                          ))
                      .toList()),
            ),
          ),
        );
      case EditType.typeAhead:
        return TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.infoTile.subtitle,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 15, maxWidth: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [],
                    ),
                  ),
                ),
                filled: true,
                // focusColor: Colors.blue,
                focusColor: theme.primaryColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: theme.primaryColor, width: 1)),
                fillColor: Colors.white,
              ),
            ),
            suggestionsCallback: (suggestion) async {
              final res =
                  await widget.configuration.suggestionsCallback!(suggestion);
              print(res);
              return res;
            },
            itemBuilder: (context, itemData) {
              print(itemData);
              return ListTile(
                title: Text('$itemData'),
              );
            },
            onSuggestionSelected: (value) {
              widget.configuration.onChanged!(value);
              _controller.text = value as String;
            });
    }
  }
}
