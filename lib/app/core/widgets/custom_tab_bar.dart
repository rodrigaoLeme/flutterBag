import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final List<CustomTab> tabs;
  final TabController tabController;
  const CustomTabBar(
      {Key? key, required this.tabController, required this.tabs})
      : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late ColorTween tween;

  @override
  void initState() {
    tabController = widget.tabController;
    tabs = widget.tabs;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomTabBar oldWidget) {
    if (oldWidget.tabController != widget.tabController) {
      tabController = widget.tabController;
    }
    if (oldWidget.tabs != widget.tabs) {
      tabs = widget.tabs;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    tween = ColorTween(
        begin: Colors.white, end: Theme.of(context).colorScheme.primary);
    super.didChangeDependencies();
  }

  late TabController tabController;
  late List<CustomTab> tabs;

  List<Widget> populateTabs() {
    final tabsWidget = <Widget>[];
    for (int i = 0; i < tabs.length; i++) {
      final tabOnTapFunction = tabs[i].onTap;
      final List<Widget> onTapWidgets = tabOnTapFunction != null
          ? const [SizedBox(width: 2), Icon(Icons.arrow_drop_down)]
          : const [];
      tabsWidget.add(
        Tab(
          iconMargin: EdgeInsets.zero,
          child: AnimatedDefaultTextStyle(
            style: TextStyle(
              color: () {
                final result = tween.lerp(i -
                    (i == 1
                        ? tabController.animation!.value
                        : tabController.animation!.value * -1));
                return result;
              }(),
              fontSize: 16,
            ),
            duration: const Duration(milliseconds: 100),
            child: GestureDetector(
              onTap: tabOnTapFunction,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tabs[i].label,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  ...onTapWidgets
                ],
              ),
            ),
          ),
        ),
      );
    }
    return tabsWidget;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(24);
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 264,
        child: Material(
          color: const Color(0xFFF1FAFF),
          borderRadius: borderRadius,
          child: AnimatedBuilder(
            animation: tabController.animation!,
            builder: (context, child) => TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                borderRadius: borderRadius,
                color: primaryColor,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 0,
              splashBorderRadius: borderRadius,
              overlayColor: WidgetStateProperty.all(Colors.blue[200]),
              dividerColor: Colors.transparent,
              tabs: populateTabs(),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTab {
  final String label;
  final VoidCallback? onTap;

  const CustomTab(this.label, {this.onTap});
}
