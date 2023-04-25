import 'package:flutter/material.dart';

class Avatars extends StatelessWidget {
  double _size = 20;
  double _borderWidth = 3;
  int _limit = 3;

  List<String> _avatars = ['JACK', 'fanfan', 'tutu', '...'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size * (_limit + 2) + _borderWidth * 2,
      child: Stack(
        children: [
          ...(_avatars.asMap().entries.map(
                (item) => Positioned(
                  left: (item.key * _size) > 0 ? item.key * _size : null,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: _borderWidth,
                      ),
                      borderRadius: BorderRadius.circular(_size + _borderWidth),
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('images/user/preset.png'),
                      radius: _size,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
