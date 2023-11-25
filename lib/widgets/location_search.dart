import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application/cubits/location_cubit.dart';
import '../domain/services/directions_service.dart';

class LocationSearch extends StatelessWidget {
  const LocationSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 64, 32, 32),
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text.isEmpty) {
              return const [];
            }
            List<String> suggestions = await getSearchSuggestions(context,
                textEditingValue.text); // Replace with your search function
            return suggestions;
          },
          onSelected: (String selection) {
            log('onSelected: $selection');
            context.read<LocationCubit>().updateLastTappedLocationFromAddress(
                  selection,
                );
            //hide keyboard
            FocusScope.of(context).unfocus();
            Navigator.pop(context, selection);
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options) {
            return Material(
              child: Container(
                width: 150,
                padding: const EdgeInsets.only(right: 36),
                child: ListView(
                  children: options.map((String option) {
                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        title: Text(
                          option,
                          softWrap: true,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Enter destination',
                //border color white
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
                //add a button to clean this at the end
                suffixIcon: IconButton(
                  onPressed: () {
                    textEditingController.clear();
                    Navigator.pop(context, "");
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<String>> getSearchSuggestions(
      BuildContext context, String query) async {
    DirectionsService directionsService = context.read<DirectionsService>();
    log('getSearchSuggestions: $query');
    return await directionsService.getSearchSuggestions(query);
  }
}
