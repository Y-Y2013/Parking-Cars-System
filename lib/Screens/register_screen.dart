import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parking_cars/Models/country_phone_option.dart';
import 'package:parking_cars/Services/storage_service.dart';
import 'package:parking_cars/Screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _phoneController = TextEditingController();

  CountryPhoneOption _selectedCountry = kDefaultCountryPhoneOption;
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _phoneValidator(String? value) {
    final digits = value?.trim() ?? '';

    if (digits.isEmpty) return 'اكتب رقم الهاتف';
    if (!RegExp(r'^\d+$').hasMatch(digits)) return 'الأرقام فقط';

    if (digits.length < _selectedCountry.minDigits ||
        digits.length > _selectedCountry.maxDigits) {
      if (_selectedCountry.minDigits == _selectedCountry.maxDigits) {
        return 'رقم ${_selectedCountry.name} يجب أن يكون ${_selectedCountry.minDigits} أرقام';
      }
      return 'رقم ${_selectedCountry.name} يجب أن يكون بين ${_selectedCountry.minDigits} و ${_selectedCountry.maxDigits} أرقام';
    }

    return null;
  }

  Future<void> _register() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _loading = true);

    final fullPhone =
        '${_selectedCountry.dialCode}${_phoneController.text.trim()}';

    final success = await StorageService.registerUser(
      _usernameController.text,
      _passwordController.text,
      fullPhone,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اسم المستخدم موجود بالفعل أو البيانات غير صحيحة'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إنشاء الحساب بنجاح'),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg1 = Color(0xFF07111F);
    const bg2 = Color(0xFF0D1A30);
    const card = Color(0xFF101B33);
    const border = Color(0xFF24304A);
    const accent = Color(0xFF7C8CF8);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bg1, bg2, bg1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: border),
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
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 74,
                            height: 74,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D1628),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: accent.withOpacity(.35),
                              ),
                            ),
                            child: const Icon(
                              Icons.person_add_alt_1_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Create account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Make a new user to enter the system',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _usernameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'اكتب اسم المستخدم'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 150,
                              child: DropdownButtonFormField<CountryPhoneOption>(
                                value: _selectedCountry,
                                isExpanded: true,
                                dropdownColor: card,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  labelText: 'Code',
                                  prefixIcon: Icon(Icons.public),
                                ),
                                items: kCountryPhoneOptions
                                    .map(
                                      (country) =>
                                      DropdownMenuItem<CountryPhoneOption>(
                                        value: country,
                                        child: Text(country.title),
                                      ),
                                )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  setState(() {
                                    _selectedCountry = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Phone',
                                  prefixIcon: const Icon(Icons.phone),
                                  hintText: _selectedCountry.minDigits ==
                                      _selectedCountry.maxDigits
                                      ? 'Enter ${_selectedCountry.minDigits} digits'
                                      : 'Enter ${_selectedCountry.minDigits}-${_selectedCountry.maxDigits} digits',
                                ),
                                validator: _phoneValidator,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (v) =>
                          (v == null || v.trim().length < 4)
                              ? 'كلمة المرور لا تقل عن 4 أحرف'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _confirmController,
                          obscureText: _obscureConfirm,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Confirm password',
                            prefixIcon: const Icon(Icons.lock_reset_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirm = !_obscureConfirm;
                                });
                              },
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'أكد كلمة المرور';
                            }
                            if (v != _passwordController.text) {
                              return 'كلمتا المرور غير متطابقتين';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 22),
                        ElevatedButton(
                          onPressed: _loading ? null : _register,
                          child: _loading
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Already have an account? Login'),
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