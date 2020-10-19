import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/routes.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/button/black_button_widget.dart';
import '../../components/common/dialog_widget.dart';
import '../../components/common/header_title_widget.dart';
import '../../components/common/loading_widget.dart';
import '../../modules/common/handle_network_module.dart';

class InquiryCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<InquiryCreateBloc>(
      create: (context) => InquiryCreateBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              AppRoutes.pop(context);
            },
          ),
          title: const HeaderTitleWidget(title: '문의하기'),
        ),
        body: InquiryCreateModule(),
      ),
    );
  }
}

class InquiryCreateModule extends StatefulWidget {
  @override
  _InquiryCreateModuleState createState() => _InquiryCreateModuleState();
}

class _InquiryCreateModuleState extends State<InquiryCreateModule> {
  final TextEditingController textController = TextEditingController();

  Widget _buildDropDown(BuildContext context, List<InquiryTypeModel> typeList) {
    final inquryCreateBloc = Provider.of<InquiryCreateBloc>(context);

    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffeeeeee)))),
      child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 44,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffe0e0e0), width: 1),
              borderRadius: BorderRadius.circular(4)),
          child: StreamBuilder<InquiryTypeModel>(
              stream: Provider.of<InquiryCreateBloc>(context).selectedType,
              builder: (context, selectedTypeSnapshot) {
                String seletedTypeName;
                if (selectedTypeSnapshot.hasData) {
                  seletedTypeName = selectedTypeSnapshot.data.name;
                }
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      hint: Text(seletedTypeName ?? '문의 유형을 선택해 주세요'),
                      isExpanded: true,
                      isDense: true,
                      // value: initValue,
                      onChanged: (newValue) {
                        final selectedType = typeList
                            .where((type) => type.name == newValue)
                            .toList();
                        inquryCreateBloc.changeSelectedType(selectedType[0]);
                      },
                      items: typeList.map<DropdownMenuItem<String>>((type) {
                        print(type.name);
                        return DropdownMenuItem<String>(
                          value: type.name,
                          child: Text(
                            type.name,
                            style: TextStyles.black16TextStyle,
                          ),
                        );
                      }).toList()),
                );
              })),
    );
  }

  Widget _buildSubmitContainer(BuildContext context) {
    final inquryCreateBloc = Provider.of<InquiryCreateBloc>(context);

    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: BlackButtonWidget(
          title: '문의 등록',
          onPressed: () {
            //type select
            if (inquryCreateBloc.selectedType.hasValue) {
              if (textController.text.isNotEmpty) {
                print('can submit');
                inquryCreateBloc
                    .createInquiry(InquiryCreateModel(
                        message: textController.text,
                        type: inquryCreateBloc.selectedType.value.type))
                    .then((data) {
                  if (data) {
                    DialogWidget.buildDialog(
                        context: context,
                        title: '문의가 성공적으로 등록되었습니다.',
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        });

                    // DialogWidget.buildDialog(context: context,);
                    // _buildDialog(
                    // context: context,
                    // title: '문의가 성공적으로 등록되었습니다.',
                    // onClick: () {
                    //   Navigator.popUntil(context, (route) => route.isFirst);
                    // });
                  }
                }).catchError((error) {
                  if (error.contains('error_msg')) {
                    final Map<String, dynamic> map = json.decode(error);

                    DialogWidget.buildDialog(
                      context: context,
                      title: '에러',
                      subTitle1: map['error_msg'],
                    );
                  } else {
                    DialogWidget.buildDialog(
                      context: context,
                      subTitle1: '$error',
                      title: '에러',
                    );
                  }
                });
              }
            }
            //input text
            print(textController.text);
          },
        ),
      ),
    );
    //     Container(
    //   height: 48,
    //   margin: EdgeInsets.all(
    //     14,
    //   ),
    //   child: Container(
    //     decoration: BoxDecoration(
    //         color: const Color(0xff404040),
    //         borderRadius: BorderRadius.circular(4)),
    //     child: FlatButton(
    //       onPressed: () {
    //         //type select
    //         if (inquryCreateBloc.selectedType.hasValue) {
    //           if (textController.text.isNotEmpty) {
    //             print('can submit');
    //             inquryCreateBloc
    //                 .createInquiry(InquiryCreateModel(
    //                     message: textController.text,
    //                     type: inquryCreateBloc.selectedType.value.type))
    //                 .then((bool data) {
    //               if (data) {
    //                 _buildDialog(
    //                     context: context,
    //                     title: '문의가 성공적으로 등록되었습니다.',
    //                     onClick: () {
    //                       Navigator.popUntil(
    //                           context, (Route<dynamic> route) => route.isFirst);
    //                     });
    //               }
    //             });
    //           }
    //         }
    //         //input text
    //         print(textController.text);
    //       },
    //       child: Text(
    //         '문의 등록',
    //         style: TextStyles.white16BoldTextStyle,
    //       ),
    //     ),
    //   ),
    // ));
  }

  // void _buildDialog({BuildContext context, String title, Function onClick}) {
  //   showDialog<dynamic>(
  //       context: context,
  //       barrierDismissible: false, // user must tap button!
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(title),
  //           actions: <Widget>[
  //             FlatButton(
  //                 child: Text(
  //                   '확인',
  //                   style: TextStyles.black14BoldTextStyle,
  //                 ),
  //                 onPressed: onClick),
  //           ],
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    // InquiryCreateBloc inquryCreateBloc =
    //     Provider.of<InquiryCreateBloc>(context);
    return HandleNetworkModule(
      networkState: Provider.of<InquiryCreateBloc>(context).networkState,
      retry: Provider.of<InquiryCreateBloc>(context).fetch,
      child: StreamBuilder<List<InquiryTypeModel>>(
        stream: Provider.of<InquiryCreateBloc>(context).typeList,
        builder: (context, typeSnapshot) {
          if (!typeSnapshot.hasData) {
            return Center(heightFactor: 3.0, child: LoadingRingWidget());
          }

          return Column(
            children: <Widget>[
              _buildDropDown(context, typeSnapshot.data),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  // color: Colors.redAccent,

                  child: TextField(
                    controller: textController,
                    autocorrect: false,
                    decoration: const InputDecoration.collapsed(
                        hintText: '내용을 작성해 주세요'),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyles.black14TextStyle,
                  ),
                ),
              ),
              _buildSubmitContainer(context),
            ],
          );
        },
      ),
    );
  }
}
