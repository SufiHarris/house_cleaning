import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../theme/custom_colors.dart';

class DateSelectionPage extends StatefulWidget {
  const DateSelectionPage({Key? key}) : super(key: key);

  @override
  _DateSelectionPageState createState() => _DateSelectionPageState();
}

class _DateSelectionPageState extends State<DateSelectionPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CustomColors.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "${_focusedDay.month}", // Dynamically show the month based on selected day
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: CustomColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // Update focusedDay as well
                });
              },
              calendarStyle: CalendarStyle(
                todayTextStyle: TextStyle(color: CustomColors.primaryColor),
                selectedDecoration: BoxDecoration(
                  color: CustomColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon:
                    Icon(Icons.chevron_left, color: CustomColors.primaryColor),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: CustomColors.primaryColor),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedDay = DateTime.now();
                      _focusedDay = DateTime.now();
                    });
                  },
                  child: const Text("Today"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.eggPlant,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedDay =
                          DateTime.now().add(const Duration(days: 1));
                      _focusedDay = _selectedDay;
                    });
                  },
                  child: const Text("Tomorrow"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.eggPlant,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle date confirmation and return the selected date
                Navigator.pop(context, _selectedDay);
              },
              child: const Text("Confirm Date"),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.eggPlant,
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
