import 'package:flutter/material.dart';

/// Dinamik IconData çözümleyici helper.
/// Release build tree shaking hatalarını önlemek için bilinen ikon sabitlerini eşleştirir.
IconData getSafeIconData(int? codePoint, {IconData fallback = Icons.label_rounded}) {
  if (codePoint == null) return fallback;

  final knownIcons = <int, IconData>{
    Icons.label_rounded.codePoint: Icons.label_rounded,
    Icons.devices_rounded.codePoint: Icons.devices_rounded,
    Icons.tv_rounded.codePoint: Icons.tv_rounded,
    Icons.laptop_chromebook_rounded.codePoint: Icons.laptop_chromebook_rounded,
    Icons.smartphone_rounded.codePoint: Icons.smartphone_rounded,
    Icons.kitchen_rounded.codePoint: Icons.kitchen_rounded,
    Icons.wash_rounded.codePoint: Icons.wash_rounded,
    Icons.microwave_rounded.codePoint: Icons.microwave_rounded,
    Icons.air_rounded.codePoint: Icons.air_rounded,
    Icons.headset_rounded.codePoint: Icons.headset_rounded,
    Icons.watch_rounded.codePoint: Icons.watch_rounded,
    Icons.camera_alt_rounded.codePoint: Icons.camera_alt_rounded,
    Icons.directions_car_rounded.codePoint: Icons.directions_car_rounded,
    Icons.two_wheeler_rounded.codePoint: Icons.two_wheeler_rounded,
    Icons.build_rounded.codePoint: Icons.build_rounded,
    Icons.lightbulb_rounded.codePoint: Icons.lightbulb_rounded,
    Icons.chair_rounded.codePoint: Icons.chair_rounded,
    Icons.home_max_rounded.codePoint: Icons.home_max_rounded,
    Icons.restaurant_rounded.codePoint: Icons.restaurant_rounded,
    Icons.local_grocery_store_rounded.codePoint: Icons.local_grocery_store_rounded,
    Icons.local_pharmacy_rounded.codePoint: Icons.local_pharmacy_rounded,
    Icons.sanitizer_rounded.codePoint: Icons.sanitizer_rounded,
    Icons.clean_hands_rounded.codePoint: Icons.clean_hands_rounded,
    Icons.soap_rounded.codePoint: Icons.soap_rounded,
    Icons.checkroom_rounded.codePoint: Icons.checkroom_rounded,
    Icons.pets_rounded.codePoint: Icons.pets_rounded,
    Icons.baby_changing_station_rounded.codePoint: Icons.baby_changing_station_rounded,
    Icons.medical_services_rounded.codePoint: Icons.medical_services_rounded,
    Icons.category_rounded.codePoint: Icons.category_rounded,
    Icons.build_circle_outlined.codePoint: Icons.build_circle_outlined,
    Icons.phone_in_talk_rounded.codePoint: Icons.phone_in_talk_rounded,
    Icons.wifi_rounded.codePoint: Icons.wifi_rounded,
    Icons.description_outlined.codePoint: Icons.description_outlined,
  };

  return knownIcons[codePoint] ?? fallback;
}
