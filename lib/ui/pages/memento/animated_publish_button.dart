import 'package:flutter/material.dart';

class AnimatedProgressPublishButton extends StatefulWidget {
  final double progress;
  final VoidCallback? onPressed;

  const AnimatedProgressPublishButton({
    Key? key,
    required this.progress,
    this.onPressed,
  }) : super(key: key);

  @override
  _AnimatedProgressPublishButtonState createState() => _AnimatedProgressPublishButtonState();
}

class _AnimatedProgressPublishButtonState extends State<AnimatedProgressPublishButton> {
  @override
  Widget build(BuildContext context) {
    // Determine if upload is complete
    bool isComplete = widget.progress >= 1.0;

    return SizedBox(
      width: double.infinity, // Ensure the button takes the full width available
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isComplete ? Colors.green : Colors.grey,
          disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12), // Button color when disabled
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.zero, // Ensure no padding is affecting the layout
        ),
        onPressed: isComplete ? widget.onPressed : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (!isComplete)
              LinearProgressIndicator(
                value: widget.progress, // Bind to the upload progress
                backgroundColor: Colors.grey.shade400, // Light grey background color
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade400),
                minHeight: 48, // Set the height of the progress bar
              ),
            Text(
              isComplete ? "Publish" : "Uploading...",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
