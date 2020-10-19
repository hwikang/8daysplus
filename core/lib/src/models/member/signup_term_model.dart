import 'package:meta/meta.dart';

class SignUpTermModel {
  SignUpTermModel(
      {@required this.termService,
      this.termLocation,
      this.termLocationOption,
      this.termMarketing});

  bool termLocation = false;
  bool termLocationOption = false;
  bool termMarketing = false;
  bool termService = false;
}

// SignUpTermModel model = SignUpTermModel(
//         termService:true,
//         termLocation:true,
//         termLocationOption:true,
//         termMarketing:true,
//       );
