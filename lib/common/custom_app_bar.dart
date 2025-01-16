import 'package:endol/common/text_widget.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? refresh;
  final bool? isRefreshOn;

  const CustomAppBar({
    super.key,
    required this.title,
    this.refresh,
    this.isRefreshOn,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.cream,
      // centerTitle: true,
      title: TextWidget(
        text: title,
        color: AppColors.thatBrown,
        fontWeight: FontWeight.bold,
        size: 23,
      ),
      actions: [
        isRefreshOn == true
            ? IconButton(
                onPressed: () {
                  refresh?.call();
                },
                icon: Icon(
                  Icons.refresh,
                ),
              )
            : SizedBox(),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}
