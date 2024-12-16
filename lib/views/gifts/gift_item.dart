import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:hedieaty/views/event/text_field_with_icon.dart';


class GiftItem extends StatefulWidget {
  final IconData ico;
  final String text;
  final Color icon_bg_color;
  final bool isPledged;

  const GiftItem({
    super.key,
    this.ico = FluentSystemIcons.ic_fluent_gift_filled,
    required this.text,
    this.icon_bg_color = const Color(0xB6AF081F),
    this.isPledged = false,
  });

  @override
  State<GiftItem> createState() => _GiftItemState();
}

class _GiftItemState extends State<GiftItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 3),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 7),
        collapsedBackgroundColor: Colors.transparent,
        shape: const Border(),
        collapsedShape: const Border(),
        title: Row(
          children: [
            const SizedBox(width: 5,),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.isPledged ? Colors.grey : widget.icon_bg_color,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Icon(
                widget.ico,
                color: Colors.grey[200],
                size: 25,
              )
            ),
            const SizedBox(width: 12,),
            Expanded(
              child: Text(
                  widget.text,
                  style: GoogleFonts.lato(textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600
                  )
                )
              ),
            ),
            const SizedBox(width: 5,),
            // widget.isPledged ? const SizedBox() : IconButton(
            //   onPressed: () {},
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blueAccent,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(7),
            //     ),
            //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            //   ),
            //   // TODO: show edit button for the event creator only
            //   icon: Text(
            //       "Edit",
            //       style: GoogleFonts.breeSerif(
            //         textStyle: const TextStyle(
            //             color: Colors.white,
            //             fontSize: 15,
            //         ),
            //       )
            //   ),
            // ),
            SizedBox(width: widget.isPledged ? 8 : 18,),
            // TODO:  hide pledge button for the event creator only if it is not pledged
            IconButton(
              onPressed: () {},
              // TODO: replace tooltip with pledger name
              tooltip: widget.isPledged ? "Kero Noshy": null,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isPledged ? Colors.grey: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              ),
              // TODO: for the user that pledge the gift turn the button to un pledge if the event didn't pass
              icon: Text(
                widget.isPledged ? "Pledged": "Pledge",
                style: GoogleFonts.breeSerif(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 15
                  ),
                )
              ),
            ),
            // const SizedBox(width: 5,)
          ],
        ),
        children: [
          // Divider(),
          // TODO: if there is no description hide this widget
          const TextFieldWithIcon(
            ico: Icons.view_headline_sharp,
            text: "description",
            iconSize: 18,
            iconPadding: 7,
            icon_bg_color: Color(0xE0630FD3),
          ),

          const TextFieldWithIcon(
            ico: Icons.category,
            text: "Category",
            iconSize: 18,
            iconPadding: 7,
            icon_bg_color: Color(0xE0630FD3),
          ),

          const TextFieldWithIcon(
            ico: Icons.attach_money_rounded,
            text: "price",
            iconSize: 18,
            iconPadding: 7,
            icon_bg_color: Color(0xE0630FD3),
          ),

          const TextFieldWithIcon(
            ico: Icons.check_rounded,
            text: "status",
            iconSize: 18,
            iconPadding: 7,
            icon_bg_color: Color(0xE0630FD3),
          ),

          const TextFieldWithIcon(
            ico: Icons.person,
            text: "pledger",
            iconSize: 18,
            iconPadding: 7,
            icon_bg_color: Color(0xE0630FD3),
          ),

          // TODO: Show these buttons for the event creator only if the gift not pledged
          Row (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15,),
              widget.isPledged ? const SizedBox() : IconButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                ),
                // TODO: show edit button for the event creator only
                icon: Row(
                  children: [
                    const Icon(Icons.edit, color: Colors.white,),
                    const SizedBox(width:8,),
                    Text(
                      "Edit",
                      style: GoogleFonts.breeSerif(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )
                    ),
                  ]
                ),
              ),

              const SizedBox(width: 15,),

              widget.isPledged ? const SizedBox() : IconButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                ),
                // TODO: show edit button for the event creator only
                icon: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.white,),
                    const SizedBox(width: 8,),
                    Text(
                      "Delete",
                      style: GoogleFonts.breeSerif(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )
                    ),
                  ]
                ),
              ),
            ],
          ),
          const SizedBox(height: 15,),
        ],
      ),
    );
  }
}
