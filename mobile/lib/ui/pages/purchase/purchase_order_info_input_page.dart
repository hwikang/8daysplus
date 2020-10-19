import 'dart:ui';

import 'package:core/core.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mobile/utils/handle_network_error.dart';
import 'package:provider/provider.dart';

import '../../../utils/assets.dart';
import '../../../utils/routes.dart';
import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';
import '../../../utils/validator.dart';
import '../../components/common/button/black_button_widget.dart';
import '../../components/common/circular_checkbox_widget.dart';
import '../../components/common/header_title_widget.dart';
import '../../components/common/loading_widget.dart';
import '../../components/common/text_form_field_widget.dart';
import 'purchase_order_input_fields.dart';
import 'purchase_order_input_options.dart';

class PurchaseOrderInfoInputPage extends StatelessWidget {
  const PurchaseOrderInfoInputPage({
    @required this.orderInfoData,
  });
  final CreateOrderInputModel orderInfoData;
  // final List<OrderInfoProductModel> orderList;

  @override
  Widget build(BuildContext context) {
    return Provider<CreateOrderPrepareBloc>(
        create: (context) => CreateOrderPrepareBloc(
              inputModel: orderInfoData,
            ),
        child: PurchaseOrderInfoInputWidget(
          inputItem: orderInfoData,
        ));
  }
}

// class PurchaseOrderInfoInputModule extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<CreateOrderInputModel>(
//         stream: Provider.of<OrderInfoRequestBloc>(context).repoData,
//         builder: (context, repoSnapshot) {
//           if (!repoSnapshot.hasData) {
//             return const LoadingWidget();
//           }

//           return Provider<CreateOrderPrepareBloc>(
//               create: (context) => CreateOrderPrepareBloc(
//                     inputModel: repoSnapshot.data,
//                   ),
//               child: PurchaseOrderInfoInputWidget(
//                 inputItem: repoSnapshot.data,
//               ));
//         });
//   }
// }

class PurchaseOrderInfoInputWidget extends StatefulWidget {
  const PurchaseOrderInfoInputWidget({
    @required this.inputItem,
  });

  final CreateOrderInputModel inputItem;

  @override
  _PurchaseOrderInfoInputWidgetState createState() =>
      _PurchaseOrderInfoInputWidgetState();
}

class _PurchaseOrderInfoInputWidgetState
    extends State<PurchaseOrderInfoInputWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            AppRoutes.pop(context);
          },
        ),
        title: const HeaderTitleWidget(title: '사용자 정보'),
      ),
      bottomNavigationBar: _buildButton(context),
      body: SingleChildScrollView(
        // reverse: true,
        child: GestureDetector(
          onTap: () {
            SystemChannels.textInput.invokeMethod<dynamic>('TextInput.hide');
          },
          child: Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                    left: 24,
                    top: 24,
                  ),
                  child: Text('예약자 정보', style: TextStyles.black20BoldTextStyle),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        PurchaseOrderInputFields(
                          inputItem: widget.inputItem,
                        ),
                        PurchaseOrderInputOptions(inputItem: widget.inputItem),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
        child: BlackButtonWidget(
          title: CommonTexts.next,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              final createOrderPrepareBloc =
                  Provider.of<CreateOrderPrepareBloc>(context);

              _formKey.currentState.save();

              createOrderPrepareBloc.createOrderPrepare().then((data) {
                AppRoutes.paymentPage(context, data);
              }).catchError((dynamic error) {
                HandleNetworkError.showErrorDialog(context, error);
              });
            } else {
              getLogger(this).w('not validate');
            }
          },
        ),
      ),
    );
  }
}

class MakeSelectOptions extends StatefulWidget {
  const MakeSelectOptions({this.field, this.inputWhere});

  final OrderInfoFieldModel field;
  final OrderInfoFieldModel inputWhere;

  @override
  _MakeSelectOptionsState createState() => _MakeSelectOptionsState();
}

class _MakeSelectOptionsState extends State<MakeSelectOptions> {
  String selectedOption;

  @override
  Widget build(BuildContext context) {
    widget.inputWhere.fieldValue = selectedOption;
    widget.inputWhere.fieldId = widget.field.fieldId;
    final typeList = widget.field.fieldOption.split(',');

    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.field.fieldName,
                style: TextStyles.grey14TextStyle,
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 44,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xffe0e0e0), width: 1),
                    borderRadius: BorderRadius.circular(4)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      hint: const Text('select'),
                      value: selectedOption,
                      isExpanded: true,
                      isDense: true,
                      // value: initValue,
                      onChanged: (newValue) {
                        setState(() {
                          selectedOption = newValue;
                        });
                        widget.inputWhere.fieldValue = newValue;
                        widget.inputWhere.fieldId = widget.field.fieldId;
                      },
                      items: typeList.map<DropdownMenuItem<String>>((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyles.black16TextStyle,
                          ),
                        );
                      }).toList()),
                ))
          ]),
    );
  }
}

class MakeTimeOptions extends StatefulWidget {
  const MakeTimeOptions({this.field, this.inputWhere});

  final OrderInfoFieldModel field;
  final OrderInfoFieldModel inputWhere;

  @override
  _MakeTimeOptionsState createState() => _MakeTimeOptionsState();
}

class _MakeTimeOptionsState extends State<MakeTimeOptions> {
  String selectedOption;

  @override
  Widget build(BuildContext context) {
    widget.inputWhere.fieldValue = selectedOption;
    widget.inputWhere.fieldId = widget.field.fieldId;
    final typeList = <String>[
      '00:00',
      '01:00',
      '02:00',
      '03:00',
      '04:00',
      '05:00',
      '06:00',
      '07:00',
      '08:00',
      '09:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00',
      '19:00',
      '20:00',
      '21:00',
      '22:00',
      '23:00'
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.field.fieldName,
                style: TextStyles.grey14TextStyle,
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 44,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xffe0e0e0), width: 1),
                    borderRadius: BorderRadius.circular(4)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      hint: const Text('select'),
                      value: selectedOption,
                      isExpanded: true,
                      isDense: true,
                      // value: initValue,
                      onChanged: (newValue) {
                        setState(() {
                          selectedOption = newValue;
                        });
                        widget.inputWhere.fieldValue = newValue;
                        widget.inputWhere.fieldId = widget.field.fieldId;
                      },
                      items: typeList.map<DropdownMenuItem<String>>((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyles.black16TextStyle,
                          ),
                        );
                      }).toList()),
                ))
          ]),
    );
  }
}

class MakeMobileOption extends StatefulWidget {
  const MakeMobileOption({this.field, this.inputWhere, this.keyboardType});

  final OrderInfoFieldModel field;
  final OrderInfoFieldModel inputWhere;
  final TextInputType keyboardType;

  @override
  _MakeMobileOptionState createState() => _MakeMobileOptionState();
}

class _MakeMobileOptionState extends State<MakeMobileOption> {
  String countryCode;
  String phone;

  @override
  void initState() {
    super.initState();
    countryCode = '+82';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              // tModel.fieldName,
              widget.field.fieldName,
              style: TextStyles.grey14TextStyle,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 44,
            // width: 312 * DeviceRatio.scaleWidth(context),
            padding: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffe0e0e0), width: 1),
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CountryCodePicker(
                    searchDecoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffe0e0e0),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                      // prefixIcon: Icon(Icons.accessibility)
                    ),
                    onChanged: (code) {
                      setState(() {
                        countryCode = code.toString();
                      });
                    },

                    initialSelection: 'KR',
                    // favorite: ['+39', 'FR'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: true,
                    alignLeft: true,
                  ),
                ),
                Image.asset(
                  ImageAssets.arrowDownImage,
                  width: 12,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormFieldWidget(
            hintText: "' - ' 없이 입력(예시:1000000000)",
            validator: FieldValidator.validateMobile,
            onSaved: (text) {
              if (widget.inputWhere != null) {
                countryCode ??= '+82';

                widget.inputWhere.fieldValue = '$countryCode-$text';
                widget.inputWhere.fieldId = widget.field.fieldId;
              }
            },
            keyboardType: TextInputType.number,
          ),
          if (widget.field.fieldExplain == '')
            Text(
              widget.field.fieldExplain,
              style: TextStyles.grey12TextStyle,
            ),
        ],
      ),
    );
  }
}

class MakeTextOption extends StatefulWidget {
  const MakeTextOption({
    this.field,
    this.keyboardType,
    this.inputWhere,
    this.isOption = false,
    this.initValue,
  });

  final OrderInfoFieldModel field;
  final String initValue;
  final OrderInfoFieldModel inputWhere;
  final bool isOption;
  final TextInputType keyboardType;

  @override
  _MakeTextOptionState createState() => _MakeTextOptionState();
}

class _MakeTextOptionState extends State<MakeTextOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              // tModel.fieldName,
              widget.field.fieldName,
              style: TextStyles.grey14TextStyle,
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              child: TextFormFieldWidget(
                initialValue: widget.initValue,
                validator: (text) {
                  if (widget.field.fieldType == 'number') {
                    return null;
                  }
                  if (!widget.field.isRequired) {
                    return null;
                  }

                  if (widget.field.fieldType == 'email') {
                    return FieldValidator.validateEmail(text);
                  }

                  return text.isEmpty ? '입력해주세요' : null;
                },
                onSaved: (text) {
                  if (widget.inputWhere != null) {
                    widget.inputWhere.fieldValue =
                        text; //inputWhere 에는 inputMap에 할당할 위치를 알려준다.
                    widget.inputWhere.fieldId = widget.field.fieldId;
                  }
                },
                keyboardType: widget.keyboardType,
                hintText: widget.field.fieldPlaceholder,
              )),
          if (widget.field.fieldExplain == '')
            Text(
              widget.field.fieldExplain,
              style: TextStyles.grey12TextStyle,
            ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}

class MakeRadioOptions extends StatefulWidget {
  const MakeRadioOptions({this.field, this.inputWhere});

  final OrderInfoFieldModel field;
  final OrderInfoFieldModel inputWhere;

  @override
  _RadioState createState() => _RadioState();
}

class _RadioState extends State<MakeRadioOptions> {
  String _currentValue = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final fieldOptionArr = widget.field.fieldOption.split(',');
    _currentValue = fieldOptionArr[0];
  }

  List<Widget> buildMakeRadioOption(
      BuildContext context, OrderInfoFieldModel orderInfoFieldModel) {
    final list = <Widget>[];
    final fieldOptionArr = orderInfoFieldModel.fieldOption.split(',');
    for (var j = 0; j < fieldOptionArr.length; j++) {
      list.add(
        Row(
          children: <Widget>[
            Container(
              width: 20,
              margin: const EdgeInsets.only(right: 10),
              child: Radio<String>(
                groupValue: _currentValue ?? fieldOptionArr[0], //아직선택 x -> 첫번째
                onChanged: (data) {
                  setState(() {
                    _currentValue = data;
                  });
                  widget.inputWhere.fieldValue = data;
                  widget.inputWhere.fieldId = orderInfoFieldModel.fieldId;
                },
                value: fieldOptionArr[j],
              ),
            ),
            Text(
              fieldOptionArr[j],
            ),
          ],
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    widget.inputWhere.fieldValue = _currentValue;
    widget.inputWhere.fieldId = widget.field.fieldId;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
                // tModel.fieldName,
                widget.field.fieldName,
                style: TextStyles.grey14TextStyle),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildMakeRadioOption(context, widget.field),
          ),
        ],
      ),
    );
  }
}

class MakeCheckOptions extends StatefulWidget {
  const MakeCheckOptions({
    this.field,
    this.inputWhere,
  });

  final OrderInfoFieldModel field;
  final OrderInfoFieldModel inputWhere;

  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<MakeCheckOptions> {
  // int checkedIndex;
  String _currentValue;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final fieldOptionArr = widget.field.fieldOption.split(',');

    // checkedIndex = 0;
    _currentValue = fieldOptionArr[0];
  }

  @override
  Widget build(BuildContext context) {
    final fieldOptionArr = widget.field.fieldOption.split(',');
    widget.inputWhere.fieldValue = _currentValue;
    widget.inputWhere.fieldId = widget.field.fieldId;

    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text(
                  // tModel.fieldName,
                  widget.field.fieldName,
                  style: TextStyles.grey14TextStyle),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 14),
              child: ListView.builder(
                itemCount: fieldOptionArr.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(top: index == 0 ? 0 : 14),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_currentValue == fieldOptionArr[index]) {
                            _currentValue = '';
                          } else {
                            _currentValue = fieldOptionArr[index];
                          }
                          widget.inputWhere.fieldValue = _currentValue;
                          widget.inputWhere.fieldId = widget.field.fieldId;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          CircularCheckBoxWiget(
                            isAgreed: _currentValue == fieldOptionArr[index],
                          ),
                          Text(
                            fieldOptionArr[0],
                            style: TextStyles.black14TextStyle,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}

//type - engname
class MakeEnglishNameOptions extends StatefulWidget {
  const MakeEnglishNameOptions({
    this.field,
    this.inputWhere,
  });

  final OrderInfoFieldModel field;
  final dynamic inputWhere;

  @override
  _MakeEnglishNameOptionsState createState() => _MakeEnglishNameOptionsState();
}

class _MakeEnglishNameOptionsState extends State<MakeEnglishNameOptions> {
  @override
  Widget build(BuildContext context) {
    final placeHolders = widget.field.fieldPlaceholder.split(',');

    String firstName;
    String lastName;
    return Container(
        margin: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                widget.field.fieldName,
                style: TextStyles.grey14TextStyle,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 8),
                child: TextFormFieldWidget(
                  // keyboardType: TextInputType.text,
                  hintText: placeHolders[0],
                  validator: (text) {
                    final engNamePattern =
                        RegExp(r'^[a-zA-Z\s]+$'); //only english
                    if (!engNamePattern.hasMatch(text)) {
                      return '한글 및 특수문자는 사용 할 수 없습니다.';
                    }
                    if (text.length <= 1) {
                      return '이름은 2~7자리만 입력 가능합니다.';
                    }
                    return null;
                  },
                  onSaved: (text) {
                    setState(() {
                      firstName = text;
                    });
                  },
                )),
            Container(
                margin: const EdgeInsets.only(top: 8),
                child: TextFormFieldWidget(
                  hintText: placeHolders[1],
                  validator: (text) {
                    final engNamePattern =
                        RegExp(r'^[a-zA-Z\s]+$'); //only english
                    if (!engNamePattern.hasMatch(text)) {
                      return '한글 및 특수문자는 사용 할 수 없습니��.';
                    }
                    if (text.length <= 1) {
                      return '이름은 2~7자리만 입력 가능��니다.';
                    }
                    return null;
                  },
                  onSaved: (text) {
                    setState(() {
                      lastName = text;
                    });

                    if (widget.inputWhere != null) {
                      //inputWhere 에는 inputMap에 할당할 위치를 알려준다.
                      widget.inputWhere.fieldValue = '$firstName $lastName';
                      widget.inputWhere.fieldId = widget.field.fieldId;

                      // print(createOrderPrepareBloc.inputModel);

                    }
                  },
                  onChanged: (data) {},
                )),
          ],
        ));
  }
}

class MakeBirthDayOptions extends StatefulWidget {
  const MakeBirthDayOptions({this.field, this.inputWhere});

  final OrderInfoFieldModel field;
  final OrderInfoFieldModel inputWhere;

  @override
  _MakeBirthDayOptionsState createState() => _MakeBirthDayOptionsState();
}

class _MakeBirthDayOptionsState extends State<MakeBirthDayOptions> {
  int dayValue;
  int monthValue;
  int yearValue;

  @override
  void initState() {
    super.initState();
    yearValue = 1990;
    monthValue = 1;
    dayValue = 1;
  }

  @override
  Widget build(BuildContext context) {
    widget.inputWhere.fieldValue = '$yearValue-$monthValue-$dayValue';
    widget.inputWhere.fieldId = widget.field.fieldId;
    // final CreateOrderPrepareBloc createOrderPrepareBloc =
    //     Provider.of<CreateOrderPrepareBloc>(context);

    final years = <int>[];
    final months = <int>[];
    final days = <int>[];
    for (var i = 1; i < 13; i++) {
      months.add(i);
    }
    for (var i = 1; i < 32; i++) {
      days.add(i);
    }
    final date = DateTime.now();
    for (var i = 1950; i < date.year + 1; i++) {
      years.add(i);
    }

    return Container(
        margin: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                widget.field.fieldName,
                style: TextStyles.grey14TextStyle,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xffe0e0e0), width: 1),
                                borderRadius: BorderRadius.circular(4)),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                    onChanged: (newValue) {
                                      setState(() {
                                        yearValue = newValue;
                                      });
                                      widget.inputWhere.fieldValue =
                                          '$yearValue-$monthValue-$dayValue';
                                      widget.inputWhere.fieldId =
                                          widget.field.fieldId;
                                    },
                                    value: yearValue,
                                    items: years.map((year) {
                                      return DropdownMenuItem<int>(
                                        value: year,
                                        child: Container(
                                          child: Text(
                                            '$year년',
                                            style: TextStyles.black14TextStyle,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    icon: Image.asset(
                                      ImageAssets.arrowDownImage,
                                      width: 12,
                                    ))),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xffe0e0e0), width: 1),
                                borderRadius: BorderRadius.circular(4)),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                    onChanged: (newValue) {
                                      setState(() {
                                        monthValue = newValue;
                                      });
                                      widget.inputWhere.fieldValue =
                                          '$yearValue-$monthValue-$dayValue';
                                      widget.inputWhere.fieldId =
                                          widget.field.fieldId;
                                    },
                                    value: monthValue,
                                    items: months.map((month) {
                                      return DropdownMenuItem<int>(
                                        value: month,
                                        child: Text(
                                          '$month 월',
                                          style: TextStyles.black14TextStyle,
                                        ),
                                      );
                                    }).toList(),
                                    icon: Image.asset(
                                      ImageAssets.arrowDownImage,
                                      width: 12,
                                    ))),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xffe0e0e0), width: 1),
                                borderRadius: BorderRadius.circular(4)),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                    onChanged: (newValue) {
                                      setState(() {
                                        dayValue = newValue;
                                      });
                                      widget.inputWhere.fieldValue =
                                          '$yearValue-$monthValue-$dayValue';
                                      widget.inputWhere.fieldId =
                                          widget.field.fieldId;
                                    },
                                    value: dayValue,
                                    items: days.map((day) {
                                      return DropdownMenuItem<int>(
                                        value: day,
                                        child: Text(
                                          '$day 일',
                                          style: TextStyles.black14TextStyle,
                                        ),
                                      );
                                    }).toList(),
                                    icon: Image.asset(
                                      ImageAssets.arrowDownImage,
                                      width: 12,
                                    ))),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(widget.field.fieldPlaceholder,
                        style: TextStyles.grey12TextStyle)
                  ],
                )),
          ],
        ));
  }
}
