import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '/core/color_manager.dart';
import '/core/assets_manager.dart';
import '/core/const_value_manager.dart';
import '/widgets/trapzoid_widget.dart';
import '/widgets/lampader_color_widget.dart';
import '/widgets/quarter_circular_slider_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  double _opacityValue = 0.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Lottie.asset(
            AssetsManager.backgroundIMG,
            width: double.maxFinite,
            height: double.maxFinite,
            fit: BoxFit.cover,
          ),

          PositionedDirectional(
            end: 0,
            top: -30,
            child: Transform.rotate(
              angle: 0.2,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  PositionedDirectional(
                    top: size.height / 2.74,
                    child: TrapezoidWidget(
                      width: size.width / 1.5,
                      height: size.width / 1.7,
                      topWidth: size.width / 2.3,
                      gradient: LinearGradient(
                        colors: [
                          ColorManager.colors[_currentIndex]
                              .withOpacity(_opacityValue),
                          ColorManager.colors[_currentIndex]
                              .withOpacity(_opacityValue),
                          Colors.white.withOpacity(_opacityValue)
                        ],
                        stops: const [0.0, 0.3, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Image.asset(
                    AssetsManager.lampaderIMG,
                    width: size.width / 1.5,
                    height: size.height / 2.5,
                  ),

                ],
              ),
            ),
          ),

          ListView.separated(
            padding: const EdgeInsets.symmetric(
                horizontal: ConstValueManager.spaceColorWidget),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  child: LampaderColorWidget(
                    isSelected: _currentIndex == index,
                    color: ColorManager.colors[index],
                  ),
                ),
              ],
            ),
            separatorBuilder: (_, __) => const SizedBox(
              width: ConstValueManager.spaceColorWidget,
            ),
            itemCount: ColorManager.colors.length,
          ),

          PositionedDirectional(
            start: -78,
            top: size.height / 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'HIGH',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                QuarterCircularSliderWidget(
                  trackColor: _opacityValue < .1
                      ? ColorManager.gray
                      : ColorManager.colors[_currentIndex]
                          .withOpacity(_opacityValue),
                  size: size.width * 0.4,
                  trackWidth: 30,
                  thumbSize: 30,
                  onChange: (value) {
                    setState(() {
                      _opacityValue = value;
                    });
                  },
                ),
                Text(
                  'LOW',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),

          Positioned(
            bottom: size.height / 4,
            right: 0,
            left: 0,
            child: const Text(
              'Choose Color',
              textAlign: TextAlign.center,
            ),
          ),

        ],
      ),
    );
  }
}
