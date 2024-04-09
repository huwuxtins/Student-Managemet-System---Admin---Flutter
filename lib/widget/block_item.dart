import 'package:flutter/material.dart';

class BlockItem extends StatefulWidget {
  final String title;
  final int number;
  final String image;
  const BlockItem(
      {key, required this.title, required this.number, required this.image})
      : super(key: key);

  @override
  State<BlockItem> createState() => _BlockItemState();
}

class _BlockItemState extends State<BlockItem> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (value) {
        setState(() {
          isHover = value;
        });
      },
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isHover
                ? const Color.fromARGB(255, 233, 245, 255)
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(color: Colors.blue, fontSize: 30),
                ),
                Text(
                  "${widget.number}",
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                )
              ],
            ),
            Image.network(
              widget.image,
              height: 100,
              width: 100,
            ),
          ],
        ),
      ),
    );
  }
}
