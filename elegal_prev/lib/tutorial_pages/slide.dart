import 'package:flutter/material.dart';

class Slide {
  final String imagePath;
  final String title;
  final String description;

  Slide({
    @required this.imagePath,
    @required this.title,
    @required this.description
  });
}

final slideList = [
  Slide(
      imagePath: "assets/img/Asset 1.png",
      title: "Obtener asesoria legal nunca fue tan facil",
      description: "Simplemente registrate en un solo paso y obtendras asesoria legal en la palma de tu mano."
  ),
  Slide(
      imagePath: "assets/img/Asset 2.png",
      title: "Dictámenes",
      description: "Tu asesoría por escrito elaborada y firmada por un abogado con experiencia."
  ),
  Slide(
      imagePath: "assets/img/Asset 3.png",
      title: "Pólizas",
      description: "Pólizas anuales con consultas limitadas a un bajo costo."
  ),
];