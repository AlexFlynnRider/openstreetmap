import 'package:flutter/material.dart';

class ExpandedSearchScreen extends StatefulWidget {
  @override
  _ExpandedSearchScreenState createState() => _ExpandedSearchScreenState();
}

class _ExpandedSearchScreenState extends State<ExpandedSearchScreen> {
  // Controle de estado para saber quais cards estão selecionados
  bool isTerraSelected = false;
  bool isAguaSelected = false;
  bool isArSelected = false;

  // Controle para expandir/colapsar o calendário
  bool isCalendarExpanded = false;
  DateTime selectedDate = DateTime.now(); // Data selecionada no calendário

  // Função para alternar a seleção do card
  void _toggleSelection(String type) {
    setState(() {
      if (type == 'Terra') {
        isTerraSelected = !isTerraSelected;
      } else if (type == 'Água') {
        isAguaSelected = !isAguaSelected;
      } else if (type == 'Ar') {
        isArSelected = !isArSelected;
      }
    });
  }

  // Função para alternar a visibilidade do calendário
  void _toggleCalendar() {
    setState(() {
      isCalendarExpanded = !isCalendarExpanded;
    });
  }

  // Função para selecionar a data no calendário
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Garante que o fundo seja branco
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // Fecha a tela expandida
          },
        ),
        title: const Text('Buscar destinos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Buscar destinos',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Busca flexível', style: TextStyle(fontSize: 18.0)),
          ),
          // Row para exibir os três cards (Terra, Água, Ar)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Card Terra
                Expanded(
                  child: GestureDetector(
                    onTap: () => _toggleSelection('Terra'),
                    child: Card(
                      color: isTerraSelected ? Colors.green[200] : Colors.white,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.landscape,
                                size: 40,
                                color: isTerraSelected
                                    ? Colors.green
                                    : Colors.black),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                                Text('Terra', style: TextStyle(fontSize: 16.0)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Espaço entre os cards
                // Card Água
                Expanded(
                  child: GestureDetector(
                    onTap: () => _toggleSelection('Água'),
                    child: Card(
                      color: isAguaSelected ? Colors.blue[200] : Colors.white,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.water,
                                size: 40,
                                color: isAguaSelected
                                    ? Colors.blue
                                    : Colors.black),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                                Text('Água', style: TextStyle(fontSize: 16.0)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Espaço entre os cards
                // Card Ar
                Expanded(
                  child: GestureDetector(
                    onTap: () => _toggleSelection('Ar'),
                    child: Card(
                      color:
                          isArSelected ? Colors.lightBlue[200] : Colors.white,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.air,
                                size: 40,
                                color: isArSelected
                                    ? Colors.lightBlue
                                    : Colors.black),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Ar', style: TextStyle(fontSize: 16.0)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Card de calendário expansível
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: _toggleCalendar,
              child: Card(
                color: Colors.white,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(
                        'Quando',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      subtitle: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    if (isCalendarExpanded)
                      Container(
                        height: 300, // Altura do calendário
                        child: CalendarDatePicker(
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          onDateChanged: (DateTime newDate) {
                            setState(() {
                              selectedDate = newDate;
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Europa'),
                  leading: const Icon(Icons.map),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Função para limpar tudo
                    setState(() {
                      isTerraSelected = false;
                      isAguaSelected = false;
                      isArSelected = false;
                      selectedDate =
                          DateTime.now(); // Reseta a data selecionada
                    });
                  },
                  child: const Text('Limpar tudo',
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Ação de busca
                    if (isTerraSelected) {
                      print("Busca por Terra");
                    }
                    if (isAguaSelected) {
                      print("Busca por Água");
                    }
                    if (isArSelected) {
                      print("Busca por Ar");
                    }
                    print("Data selecionada: $selectedDate");
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 15.0),
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search),
                      SizedBox(width: 8.0),
                      Text('Buscar'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
