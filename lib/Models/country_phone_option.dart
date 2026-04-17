class CountryPhoneOption {
  final String name;
  final String dialCode;
  final int minDigits;
  final int maxDigits;

  const CountryPhoneOption({
    required this.name,
    required this.dialCode,
    required this.minDigits,
    required this.maxDigits,
  });

  String get title => '$name ($dialCode)';

  String get digitsRule {
    if (minDigits == maxDigits) {
      return '$minDigits digits';
    }
    return '$minDigits-$maxDigits digits';
  }
}

const CountryPhoneOption kDefaultCountryPhoneOption = CountryPhoneOption(
  name: 'Saudi Arabia',
  dialCode: '+966',
  minDigits: 9,
  maxDigits: 9,
);

const List<CountryPhoneOption> kCountryPhoneOptions = [
  kDefaultCountryPhoneOption,
  CountryPhoneOption(
    name: 'Egypt',
    dialCode: '+20',
    minDigits: 10,
    maxDigits: 10,
  ),
  CountryPhoneOption(
    name: 'UAE',
    dialCode: '+971',
    minDigits: 9,
    maxDigits: 9,
  ),
  CountryPhoneOption(
    name: 'Kuwait',
    dialCode: '+965',
    minDigits: 8,
    maxDigits: 8,
  ),
  CountryPhoneOption(
    name: 'Qatar',
    dialCode: '+974',
    minDigits: 8,
    maxDigits: 8,
  ),
  CountryPhoneOption(
    name: 'USA / Canada',
    dialCode: '+1',
    minDigits: 10,
    maxDigits: 10,
  ),
  CountryPhoneOption(
    name: 'UK',
    dialCode: '+44',
    minDigits: 10,
    maxDigits: 11,
  ),
];