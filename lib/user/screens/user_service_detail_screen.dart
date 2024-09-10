import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:house_cleaning/user/models/service_model.dart';
import '../../theme/custom_colors.dart';

class UserServiceDetailPage extends StatefulWidget {
  final Service service;

  const UserServiceDetailPage({Key? key, required this.service})
      : super(key: key);

  @override
  State<UserServiceDetailPage> createState() => _UserServiceDetailPageState();
}

class _UserServiceDetailPageState extends State<UserServiceDetailPage> {
  final Map<String, int> rooms = {
    'Living Room': 0,
    'Bedroom': 0,
    'Bathroom': 0,
    'Dining Room': 0,
    'Kitchen': 0,
    'Garage': 0,
  };

  double totalPrice = 57.00;
  bool showDateTimeSelection = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Image Section
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.service.imageUrl),
                fit: BoxFit.fill,
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () {
                if (showDateTimeSelection) {
                  setState(() {
                    showDateTimeSelection = false;
                  });
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    "assets/images/chevron_left.svg",
                    width: 10,
                    height: 10,
                  ),
                ),
              ),
            ),
          ),
          // Main content
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.7,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: showDateTimeSelection
                    ? _buildDateTimeSelectionScreen()
                    : _buildLayoutSelectionScreen(scrollController),
              );
            },
          ),
          // Bottom Fixed Section
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: CustomColors.primaryColor, width: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price",
                        style: TextStyle(
                          color: CustomColors.textColorFour,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (showDateTimeSelection) {
                        // Handle final booking action
                      } else {
                        setState(() {
                          showDateTimeSelection = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      showDateTimeSelection ? 'Next' : 'Continue',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutSelectionScreen(ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 30),
        Text(
          widget.service.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: CustomColors.primaryColor,
                fontWeight: FontWeight.w500,
                letterSpacing: -1,
                height: 1,
              ),
        ),
        const SizedBox(height: 20),
        Text(
          "Experience top-notch home cleaning with our expert team. Quick, reliable, and thorough—making your home sparkle effortlessly!",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CustomColors.textColorFour,
                letterSpacing: 0.5,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 32),
        Text(
          "Choose Layout",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: CustomColors.textColorTwo,
          ),
        ),
        const SizedBox(height: 8),
        ...rooms.entries
            .map((entry) => _buildRoomSelector(entry.key, entry.value)),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildDateTimeSelectionScreen() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 30),
        Text(
          widget.service.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: CustomColors.primaryColor,
                fontWeight: FontWeight.w500,
                letterSpacing: -1,
                height: 1,
              ),
        ),
        const SizedBox(height: 20),
        Text(
          "Selected Layout",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: CustomColors.textColorTwo,
          ),
        ),
        const SizedBox(height: 8),
        ...rooms.entries
            .where((entry) => entry.value > 0)
            .map((entry) => Text("${entry.value} ${entry.key}")),
        const SizedBox(height: 32),
        Text(
          "Select Day",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: CustomColors.textColorTwo,
          ),
        ),
        const SizedBox(height: 8),
        _buildDateSelector(),
        const SizedBox(height: 32),
        Text(
          "Select Time",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: CustomColors.textColorTwo,
          ),
        ),
        const SizedBox(height: 8),
        _buildTimeSelector(),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildRoomSelector(String roomName, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: CustomColors.boneColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage("assets/images/home_icon.png"),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(roomName, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.remove, color: CustomColors.textColorFour),
            onPressed:
                count > 0 ? () => _updateRoomCount(roomName, count - 1) : null,
          ),
          Text('$count'),
          IconButton(
            icon: Icon(Icons.add, color: CustomColors.textColorFour),
            onPressed: () => _updateRoomCount(roomName, count + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    final List<String> days = [
      'Mon\n4 Oct',
      'Tue\n5 Oct',
      'Wed\n6 Oct',
      'Thu\n7 Oct'
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) => _buildDateButton(day)).toList(),
      ),
    );
  }

  Widget _buildDateButton(String day) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {
          // Handle date selection
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: CustomColors.primaryColor),
          ),
        ),
        child: Text(
          day,
          textAlign: TextAlign.center,
          style: TextStyle(color: CustomColors.primaryColor),
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    final List<String> times = ['07:00 AM', '07:30 AM', '08:00 AM'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: times.map((time) => _buildTimeButton(time)).toList(),
      ),
    );
  }

  Widget _buildTimeButton(String time) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {
          // Handle time selection
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: CustomColors.primaryColor),
          ),
        ),
        child: Text(
          time,
          style: TextStyle(color: CustomColors.primaryColor),
        ),
      ),
    );
  }

  void _updateRoomCount(String roomName, int newCount) {
    setState(() {
      rooms[roomName] = newCount;
      totalPrice =
          57.00 + rooms.values.reduce((sum, count) => sum + count) * 10;
    });
  }
}
