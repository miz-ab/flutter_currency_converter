class Country {
  String countryCode;
  String name;

  Country(this.countryCode, this.name);

  static List<Country> getCountries() {
    return <Country>[
      Country('ETB', 'Ethiopian Birr'),
      Country('USD', 'American Dollar'),
      Country('EUR', 'Euro'),
      Country('AUD', 'Australian Dollar'),
      Country('SOS', 'Somali Shilling'),
      Country('SDG', 'Sudanese Pound'),
      Country('DKK', 'Danish Krone'),
      Country('ILS', 'Israeli New Sheqel'),
      Country('KWD', 'Kuwaiti Dinar'),
      Country('NGN', 'Nigerian Naira'),
      Country('CAD', 'Canadian Dollar'),
    ];
  }
}
