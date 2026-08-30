import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/payments/cmp_payment_method.dart';
import '../../views/payments/payment_method.dart';
import '../globals/card/globals_card.dart';
import '../globals/colors/colors.dart';
import '../globals/text/text_style.dart';

class PaymentCmp extends StatefulWidget {
  final String doctorName;
  final String specialization;
  final String price;
  final String session;
  final bool isExpertGroup;
  final String textButton;
  final VoidCallback? onPressedButton;
  final String paymentMethodLabel;
  final ValueChanged<String>? onPaymentMethodSelected;

  const PaymentCmp({
    super.key,
    required this.doctorName,
    required this.specialization,
    required this.price,
    required this.session,
    this.isExpertGroup = false,
    this.textButton = "Aktifkan Langganan",
    required this.onPressedButton,
    this.paymentMethodLabel = 'Pilih metode pembayaran',
    this.onPaymentMethodSelected,
  });

  @override
  State<PaymentCmp> createState() => _PaymentCmpState();
}

class _PaymentCmpState extends State<PaymentCmp> {
  bool _isDetailVisible = false;
  bool _isCoinUsed = false;
  PaymentMethodOption? _selectedPaymentMethod;

  String get _paymentMethodLabel {
    return switch (_selectedPaymentMethod) {
      PaymentMethodOption.qris => 'QRIS',
      PaymentMethodOption.gopay => 'Gopay',
      PaymentMethodOption.virtualAccount => 'Virtual Account (VA)',
      PaymentMethodOption.card => 'Debit/Credit Card',
      null => 'Pilih metode pembayaran',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Harga/short inf
        GlobalsCard(
          gradient: widget.isExpertGroup
              ? LinearGradient(
                  begin: Alignment.bottomRight,
                  transform: const GradientRotation(7),
                  end: Alignment.topLeft,
                  colors: [
                    AppColors.warn2..withValues(alpha: 0.8 * 255.round()),
                    const Color(
                      0xB2FFF6F6,
                    ).withValues(alpha: 0.7 * 255.round()),
                    const Color(
                      0x80FFFAE1,
                    ).withValues(alpha: 0.5 * 255.round()),
                  ],
                )
              : null,
          hasShadow: false,
          padding: const EdgeInsets.all(12),
          backgroundColor: widget.isExpertGroup ? null : AppColors.base4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    height: 18,
                    width: 18,
                    colorFilter: const ColorFilter.mode(
                      AppColors.base1,
                      BlendMode.srcIn,
                    ),
                    'assets/svg/ic_coupon - ticket.svg',
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.doctorName,
                    style: AppTextStyles.heading2SemiBold(),
                  ),
                ],
              ),
              Text(
                'Dokter Spesialis ${widget.specialization}',
                style: AppTextStyles.lable3Medium(AppColors.base2),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _isDetailVisible = !_isDetailVisible;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Rp${widget.price}k",
                          style: AppTextStyles.heading1SemiBold(
                            AppColors.secondary2,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Column(
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              '/ ${widget.session} Sesi',
                              style: AppTextStyles.lable3Medium(
                                AppColors.base2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Icon(
                      _isDetailVisible
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                    ),
                  ],
                ),
              ),
              // bagian ini bisa disembunyikan
              if (_isDetailVisible) ...[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  height: 1.5,
                  color: widget.isExpertGroup
                      ? AppColors.warn2
                      : AppColors.base2,
                  width: MediaQuery.of(context).size.width / 1.05,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      height: 20,
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.base1,
                        BlendMode.srcIn,
                      ),
                      'assets/svg/ic_clock.svg',
                    ),
                    Text('Durasi :', style: AppTextStyles.headList1Regular()),
                    Text('30 Menit', style: AppTextStyles.headList1Bold()),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      height: 20,
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.base1,
                        BlendMode.srcIn,
                      ),
                      'assets/svg/chat-rounded.svg',
                    ),
                    Text('Media :', style: AppTextStyles.headList1Regular()),
                    Text(
                      'Chat (teks & gambar)',
                      style: AppTextStyles.headList1Regular(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      height: 20,
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.base1,
                        BlendMode.srcIn,
                      ),
                      'assets/svg/ic_ calendar - schedule.svg',
                    ),
                    Text('Jadwal', style: AppTextStyles.headList1Regular()),
                    Text(
                      'Bebas Selama Dokter Tersedia',
                      style: AppTextStyles.headList1Regular(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      height: 20,
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.base1,
                        BlendMode.srcIn,
                      ),
                      'assets/svg/ic_coupon - ticket.svg',
                    ),
                    Text(
                      'Berlaku Hingga',
                      style: AppTextStyles.headList1Regular(),
                    ),
                    Text(
                      '30 Hari dari Pembelian',
                      style: AppTextStyles.headList1Bold(),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        // Metode Pembayaran
        GlobalsCard(
          onTap: () async {
            final selected = await Navigator.push<PaymentMethodOption>(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PaymentMethod(initialSelection: _selectedPaymentMethod),
              ),
            );

            if (selected == null || !mounted) return;

            setState(() {
              _selectedPaymentMethod = selected;
            });
            widget.onPaymentMethodSelected?.call(_paymentMethodLabel);
          },
          padding: const EdgeInsets.symmetric(horizontal: 12),
          backgroundColor: AppColors.base4,
          height: 42,
          hasShadow: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    height: 18,
                    width: 18,
                    colorFilter: const ColorFilter.mode(
                      AppColors.base1,
                      BlendMode.srcIn,
                    ),
                    'assets/svg/ic_credit_card.svg',
                  ),
                  const SizedBox(width: 15),
                  Text(
                    widget.paymentMethodLabel,
                    style: AppTextStyles.heading3SemiBold(),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
        // tukar koin
        GlobalsCard(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          backgroundColor: AppColors.base4,
          hasShadow: false,
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    height: 18,
                    width: 18,
                    'assets/svg/ic_coin.svg',
                  ),
                  const SizedBox(width: 15),
                  RichText(
                    text: TextSpan(
                      text: 'Tukarkan ',
                      style: AppTextStyles.heading3SemiBold(AppColors.base1),
                      children: <TextSpan>[
                        TextSpan(
                          text: '3000',
                          style: AppTextStyles.heading3SemiBold(
                            AppColors.primary1,
                          ),
                        ),
                        const TextSpan(text: ' Koin Sporky'),
                      ],
                    ),
                  ),
                ],
              ),
              Switch(
                value: _isCoinUsed,
                onChanged: (bool value) {
                  setState(() {
                    _isCoinUsed = value;
                    // nanti bisa trigger logika total bayar juga di sini
                  });
                },
                activeThumbColor: AppColors.primary1,
                inactiveThumbColor: AppColors.base5,
                inactiveTrackColor: AppColors.base3,
                trackOutlineColor: const WidgetStatePropertyAll(
                  AppColors.base3,
                ),
              ),
            ],
          ),
        ),
        GlobalsCard(
          padding: const EdgeInsets.all(12),
          backgroundColor: AppColors.base4,
          hasShadow: false,
          child: Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    height: 18,
                    width: 18,
                    'assets/svg/ic_ bill.svg',
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Rincian Pembayaran",
                    style: AppTextStyles.heading3SemiBold(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Harga Paket Berlangganan",
                        style: AppTextStyles.list1Regular(AppColors.base2),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Biaya Layanan 1%",
                        style: AppTextStyles.list1Regular(AppColors.base2),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Pajak 2%",
                        style: AppTextStyles.list1Regular(AppColors.base2),
                      ),
                      const SizedBox(height: 3),
                      RichText(
                        text: TextSpan(
                          text: 'Koin Ditukarkan: ',
                          style: AppTextStyles.list1Regular(AppColors.base2),
                          children: <TextSpan>[
                            TextSpan(
                              text: '3000',
                              style: AppTextStyles.list1Medium(
                                AppColors.primary1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Total Pembayaran",
                        style: AppTextStyles.headList1Medium(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Rp2.000.000",
                        style: AppTextStyles.list1Regular(AppColors.base2),
                      ),
                      Text(
                        "Rp300.000",
                        style: AppTextStyles.list1Regular(AppColors.base2),
                      ),
                      Text(
                        "-Rp3.000",
                        style: AppTextStyles.list1Regular(AppColors.base2),
                      ),
                      Text(
                        "Rp2.297.000",
                        style: AppTextStyles.headList1Medium(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: GlobalsButton(
            color: _isCoinUsed ? AppColors.secondary1 : AppColors.secondary3,
            text: widget.textButton,
            customTextStyle: AppTextStyles.headList1Bold(),
            onPressed: widget.onPressedButton,
          ),
        ),
      ],
    );
  }
}
