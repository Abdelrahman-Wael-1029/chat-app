import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

void defaultShowCountryPicker(context,{
  required Function(Country) onSelect,
  required String labelText,

}) {
  showCountryPicker(
    context: context,
    countryListTheme: CountryListThemeData(
      backgroundColor: Theme.of(context).colorScheme.background,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      inputDecoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.labelLarge,
        prefixIconColor: Theme.of(context).colorScheme.onBackground,
        prefixIcon: const Icon(
          Icons.search,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF8C98A8).withOpacity(0.2),
          ),
        ),
      ),
    ),
    showPhoneCode: true,
    onSelect: onSelect,
  );
}
