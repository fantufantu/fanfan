import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (context, index) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6, bottom: 6),
                      child: CircleAvatar(
                        child: Text("data"),
                        radius: 22,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Good morning 👋🏻"),
                          Text("Murukal Hu",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              )),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Text("1"),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 20),
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    boxShadow: kElevationToShadow[3],
                    borderRadius: BorderRadius.all(Radius.circular(24))),
              );
            },
          ),
        ),
      ],
    );

    // return Center(
    //   child: Column(
    //     children: <Widget>[

    //     ],
    //   ),
    // );
  }
}
