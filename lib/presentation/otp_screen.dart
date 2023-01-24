import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_autofill_demo/global/utils/common_utils.dart';
import 'package:otp_autofill_demo/presentation/home_screen.dart';
import 'package:otp_autofill_demo/presentation/widget/border_box.dart';
import 'package:otp_autofill_demo/presentation/widget/white_container.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  final String phone;

  const OtpScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otpCode = "";
  String otp = "";
  bool isLoaded = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    _listenOtp();
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    print("Unregistered Listener");
    super.dispose();
  }

  void _listenOtp() async {
    await SmsAutoFill().listenForCode();
    print("OTP Listen is called");
  }

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: const Color(0xFF8C4A52),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: isLoaded ? Colors.white : const Color(0xFF8C4A52),
          body: isLoaded
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 50),
                            child: Container(
                              height: 50,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          WhiteContainer(
                            headerText: "Enter OTP",
                            labelText:
                                "OTP has been successfully sent to your \n ${widget.phone}",
                            child: Container(
                              height: 70,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  PinFieldAutoFill(
                                    currentCode: otpCode,
                                    decoration: const BoxLooseDecoration(
                                        radius: Radius.circular(12),
                                        strokeColorBuilder: FixedColorBuilder(
                                            Color(0xFF8C4A52))),
                                    codeLength: 6,
                                    onCodeChanged: (code) {
                                      print("OnCodeChanged : $code");
                                      otpCode = code.toString();
                                    },
                                    onCodeSubmitted: (val) {
                                      print("OnCodeSubmitted : $val");
                                    },
                                  )
                                  // Expanded(
                                  //   child: ListView.builder(
                                  //       itemCount: 6,
                                  //       scrollDirection: Axis.horizontal,
                                  //       itemBuilder: (context, index) {
                                  //         return BorderBox(
                                  //             width: 55,
                                  //             padding:
                                  //                 const EdgeInsets.symmetric(
                                  //                     horizontal: 21),
                                  //             margin: true,
                                  //             color: Colors.grey.shade200,
                                  //             child: TextFormField(
                                  //               textAlign: TextAlign.center,
                                  //               initialValue: null,
                                  //               keyboardType:
                                  //                   TextInputType.number,
                                  //               autofocus: true,
                                  //               inputFormatters: [
                                  //                 LengthLimitingTextInputFormatter(
                                  //                     1),
                                  //                 FilteringTextInputFormatter
                                  //                     .digitsOnly
                                  //               ],
                                  //               validator: (value) {
                                  //                 if (value!.isEmpty) {
                                  //                   return "?";
                                  //                 }
                                  //               },
                                  //               // maxLength: 1,
                                  //               onChanged: (value) {
                                  //                 if (value.length == 1) {
                                  //                   if (index < 5) {
                                  //                     FocusScope.of(context)
                                  //                         .nextFocus();
                                  //                   } else {
                                  //                     FocusScope.of(context)
                                  //                         .unfocus();
                                  //                   }
                                  //                 }
                                  //                 if (value.isEmpty) {
                                  //                   if (index > 0) {
                                  //                     FocusScope.of(context)
                                  //                         .previousFocus();
                                  //                     return;
                                  //                   }
                                  //                 }
                                  //                 otp += value;
                                  //                 if (index == 5) {
                                  //                   otpCode = otp;
                                  //                   otp = "";
                                  //                 }
                                  //               },
                                  //               style: const TextStyle(
                                  //                   fontSize: 19,
                                  //                   fontWeight:
                                  //                       FontWeight.w600),
                                  //               // textInputAction: TextInputAction.next,
                                  //               decoration: InputDecoration(
                                  //                   border: InputBorder.none,
                                  //                   hintText: "0",
                                  //                   hintStyle: TextStyle(
                                  //                       color: Colors
                                  //                           .grey.shade400)),
                                  //             ));
                                  //       }),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            color: Colors.white,
            child: GestureDetector(
              onTap: () async {
                print("OTP: $otpCode");
                setState(() {
                  isLoaded = true;
                });
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: CommonUtils.verify, smsCode: otpCode);
                  await auth.signInWithCredential(credential);
                  setState(() {
                    isLoaded = false;
                  });
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                } catch (e) {
                  setState(() {
                    isLoaded = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Wrong OTP! Please enter again")));
                  print("Wrong OTP");
                }
              },
              child: const BorderBox(
                margin: false,
                color: Color(0xFF8C4A52),
                height: 50,
                child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
