import 'package:flutter/material.dart';
import 'package:openstreetmap/expandesearchnbar.dart';

// Barra de busca sobre o mapa que, ao clicar, abre o modo expansível
class CustomSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Ao clicar na barra de busca, abre a tela expandida
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ExpandedSearchScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.black54),
            const SizedBox(width: 8.0),
            Text(
              'Buscar destinos',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
