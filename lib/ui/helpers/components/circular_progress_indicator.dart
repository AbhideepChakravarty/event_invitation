
import 'package:flutter/material.dart';

class AdaptiveCircularProgressIndicator extends StatelessWidget {
  final String? labelText;
  final Color? color;

  const AdaptiveCircularProgressIndicator({
    Key? key,
    this.labelText,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final color = this.color ?? Theme.of(context).colorScheme.secondary;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: isIOS ? 20 : 36,
          width: isIOS ? 20 : 36,
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        if (labelText != null) ...[
          const SizedBox(height: 8),
          Text(
            labelText!,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
