import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnswer extends StatefulWidget {
  final String assetPath;
  final String answer;
  final String description;
  final double height;
  final Function(String)? onAnswered;

  const LottieAnswer(
      {super.key,
      required this.assetPath,
      required this.height,
      this.onAnswered,
      required this.description,
      required this.answer});

  @override
  State<LottieAnswer> createState() => _LottieAnswerState();
}

class _LottieAnswerState extends State<LottieAnswer>
    with TickerProviderStateMixin {
  bool isChoosen = false;
  late AnimationController _controller;
  static const boxHeight = 120.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChoosen = !isChoosen;
          if (isChoosen) {
            _controller.repeat();
          } else {
            _controller.stop();
          }
          widget.onAnswered?.call(widget.answer);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isChoosen
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.transparent,
          border: Border.all(
              width: 3,
              color: isChoosen
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(20),
        ),
        width: double.infinity,
        height: boxHeight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 8, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: Lottie.asset(
                  widget.assetPath,
                  controller: _controller,
                  width: double.infinity,
                  height: widget.height,
                  onLoaded: (composition) {
                    _controller.duration = composition.duration;
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.answer,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 4),
                    SizedBox(
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(widget.description,
                            maxLines: null,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: 10,
                                color: isChoosen
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onPrimaryFixed
                                    : Theme.of(context).colorScheme.outline)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
