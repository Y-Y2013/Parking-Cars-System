import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parking_cars/parking_map.dart';
import 'package:parking_cars/Screens/ensure_screen.dart';

class PaymentScreen extends StatefulWidget {
  final int selectedIndex;

  const PaymentScreen({super.key, required this.selectedIndex});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _hours = 1;
  String _method = 'Cash';

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _holderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _holderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_method == 'Visa') {
      final valid = _formKey.currentState?.validate() ?? false;
      if (!valid) return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => Ensure(selectedIndex: widget.selectedIndex),
      ),
    );
  }

  Widget _methodButton(String method, IconData icon) {
    final selected = _method == method;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => setState(() => _method = method),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF7C8CF8) : const Color(0xFF101B33),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? const Color(0xFF9FB0FF) : const Color(0xFF24304A),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                method,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _hours * 10;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF07111F), Color(0xFF0D1A30), Color(0xFF07111F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101B33),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFF24304A)),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 30,
                        color: Colors.black54,
                        offset: Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Your park information',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Slot P${widget.selectedIndex + 1}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 18),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D1628),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF24304A)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _hours,
                              isExpanded: true,
                              dropdownColor: const Color(0xFF101B33),
                              iconEnabledColor: Colors.white,
                              items: List.generate(6, (index) => index + 1)
                                  .map(
                                    (h) => DropdownMenuItem<int>(
                                  value: h,
                                  child: Text(
                                    '$h hour${h > 1 ? 's' : ''}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() => _hours = value);
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D1628),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF24304A)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                '\$$total',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '1 hour = 10\$',
                          style: TextStyle(color: Colors.white54),
                        ),

                        const SizedBox(height: 22),
                        const Text(
                          'Payment method',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _methodButton('Cash', Icons.payments_outlined),
                            const SizedBox(width: 12),
                            _methodButton('Visa', Icons.credit_card_outlined),
                          ],
                        ),
                        if (_method == 'Visa') ...[
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _cardNumberController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16),
                            ],
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Card number',
                              prefixIcon: Icon(Icons.credit_card_outlined),
                            ),
                            validator: (v) =>
                            (v == null || v.length != 16) ? 'اكتب 16 رقم' : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _holderController,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\u0600-\u06FF\s]'),
                              ),
                            ],
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Card holder name',
                              prefixIcon: Icon(Icons.badge_outlined),
                            ),
                            validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'اكتب الاسم' : null,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _expiryController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    labelText: 'MMYY',
                                    prefixIcon: Icon(Icons.date_range_outlined),
                                  ),
                                  validator: (v) =>
                                  (v == null || v.length != 4) ? '4 أرقام' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _cvvController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    labelText: 'CVV',
                                    prefixIcon: Icon(Icons.lock_outline),
                                  ),
                                  validator: (v) =>
                                  (v == null || v.length != 3) ? '3 أرقام' : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 28),
                        ElevatedButton(
                          onPressed: _confirm,
                          child: const Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}