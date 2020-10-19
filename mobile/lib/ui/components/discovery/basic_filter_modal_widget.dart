import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';
import '../common/button/black_button_widget.dart';
import '../common/circular_checkbox_widget.dart';
import '../common/loading_widget.dart';
import '../common/network_delay_widget.dart';

class BasicFilterModalWidget extends StatefulWidget {
  const BasicFilterModalWidget({
    this.productType,
    this.searchListBloc,
    this.searchFilterModel,
    this.changeStateFunction,
  });

  final String productType;
  final SearchFilterModel searchFilterModel;
  final SearchListBloc searchListBloc;

  @override
  BasicFilterModalWidgetState createState() => BasicFilterModalWidgetState();

  final Function(MoneyFilterModel, SortFilterModel) changeStateFunction;
}

class BasicFilterModalWidgetState extends State<BasicFilterModalWidget> {
  MoneyFilterModel moneyFilterModel;
  SortFilterModel sortFilterModel;

  @override
  void initState() {
    moneyFilterModel = widget.searchFilterModel.money;
    sortFilterModel = widget.searchFilterModel.sort;
    super.initState();
  }

  void changeMoneyFilterModel(MoneyFilterModel model) {
    setState(() {
      moneyFilterModel = model;
    });
  }

  void changeSortFilterModel(SortFilterModel model) {
    setState(() {
      sortFilterModel = model;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider<BasicSearchFilterBloc>(
        create: (context) {
          return BasicSearchFilterBloc(productType: widget.productType);
        },
        child: BasicFilterWidget(
          changeMoneyFilterModel: changeMoneyFilterModel,
          changeSortFilterModel: changeSortFilterModel,
          selectedSortTitle: sortFilterModel.name,
          selectedMoneyTitle: moneyFilterModel.name,
          productType: widget.productType,
          onPressed: () {
            widget.searchListBloc.search(
                orderBy: sortFilterModel.orderBy,
                priceRange: moneyFilterModel.priceRange);
            widget.changeStateFunction(
              moneyFilterModel,
              sortFilterModel,
            );
            Navigator.of(context).pop();
          },
        ));
  }
}

class BasicFilterWidget extends StatefulWidget {
  const BasicFilterWidget(
      {this.onPressed,
      this.changeMoneyFilterModel,
      this.changeSortFilterModel,
      this.selectedSortTitle,
      this.selectedMoneyTitle,
      // this.moneyFilterModel,
      this.productType});

  final Function changeMoneyFilterModel;
  final Function changeSortFilterModel;
  final Function onPressed;
  // MoneyFilterModel moneyFilterModel;
  final String productType;

  final String selectedMoneyTitle;
  final String selectedSortTitle;

  @override
  _BasicFilterWidgetState createState() => _BasicFilterWidgetState();
}

class _BasicFilterWidgetState extends State<BasicFilterWidget> {
  Widget _buildTitle(BuildContext context) {
    return Container(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            DiscoveryPageStrings.filter,
            style: TextStyles.black18BoldTextStyle,
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  widget.changeSortFilterModel(const SortFilterModel());
                  widget.changeMoneyFilterModel(const MoneyFilterModel());
                });
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Text(
                      DiscoveryPageStrings.reset,
                      style: TextStyles.grey14TextStyle,
                    ),
                    Icon(
                      Icons.refresh,
                      size: 16,
                      color: const Color(0xff909090),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildCheckBoxContainer(
    BuildContext context,
    String title,
    List list,
  ) {
    if (list.isEmpty) return Container();
    return Container(
      padding: const EdgeInsets.only(top: 26, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyles.black16BoldTextStyle,
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: list.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 150 / 21,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 20),
              itemBuilder: (context, index) {
                return _buildCheckBox(context, list[index], title);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckBox(BuildContext context, dynamic model, String title) {
    Function checkBoxOnChange;
    bool value;
    final label = model.label;
    ;
    if (title == DiscoveryPageStrings.sortFilter) {
      value = model.label == widget.selectedSortTitle;
      checkBoxOnChange = () {
        if (value == false) {
          widget.changeSortFilterModel(
              SortFilterModel(name: model.label, orderBy: model));
        } else {
          widget.changeSortFilterModel(const SortFilterModel());
        }
      };
    } else if (title == DiscoveryPageStrings.moneyFilter) {
      value = model.label == widget.selectedMoneyTitle;

      checkBoxOnChange = () {
        if (value == false) {
          widget.changeMoneyFilterModel(
              MoneyFilterModel(name: model.label, priceRange: model));
        } else {
          widget.changeMoneyFilterModel(const MoneyFilterModel());
        }
      };
    }

    return GestureDetector(
      onTap: checkBoxOnChange,
      child: Row(children: <Widget>[
        CircularCheckBoxWiget(
          isAgreed: value,
        ),
        Text(
          label,
          style: TextStyles.black14TextStyle,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BasicSearchFilterModel>(
        stream: Provider.of<BasicSearchFilterBloc>(context).basicFilter,
        builder: (context, snapshot) {
          print('hasError ${snapshot.hasError}');
          if (snapshot.hasError) {
            return NetworkDelayPage(
              retry: () {
                Provider.of<BasicSearchFilterBloc>(context)
                    .fetch(widget.productType);
              },
            );
          }
          if (!snapshot.hasData) {
            return const LoadingWidget();
          }

          return SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  _buildTitle(context),
                  Expanded(
                    child: Container(
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          _buildCheckBoxContainer(
                              context,
                              DiscoveryPageStrings.sortFilter,
                              snapshot.data.orderBy),
                          const Divider(),
                          _buildCheckBoxContainer(
                              context,
                              DiscoveryPageStrings.moneyFilter,
                              snapshot.data.priceRange),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: BlackButtonWidget(
                        title: CommonTexts.next, onPressed: widget.onPressed),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
