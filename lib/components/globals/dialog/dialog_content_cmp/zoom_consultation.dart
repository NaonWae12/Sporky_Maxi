import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/globals_card_outlined.dart';
import 'package:sporky_maxi/components/globals/form/globals_form.dart';

import '../../../../views/payments/payment_page.dart';
import '../../card/globals_card.dart';
import '../../colors/colors.dart';
import '../../text/text_style.dart';

class ZoomConsultation extends StatefulWidget {
  final String? imageAsset;
  final double? price;
  final String? doctorName;

  const ZoomConsultation(
      {this.imageAsset,
      this.price,
      this.doctorName = "dr. Natasha, Sp.GK",
      super.key});

  @override
  State<ZoomConsultation> createState() => _ZoomConsultationState();
}

class _ZoomConsultationState extends State<ZoomConsultation> {
  final TextEditingController controller = TextEditingController(text: "0");

  int get currentValue => int.tryParse(controller.text) ?? 0;

  void increment() {
    setState(() {
      controller.text = (currentValue + 1).toString();
    });
  }

  void decrement() {
    if (currentValue > 0) {
      setState(() {
        controller.text = (currentValue - 1).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: widget.imageAsset != null
                      ? Image.asset(
                          widget.imageAsset!,
                          height: 102,
                          width: 80,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 102,
                          width: 80,
                          color: AppColors.base3,
                          child: const Icon(
                            Icons.broken_image,
                            size: 28,
                            color: AppColors.base2,
                          ),
                        ),
                ),
                Positioned(
                  bottom: 3,
                  child: GlobalsCard(
                    height: 16,
                    backgroundColor: AppColors.success1,
                    child: Row(
                      children: [
                        const SizedBox(width: 5),
                        SvgPicture.asset(
                          'assets/svg/ic_ video call.svg',
                          height: 18,
                          width: 18,
                          colorFilter: const ColorFilter.mode(
                              AppColors.base5, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalsCardOutlined(
                  text: 'Ticket Video Call',
                  textStyle: AppTextStyles.list1SemiBold(AppColors.base1),
                ),
                Text('${widget.doctorName}',
                    style: AppTextStyles.heading1SemiBold(AppColors.base1)),
                GlobalsCard(
                    margin: const EdgeInsets.all(0),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    radius: 6,
                    backgroundColor: AppColors.base4,
                    hasShadow: false,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/ic_coupon - ticket.svg',
                          height: 18,
                          width: 18,
                          colorFilter: const ColorFilter.mode(
                              AppColors.base1, BlendMode.srcIn),
                        ),
                        Text('Rp. ${widget.price?.toStringAsFixed(0) ?? "0"}',
                            style: AppTextStyles.list1SemiBold(AppColors.base1))
                      ],
                    ))
              ],
            )
          ],
        ),
        Divider(
          color: AppColors.base3,
          height: 32,
        ),
        GlobalsCard(
            margin: const EdgeInsets.all(8.0),
            hasShadow: false,
            backgroundColor: AppColors.base4,
            radius: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlobalsCard(
                    padding: const EdgeInsets.all(8.0),
                    backgroundColor: AppColors.base5,
                    radius: 10,
                    hasShadow: false,
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svg/ic_coupon - ticket.svg',
                            colorFilter: const ColorFilter.mode(
                                AppColors.base1, BlendMode.srcIn)),
                        Text('Jumlah :',
                            style:
                                AppTextStyles.list1SemiBold(AppColors.base1)),
                      ],
                    )),
                Stack(children: [
                  GlobalsCard(
                    width: 110,
                    height: 38,
                    hasShadow: false,
                    border: Border.all(color: AppColors.secondary1),
                    backgroundColor: AppColors.base5,
                    child: Center(
                      child: IntrinsicWidth(
                        child: GlobalsForm(
                          focusBorderColor: Colors.transparent,
                          enableBorderColor: Colors.transparent,
                          labelColor: AppColors.base1,
                          outlineInputBorderColor: Colors.transparent,
                          enableFloatingLabel: false,
                          hasShadow: false,
                          controller: controller,
                          label: '0',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: GlobalsCard(
                        onTap: decrement,
                        radius: 8,
                        hasShadow: false,
                        backgroundColor: AppColors.secondary1,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 10.0),
                        child: Text('—',
                            style: AppTextStyles.list1Bold(AppColors.base5))),
                  ),
                  Positioned(
                    right: 0,
                    child: GlobalsCard(
                        onTap: increment,
                        radius: 8,
                        hasShadow: false,
                        backgroundColor: AppColors.secondary1,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 10.0),
                        child: Text('+',
                            style: AppTextStyles.list1Bold(AppColors.base5))),
                  ),
                ])
              ],
            )),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: GlobalsButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PaymentPage()));
            },
            color: AppColors.secondary1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/svg/ic_coupon - ticket.svg'),
                const SizedBox(width: 8),
                Text(
                  'Beli Tiket Konsultasi',
                  style: AppTextStyles.headList1Bold(AppColors.base5),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
