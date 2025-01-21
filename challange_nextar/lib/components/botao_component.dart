import 'package:flutter/material.dart';

class BotaoPadrao extends StatefulWidget {
  final String nomeBotao;
  final Color cor;
  final Color? corOutlined;
  final Function()? onPressed;
  final TextStyle? styleText;
  final Size? minimumSize;
  final double fontsize;
  final Widget? child;
  final Widget? style;
  final BorderSide? side;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry? padding;

  const BotaoPadrao({
    super.key,
    required this.nomeBotao,
    required this.cor,
    this.corOutlined,
    this.minimumSize,
    this.side,
    this.borderRadius = BorderRadius.zero,
    this.padding,
    this.style,
    this.child,
    this.fontsize = 16,
    required this.onPressed,
    this.styleText,
  });

  @override
  State<BotaoPadrao> createState() => _BotaoPadraoState();
}

final loading = ValueNotifier<bool>(false);

class _BotaoPadraoState extends State<BotaoPadrao> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: widget.minimumSize,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius,
        ),
        backgroundColor: widget.cor,
        padding: widget.padding,
      ),
      child: AnimatedBuilder(
        animation: loading,
        builder: (context, child) {
          return widget.onPressed != null
              ? Text(
                  widget.nomeBotao,
                  style: widget.styleText,
                )
              : const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
