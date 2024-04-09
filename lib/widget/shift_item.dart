import 'package:admin/model/shift.dart';
import 'package:flutter/material.dart';

class ShiftItem extends StatefulWidget {
  const ShiftItem({key, required this.shift, this.lop}) : super(key: key);

  final Shift shift;
  final String? lop;

  @override
  State<ShiftItem> createState() => _ShiftItemState();
}

class _ShiftItemState extends State<ShiftItem> {
  bool isHover = false;
  late String? _lop;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lop = widget.lop;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (value) {
        isHover = value;
      },
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: isHover
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              (_lop != null) ? _lop! : "",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Divider(
              indent: 50,
              endIndent: 50,
            ),
            Text(
              widget.shift.subject!.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
