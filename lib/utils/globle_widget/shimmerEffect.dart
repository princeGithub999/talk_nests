import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';

class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({super.key});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect> {
  @override
  Widget build(BuildContext context) {
    var isDark = AppHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: isDark ? Colors.white24 : Colors.grey.shade300,
          highlightColor: isDark ? Colors.white24 : Colors.grey.shade100,
          enabled: true,
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      maxRadius: 25,
                    ),
                    const SizedBox(width: 16.0),
                    // Text Placeholder
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 16.0,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 16.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
