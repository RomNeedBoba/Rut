import 'package:flutter/material.dart';
import 'package:rut/models/historyRace_model.dart';

class HistoryResultView extends StatelessWidget {
  final HistoryRace race;
  final bool isDarkMode;
  final VoidCallback? toggleTheme;

  const HistoryResultView({
    super.key,
    required this.race,
    this.isDarkMode = false,
    this.toggleTheme,
  });

  String format(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final results = [...race.results]
      ..sort((a, b) => a.totalTime.compareTo(b.totalTime));

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final headerColor = isDarkMode ? Colors.grey[850] : Colors.grey[300];
    final rowColorEven = isDarkMode ? Colors.grey[900] : Colors.grey[100];
    final rowColorOdd = isDarkMode ? Colors.grey[800] : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          race.raceName,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : null,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          if (toggleTheme != null)
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: toggleTheme,
              color: textColor,
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: isNarrow ? 600 : constraints.maxWidth,
                ),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(headerColor),
                  columnSpacing: 20,
                  columns: [
                    DataColumn(
                        label:
                            Text('Rank', style: TextStyle(color: textColor))),
                    DataColumn(
                        label: Text('BIB', style: TextStyle(color: textColor))),
                    DataColumn(
                        label:
                            Text('Name', style: TextStyle(color: textColor))),
                    DataColumn(
                        label:
                            Text('Swim', style: TextStyle(color: textColor))),
                    DataColumn(
                        label:
                            Text('Cycle', style: TextStyle(color: textColor))),
                    DataColumn(
                        label: Text('Run', style: TextStyle(color: textColor))),
                    DataColumn(
                        label:
                            Text('Total', style: TextStyle(color: textColor))),
                  ],
                  rows: List<DataRow>.generate(results.length, (index) {
                    final r = results[index];
                    return DataRow(
                      color: WidgetStateProperty.all(
                        index.isEven ? rowColorEven : rowColorOdd,
                      ),
                      cells: [
                        DataCell(Text('${index + 1}',
                            style: TextStyle(color: textColor))),
                        DataCell(Text(r.bibNumber,
                            style: TextStyle(color: textColor))),
                        DataCell(Text(r.participantName,
                            style: TextStyle(color: textColor))),
                        DataCell(Text(format(r.swimTime),
                            style: TextStyle(color: textColor))),
                        DataCell(Text(format(r.cycleTime),
                            style: TextStyle(color: textColor))),
                        DataCell(Text(format(r.runTime),
                            style: TextStyle(color: textColor))),
                        DataCell(Text(format(r.totalTime),
                            style: TextStyle(color: textColor))),
                      ],
                    );
                  }),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
