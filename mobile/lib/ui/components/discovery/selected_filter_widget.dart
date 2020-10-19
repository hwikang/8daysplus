import 'package:flutter/material.dart';

import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';

class SelectedFilterWidget extends StatelessWidget {
  const SelectedFilterWidget({
    this.sortName,
    this.moneyName,
    this.onTapMoneyFilter,
    this.onTapSortFilter,
  });

  final String sortName;
  final String moneyName;
  final Function onTapSortFilter;
  final Function onTapMoneyFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Row(children: [
        if (sortName != '')
          _buildSelectedContainer(
            context: context,
            text: sortName,
            type: 'sort',
          ),
        if (moneyName != '')
          _buildSelectedContainer(
            context: context,
            text: moneyName,
            type: 'money',
          ),
      ]),
    );
  }

  Widget _buildSelectedContainer({
    BuildContext context,
    String text,
    String type,
  }) {
    return Container(
      height: 24,
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffe0e0e0), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              type == 'money' ? '${DiscoveryPageStrings.money}: $text' : text,
              style: TextStyles.cyan12TextStyle,
            ),
            GestureDetector(
                child: Icon(
                  Icons.clear,
                  size: 16.0,
                  color: Colors.grey,
                ),
                onTap: () {
                  switch (type) {
                    case 'money':
                      onTapMoneyFilter();

                      break;
                    case 'sort':
                      onTapSortFilter();

                      break;
                  }
                })
          ],
        ),
      ),
    );
  }
}
