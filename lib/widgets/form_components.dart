import 'package:expense_tracker/src/styles/color_styles.dart';
import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:flutter/material.dart';

class FormTextField extends StatefulWidget {
  final String hintText;
  final TextInputType inputType;
  final Function(String value) onSave;
  final Function onFocus;
  final Function(String value) validator;
  final Widget trailing;

  const FormTextField({
    super.key,
    required this.hintText,
    this.inputType = TextInputType.text,
    required this.onSave,
    required this.validator,
    required this.trailing,
    required this.onFocus,
  });

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // _focusNode.addListener(widget.onFocus);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _textEditingController,
        cursorColor: ColorStyles.primaryColor,
        focusNode: _focusNode,
        // validator: widget.validator,
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: Visibility(
            visible: true,
            child: widget.trailing,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(
              width: 1.0,
              color: ColorStyles.border,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide:
                const BorderSide(width: 2.0, color: ColorStyles.primaryColor),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          hintStyle: TextStyles.body,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(width: 2.0, color: ColorStyles.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(width: 2.0, color: ColorStyles.red),
          ),
        ),
        style: TextStyles.body,
        keyboardType: widget.inputType,
        textAlign: TextAlign.left,
        // onSaved: widget.onSave,
      ),
    );
  }
}

class SearchableTextField extends StatefulWidget {
  final List<String> values;
  final String searchHint;

  final Function(String) onItemSelected;

  const SearchableTextField({
    super.key,
    required this.values,
    required this.onItemSelected,
    required this.searchHint,
  });

  @override
  State<SearchableTextField> createState() => _SearchableTextFieldState();
}

class _SearchableTextFieldState extends State<SearchableTextField> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> items = [];
  String selectedItem = "";

  @override
  void initState() {
    items = widget.values;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> newItems = items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              controller: _textEditingController,
              cursorColor: ColorStyles.primaryColor,
              focusNode: _focusNode,
              decoration: InputDecoration(
                  hintText: widget.searchHint,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: const BorderSide(
                      width: 1.0,
                      color: ColorStyles.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: const BorderSide(
                        width: 2.0, color: ColorStyles.primaryColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20.0),
                  hintStyle: TextStyles.body,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide:
                        const BorderSide(width: 2.0, color: ColorStyles.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide:
                        const BorderSide(width: 2.0, color: ColorStyles.red),
                  ),
                  suffix: GestureDetector(
                    onTap: () => _focusNode.requestFocus(),
                    child: const Icon(Icons.search, color: ColorStyles.gray),
                  )),
              style: TextStyles.body,
              keyboardType: TextInputType.multiline,
              textAlign: TextAlign.left,
              // onSaved: widget.onItemSelected,
              onChanged: (String value) async {
                newItems = <String>[];

                if (value.isEmpty) {
                  newItems = widget.values;
                } else {
                  for (var data in widget.values) {
                    if (data.toLowerCase().contains(value.toLowerCase())) {
                      newItems.add(data);
                    }
                  }
                }
                setState(() {
                  items = newItems;
                });
              },
            )),
        Visibility(
          visible: newItems.isNotEmpty,
          child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: ColorStyles.background,
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(0.0),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  //options to add custom field
                  if (index == newItems.length) {
                    return GestureDetector(
                      onTap: () {
                        //todo: open dialog to open custom editing field to add
                      },
                      child: Container(
                        height: 52.0,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        // child: new DashedRect(
                        //   child: new Text(
                        //     "Add Custom",
                        //     style: TextStyles.bodyMedium.copyWith(
                        //         color: ColorStyles.secondaryTextColor),
                        //   ),
                        // ),
                      ),
                    );
                  }

                  return GestureDetector(
                    onTap: () {
                      _textEditingController.text = items[index];

                      widget.onItemSelected(items[index]);

                      setState(() {
                        items = <String>[];
                        newItems = items;
                      });
                    },
                    child: buildSuggestionItem(items[index]),
                  );
                },
                itemCount: (newItems.length + 1),
              )),
        ),
      ],
    );
  }

  Widget buildSuggestionItem(String data) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(bottom: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Text(
          data,
          style: TextStyles.body,
        ));
  }
}
