import 'package:flutter/material.dart';
import '../../../../utill/styles.dart';

class PricesView extends StatelessWidget {
  final bool? firstCut;
  final bool? centerAlign;
  final int marketPrice;
  final Color? marketColor;
  final double offerPrice;
  final Color? offerColor;
  const PricesView(
      {Key? key,
      required this.marketPrice,
      this.marketColor = const Color(0xFF848484),
      required this.offerPrice,
      this.offerColor = const Color(0xFF0B4619),
      this.firstCut = true, this.centerAlign=false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: !centerAlign!?MainAxisAlignment.start:MainAxisAlignment.center,
      children: [
        firstCut == true
            ? Text(
                '₹$marketPrice',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: poppinsRegular.copyWith(
                    color: marketColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough),
              )
            : const SizedBox(),
        firstCut == true ? const SizedBox(width: 5) : const SizedBox(),
        Text(
          '₹${offerPrice.toStringAsFixed(2)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: poppinsRegular.copyWith(
              color: offerColor, fontWeight: FontWeight.w500, fontSize: 12),
        ),
        firstCut == false ? const SizedBox(width: 5) : const SizedBox(),
        firstCut == false
            ? Text(
                '₹${marketPrice.toStringAsFixed(2)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: poppinsRegular.copyWith(
                    color: marketColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough),
              )
            : const SizedBox(),
      ],
    );
  }
}
