import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/device_ratio.dart';
import '../../../utils/routes.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/button/white_button_widget.dart';
import '../../components/common/customer_center_widget.dart';
import '../../components/common/header_title_widget.dart';
import '../../components/common/payment_webview.dart';
import '../../components/common/user/user_info_widget.dart';

class ReservationVoucherPage extends StatefulWidget {
  const ReservationVoucherPage({this.orderInfo, this.index});

  final int index;
  final CreateOrderInputModel orderInfo; // refund 에필요

  @override
  _ReservationVoucherPageState createState() => _ReservationVoucherPageState();
}

class _ReservationVoucherPageState extends State<ReservationVoucherPage> {
  String path;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print('directory $directory');
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print('path $path');
    return File(
        '$path/${widget.orderInfo.options[widget.index].orderProduct.product.id}.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    print('writeCounter');
    final file = await _localFile;

    return file.writeAsBytes(stream);
  }

  Future<bool> existsFile() async {
    final file = await _localFile;
    return file.existsSync();
  }

  Future<Uint8List> fetchPost(String url) async {
    final response = await http.get(url);
    final responseJson = response.bodyBytes;
    return responseJson;
  }

  Widget _buildProductInfo(
      BuildContext context, OrderInfoProductModel orderProduct) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '상품 정보',
            style: TextStyles.black20BoldTextStyle,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            orderProduct.product.name,
            style: TextStyles.black14BoldTextStyle,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: orderProduct.orderProductOptions.length,
            itemBuilder: (context, index) {
              final option = orderProduct.orderProductOptions[index];
              return Container(
                margin: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      // color: Colors.red,
                      width: 280 * DeviceRatio.scaleWidth(context),
                      child: Text(
                        '${option.optionName}-${option.optionItemName}',
                        style: TextStyles.grey14TextStyle,
                      ),
                    ),
                    Text(
                      '${option.amount}개',
                      style: TextStyles.grey14TextStyle,
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              AppRoutes.pop(context);
            },
          ),
          titleSpacing: 0.0,
          title: const HeaderTitleWidget(title: '바우처 확인'),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 248 + 40 * MediaQuery.of(context).textScaleFactor,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Color(0xffe0e0e0)))),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: <Widget>[
                        QrImage(
                          data: widget.orderInfo.options[widget.index]
                              .orderProduct.voucher.barcode,
                          version: QrVersions.auto,
                          size: 140,
                          padding: const EdgeInsets.all(0),
                        ),
                        Text(
                            widget.orderInfo.options[widget.index].orderProduct
                                .voucher.barcode,
                            style: TextStyles.black14TextStyle),
                        const SizedBox(
                          height: 20,
                        ),
                        WhiteButtonWidget(
                          title: 'PDF 바우처',
                          height: 40,
                          onPressed: () async {
                            String url;
                            //pdf 파일 형식
                            if (widget.orderInfo.options[widget.index]
                                .orderProduct.voucher.filePath
                                .contains('.pdf')) {
                              url =
                                  'http://docs.google.com/viewer?url=${widget.orderInfo.options[widget.index].orderProduct.voucher.filePath}';
                            } else {
                              url = widget.orderInfo.options[widget.index]
                                  .orderProduct.voucher.filePath;
                            }


                            print(url);

                            if (Platform.isIOS) {
                              AppRoutes.buildTitledModalBottomSheet(
                                context: context,
                                title: '바우처 확인',
                                child: PaymentWebview(url: url),
                              );
                            } else if (Platform.isAndroid) {
                              print('is a Andriod');

                              await writeCounter(await fetchPost(
                                  '${widget.orderInfo.options[widget.index].orderProduct.voucher.filePath}'));
                              final exist = await existsFile();
                              if (exist) {
                                path = (await _localFile).path;
                                AppRoutes.buildTitledModalBottomSheet(
                                  context: context,
                                  title: '바우처 확인',
                                  child: PdfViewer(
                                    filePath: path,
                                  ),
                                );
                              } else {
                                launch(widget.orderInfo.options[widget.index]
                                    .orderProduct.voucher.filePath); //다운로드함
                              }
                            } else {}
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.all(24),
                  child: Column(
                    children: <Widget>[
                      _buildProductInfo(context,
                          widget.orderInfo.options[widget.index].orderProduct),
                      Container(
                          margin: const EdgeInsets.only(top: 48),
                          child: UserInfoWidget(
                              fields: widget.orderInfo.fields,
                              title: '예약자 정보')),
                      Container(
                        margin: widget.orderInfo.options[widget.index].fields
                                .isNotEmpty
                            ? const EdgeInsets.only(top: 48)
                            : const EdgeInsets.only(top: 0),
                        child: UserInfoWidget(
                          fields: widget.orderInfo.options[widget.index].fields,
                          title: '예약상세정보',
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 48),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '8데이즈+ 고객 센터',
                                style: TextStyles.black20BoldTextStyle,
                              ),
                              const CustomerCenterWidget(),
                            ],
                          )),
                    ],
                  )),
            ],
          ),
        ));
  }
}
