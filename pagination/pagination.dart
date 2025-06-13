import 'dart:math';

import 'package:flutter/material.dart';
import 'package:number_pagination/number_pagination.dart';

class CustomPaginator extends StatefulWidget {
  const CustomPaginator({
    super.key,
    required this.initialPage,
    required this.totalPages,
    required this.pageSizeOptions, // List of page size: [3, 6, 9, 12]
    required this.onPaginationChanged, // calls api when page size changes
  });
  final int initialPage;
  final int totalPages;
  final List<int> pageSizeOptions;
  final Function(int, int) onPaginationChanged;

  @override
  State<CustomPaginator> createState() => _CustomPaginatorState();
}

class _CustomPaginatorState extends State<CustomPaginator> {
  late int _pageSize;
  late int currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
    _pageSize =
        widget.pageSizeOptions.isNotEmpty ? widget.pageSizeOptions.first : 3;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.pageSizeOptions.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Page size: '),
              DropdownButton<int>(
                value: _pageSize,
                items: widget.pageSizeOptions
                    .map(
                      (size) => DropdownMenuItem(
                        value: size,
                        child: Text('$size'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _pageSize = value;
                      currentPage = 1;
                      widget.onPaginationChanged(currentPage, _pageSize);
                    });
                  }
                },
              ),
            ],
          ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: NumberPagination(
            onPageChanged: (int index) {
              setState(() {
                currentPage = index; 
                widget.onPaginationChanged(currentPage, _pageSize);
              });
            },
            buttonElevation: 2,
            totalPages: max(widget.totalPages, 3),
            currentPage: currentPage,
            visiblePagesCount: 3,
            buttonRadius: BouncingScrollSimulation.maxSpringTransferVelocity,
          ),
        ),
      ],
    );
  }
}
