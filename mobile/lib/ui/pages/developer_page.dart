import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/routes.dart';
import '../../utils/singleton.dart';
import '../components/common/header_title_widget.dart';

class DeveloperPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
  final TextEditingController _controller =
      TextEditingController(text: Singleton.instance.appVersion);

  int _groupValue = 0;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        _groupValue = value.getInt('api_server') ?? 0;
        _controller.text = value.getString('overriden_app_version') ??
            Singleton.instance.appVersion;
      });
    });
  }

  void _radioChanged(int value) {
    setState(() {
      _groupValue = value;
    });
  }

  void _handleSubmited(BuildContext context, String text) {
    _handleApplyOverridenVersion(context);
  }

  Future<void> _handleClearOverridenVersion(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    pref.remove('overriden_app_version');
    await _terminateApp(context);
  }

  Future<void> _handleApplyOverridenVersion(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    print(_controller.text);
    pref.setString('overriden_app_version', _controller.text);
    await _terminateApp(context);
  }

  Future<void> _applyAPIServer(BuildContext context) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('api_server', _groupValue);
    await AppRoutes.logout(context);

    await _terminateApp(context);
  }

  Future<void> _terminateApp(BuildContext context) async {
    Navigator.of(context).pop();
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', true);
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
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: HeaderTitleWidget(
              title: '개발 옵션'),
        ),
        body: SafeArea(
            child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    const Text('API Server'),
                    Row(
                      children: <Widget>[
                        Radio<int>(
                            value: 0,
                            groupValue: _groupValue,
                            onChanged: _radioChanged),
                        const Text('Unset'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio<int>(
                            value: 1,
                            groupValue: _groupValue,
                            onChanged: _radioChanged),
                        const Text('Dev Server'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio<int>(
                          value: 2,
                          groupValue: _groupValue,
                          onChanged: _radioChanged,
                        ),
                        const Text('Release Server')
                      ],
                    ),
                    FlatButton(
                        child: const Text('Apply'),
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () async {
                          await _applyAPIServer(context);
                        }),
                    const Divider(),
                  ])),
          Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    const Text('App Version Override'),
                    TextField(
                        controller: _controller,
                        onSubmitted: (value) =>
                            _handleSubmited(context, value)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                              child: const Text('Clear'),
                              color: Colors.red,
                              textColor: Colors.white,
                              onPressed: () =>
                                  _handleClearOverridenVersion(context)),
                          const SizedBox(width: 8),
                          FlatButton(
                              child: const Text('Apply'),
                              color: Colors.blue,
                              textColor: Colors.white,
                              onPressed: () =>
                                  _handleApplyOverridenVersion(context)),
                        ]),
                    const Divider()
                  ]))
        ])));
  }
}
