import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/routing/routes.dart';

class TransportSearchScreen extends StatefulWidget {
  const TransportSearchScreen({super.key});

  @override
  State<TransportSearchScreen> createState() => _TransportSearchScreenState();
}

class _TransportSearchScreenState extends State<TransportSearchScreen> {
  int _selectedFilter = 0;

  final List<Map<String, dynamic>> _filters = [
    {'label': 'Fastest', 'icon': Icons.bolt},
    {'label': 'Cheapest', 'icon': Icons.credit_card},
    {'label': 'Early Bird', 'icon': Icons.wb_sunny_outlined},
    {'label': 'Latest', 'icon': Icons.nights_stay_outlined},
    {'label': 'Direct', 'icon': Icons.linear_scale},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterTabs(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  _buildTransportCard(
                    logoColor: const Color(0xFF1A3A6B),
                    logoIcon: Icons.train,
                    operatorName: 'ENR Talgo',
                    classType: 'First Class • VIP',
                    price: 'EGP 850',
                    priceColor: const Color(0xFF00E5FF),
                    departureTime: '08:00',
                    departureStation: 'CAIRO (RAMSES)',
                    arrivalTime: '18:30',
                    arrivalStation: 'ASWAN',
                    duration: '10h 30m',
                    stops: 'Direct',
                    amenities: [Icons.wifi, Icons.restaurant, Icons.bolt],
                    hasNextDay: false,
                    lineColor: const Color(0xFF00E5FF),
                  ),
                  const SizedBox(height: 16),
                  _buildTransportCard(
                    logoColor: const Color(0xFF6B2FBF),
                    logoIcon: Icons.directions_bus,
                    operatorName: 'Blue Bus',
                    classType: 'Business Class',
                    price: 'EGP 650',
                    priceColor: const Color(0xFF00E5FF),
                    departureTime: '10:30',
                    departureStation: 'CAIRO (TAHRIR)',
                    arrivalTime: '22:45',
                    arrivalStation: 'ASWAN',
                    duration: '12h 15m',
                    stops: '1 Stop',
                    amenities: [Icons.chat_bubble_outline, Icons.usb],
                    hasNextDay: false,
                    lineColor: const Color(0xFF00E5FF),
                  ),
                  const SizedBox(height: 16),
                  _buildTransportCard(
                    logoColor: const Color(0xFFE67E22),
                    logoIcon: Icons.directions_bus,
                    operatorName: 'Go Bus',
                    classType: 'Economy Plus',
                    price: 'EGP 450',
                    priceColor: Colors.white,
                    departureTime: '14:00',
                    departureStation: 'CAIRO (NASR)',
                    arrivalTime: '03:00',
                    arrivalStation: 'ASWAN',
                    duration: '13h 00m',
                    stops: '2 Stops',
                    amenities: [],
                    hasNextDay: true,
                    lineColor: const Color(0xFF4A5568),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2E4A),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          const Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cairo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Text(
                      'Aswan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  'THU, 24 OCT • 1 PASSENGER',
                  style: TextStyle(color: Color(0xFF8BA0B8), fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2E4A),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.tune, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFilter == index;
          final filter = _filters[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.transparent
                      : const Color(0xFF1A2E4A),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF00E5FF)
                        : const Color(0xFF2A3F5A),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      filter['icon'] as IconData,
                      color: isSelected
                          ? const Color(0xFF00E5FF)
                          : Colors.white54,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      filter['label'] as String,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF00E5FF)
                            : Colors.white54,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransportCard({
    required Color logoColor,
    required IconData logoIcon,
    required String operatorName,
    required String classType,
    required String price,
    required Color priceColor,
    required String departureTime,
    required String departureStation,
    required String arrivalTime,
    required String arrivalStation,
    required String duration,
    required String stops,
    required List<IconData> amenities,
    required bool hasNextDay,
    required Color lineColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF112240),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Top row: logo, name, price
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: logoColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(logoIcon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      operatorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      classType,
                      style: const TextStyle(
                        color: Color(0xFF8BA0B8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                price,
                style: TextStyle(
                  color: priceColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Times row
          Row(
            children: [
              // Departure
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    departureTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    departureStation,
                    style: const TextStyle(
                      color: Color(0xFF8BA0B8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              // Line in middle
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      Text(
                        duration,
                        style: const TextStyle(
                          color: Color(0xFF8BA0B8),
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              border: Border.all(color: lineColor, width: 2),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Container(height: 1.5, color: lineColor),
                          ),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: lineColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stops,
                        style: const TextStyle(
                          color: Color(0xFF8BA0B8),
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              // Arrival
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    arrivalTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        arrivalStation,
                        style: const TextStyle(
                          color: Color(0xFF8BA0B8),
                          fontSize: 11,
                        ),
                      ),
                      if (hasNextDay) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A3F5A),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '+1D',
                            style: TextStyle(
                              color: Color(0xFF8BA0B8),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Bottom row: amenities + book button
          Row(
            children: [
              ...amenities.map(
                (icon) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(icon, color: const Color(0xFF8BA0B8), size: 20),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed(AppRoutes.resultScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
