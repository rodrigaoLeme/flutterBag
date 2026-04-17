import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../modules.dart' show VotingViewModel;
import '../voting_details_cell.dart';

class VotingStoriesPage extends StatefulWidget {
  final List<VotingViewModel> viewModels;
  final int initialIndex;

  const VotingStoriesPage({
    Key? key,
    required this.viewModels,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<VotingStoriesPage> createState() => _VotingStoriesPageState();
}

class _VotingStoriesPageState extends State<VotingStoriesPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  late List<double> _progresses;

  Timer? _timer;
  static const int _storyDurationMs = 5000;
  static const int _timerTickMs = 200;

  double _dragY = 0;
  late AnimationController _animationController;
  late Animation<double> _dragAnimation;

  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
    _progresses = List<double>.filled(widget.viewModels.length, 0);
    _startProgress();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _dragAnimation =
        Tween<double>(begin: 0, end: 0).animate(_animationController)
          ..addListener(() {
            setState(() {
              _dragY = _dragAnimation.value;
            });
          });
  }

  void _startProgress() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(milliseconds: _timerTickMs),
      (timer) {
        setState(() {
          _progresses[_currentIndex] += _timerTickMs / _storyDurationMs;
          if (_progresses[_currentIndex] >= 1) {
            _progresses[_currentIndex] = 1;
            if (_currentIndex < widget.viewModels.length - 1) {
              _goToNextPage();
            } else {
              _timer?.cancel();
              Navigator.pop(context);
            }
          }
        });
      },
    );
  }

  void _goToNextPage() {
    if (_currentIndex < widget.viewModels.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleVerticalEnd() {
    if (_dragY > 120) {
      _isClosing = true;
      _timer?.cancel();
      Navigator.pop(context);
    } else {
      _animationController.reset();
      _dragAnimation =
          Tween<double>(begin: _dragY, end: 0).animate(_animationController);
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _pauseProgress() {
    _timer?.cancel();
  }

  void _resumeProgress() {
    _startProgress();
  }

  @override
  Widget build(BuildContext context) {
    double opacity = (1 - (_dragY / 300)).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (_isClosing) return;
            setState(() {
              _dragY += details.delta.dy;
            });
          },
          onVerticalDragEnd: (_) {
            if (_isClosing) return;
            _handleVerticalEnd();
          },
          child: Transform.translate(
            offset: Offset(0, _dragY),
            child: Opacity(
              opacity: opacity,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.viewModels.length,
                    onPageChanged: (index) {
                      setState(() {
                        if (index < _currentIndex) {
                          _progresses[_currentIndex] = 0;
                        } else if (_progresses[_currentIndex] < 1) {
                          _progresses[_currentIndex] = 1;
                        }
                        _currentIndex = index;
                        if (_progresses[_currentIndex] >= 1) {
                          _progresses[_currentIndex] = 0;
                        }
                        _startProgress();
                      });
                    },
                    itemBuilder: (context, index) {
                      final viewModel = widget.viewModels[index];
                      return Stack(
                        children: [
                          VotingDetailsCell(
                            viewModel: viewModel,
                            onClose: () {
                              _timer?.cancel();
                              Navigator.pop(context);
                            },
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTapUp: (details) {
                              final width = MediaQuery.of(context).size.width;
                              if (details.localPosition.dx < width / 2) {
                                _goToPreviousPage();
                              } else {
                                _goToNextPage();
                              }
                            },
                            onLongPressStart: (_) {
                              _pauseProgress();
                            },
                            onLongPressEnd: (_) {
                              _resumeProgress();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  Positioned(
                    top: 36,
                    left: 16,
                    right: 16,
                    child: Row(
                      children:
                          List.generate(widget.viewModels.length, (index) {
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _progresses[index],
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        _timer?.cancel();
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
