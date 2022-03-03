import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:waslcom/core/utils/get_file_from_assets_util.dart';
import 'package:waslcom/ui/views/account_info/account_info_view.dart';
import 'package:waslcom/ui/views/store_views/main_store_view/main_store_view.dart';

class OnBoardingView extends StatelessWidget {
  final bool fromMainMenu;

  const OnBoardingView({Key key, this.fromMainMenu = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: IntroductionScreen(
            next: Icon(Icons.navigate_next),
            showNextButton: true,
            skip: Text("تخطي", style: TextStyle(fontWeight: FontWeight.w600)),
            pages: listPagesViewModel(size),
            done: const Text("إنهاء الجولة",
                style: TextStyle(fontWeight: FontWeight.w600)),
            onDone: () {
              if (fromMainMenu) {
                Get.back();
              } else {
                Get.offAll(() => AccountInfoView());
              }
            },
            onSkip: () {
              if (fromMainMenu) {
                Get.back();
              } else {
                Get.offAll(() => MainStoreView());
              }
            },
            showSkipButton: fromMainMenu,
          ),
        ),
      ),
    );
  }

  List<PageViewModel> listPagesViewModel(size) => [
        PageViewModel(
          title: "مرحباً بك في" + " " + AssetsUtils.appName,
          body: "جولة سريعة للتعريف بكيفية استخدام تطبيق" +
              " " +
              AssetsUtils.appName,
          image: Center(
              child: Image.asset(
            AssetsUtils.appLogo,
            height: 600,
            width: 800,
            fit: BoxFit.contain,
          )),
          decoration: const PageDecoration(
            pageColor: Colors.white,
          ),
        ),
        PageViewModel(
          title: "معلومات الحساب",
          body:
              "يجب اضافة بعض المعلومات الشخصية المهمة كالاسم و العنوان وذلك لضمان أفضل تواصل ممكن",
          image: Center(
              child: Image.asset(
            AssetsUtils.appLogo,
            height: 600,
            width: 800,
            fit: BoxFit.contain,
          )),
          decoration: const PageDecoration(
            pageColor: Colors.white,
          ),
        ),
        PageViewModel(
          title: "التسوق واضافة المواد",
          body:
              "يمكنك استخدام البحث للتسوق في تطبيقنا واضافة العناصر الى سلة المشتريات",
          image: Center(
              child: Image.asset(
            AssetsUtils.appLogo,
            height: 600,
            width: 800,
            fit: BoxFit.contain,
          )),
          decoration: const PageDecoration(
            pageColor: Colors.white,
          ),
        ),
        PageViewModel(
          title: "ارسال الطلب",
          body:
              "يمكنك ارسال الطلب الى عناوين استلام سابقة أو الارسال الى عنوان جديد بعد تحديد الصنف و الكمية كما يمكن البحث عن طريق الباركود الخاص بالمنتج لتحديد كميته المطلوبة",
          image: Center(
              child: Image.asset(
            AssetsUtils.appLogo,
            height: 600,
            width: 800,
            fit: BoxFit.contain,
          )),
          decoration: const PageDecoration(
            pageColor: Colors.white,
          ),
        ),
        PageViewModel(
          title: "تسديد الفاتورة",
          body:
              "يمكن عرض تفاصيل الفاتورة ليتم قبولها او رفضها من قبل المستخدم بعد ذلك يمكن اختيار وضع التسديد نقداً لتتغير حالة الفاتورة",
          image: Center(
              child: Image.asset(
            AssetsUtils.appLogo,
            height: 600,
            width: 800,
            fit: BoxFit.contain,
          )),
          decoration: const PageDecoration(
            pageColor: Colors.white,
          ),
        ),
      ];
}
