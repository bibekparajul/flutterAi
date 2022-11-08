import 'package:aiflutter/model/ai.dart';
import 'package:aiflutter/utils/ai_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   late List<MyRadio> radios;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRadios();
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    // print(radios);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Stack(children: [
        VxAnimatedBox()
            .size(context.screenWidth, context.screenHeight)
            .withGradient(
              LinearGradient(colors: [
                AIColors.primaryColor1,
                AIColors.primaryColor2,
              ], begin: Alignment.topLeft, end: Alignment.bottomLeft),
            )
            .make(),
        AppBar(
          title: "AI Flutter".text.xl4.make().shimmer(
              primaryColor: Vx.purple300, secondaryColor: Colors.white),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
        ).h(100).p16(),
        VxSwiper.builder(
          itemCount: radios.length,
          aspectRatio: 1.0,
          enlargeCenterPage: true,
          itemBuilder: (context, index) {
            final rad = radios[index];
            return VxBox(child: ZStack([]))
                .bgImage(DecorationImage(image: NetworkImage(rad.image),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken)
                
                
                ),
                )
                .border(color: Colors.black,width: 5.0)
                .withRounded(value: 60.0)
                .make().p16().centered();
          },
        )
      ]),
    );
  }
}
