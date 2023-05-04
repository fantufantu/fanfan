import 'package:flutter/material.dart';

class ServiceEntry extends StatelessWidget {
  final double _radius = 30;

  const ServiceEntry({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final MaterialColor color;
  final IconData icon;
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.shade50,
              borderRadius: BorderRadius.circular(
                _radius,
              ),
            ),
            width: _radius * 2,
            height: _radius * 2,
            child: IconButton(
              onPressed: onPressed,
              color: color.shade300,
              icon: Icon(
                icon,
                size: 24,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 8,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
