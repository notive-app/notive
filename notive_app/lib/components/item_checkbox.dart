import 'package:flutter/material.dart';
import 'package:notive_app/models/item_model.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:provider/provider.dart';


class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label)),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ItemCheckBox extends StatefulWidget {
  ItemModel item;

  ItemCheckBox({this.item});

  @override
  _ItemCheckBoxState createState() => _ItemCheckBoxState();
}

class _ItemCheckBoxState extends State<ItemCheckBox> {

  @override
  Widget build(BuildContext context) {
    bool _isSelected = widget.item.isFiltered;
    return LabeledCheckbox(
      label: widget.item.name,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: _isSelected,
      onChanged: (bool newValue) {
        setState(() {
          _isSelected = newValue;
          widget.item.setFiltered(newValue);
          Provider.of<UserModel>(context, listen: false).changeItemIsFiltered(widget.item, newValue);
        });
      },
    );
  }
}