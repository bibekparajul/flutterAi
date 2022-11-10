import 'package:aiflutter/model/ai.dart';
import 'package:aiflutter/utils/ai_util.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

//ignore_for_file:prefer_const_constructors

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<MyRadio> radios;

  MyRadio ?_selectedRadio;
  // Color ?_selectedColor;
  bool _isPlaying = false;


  final AudioPlayer _audioPlayer = AudioPlayer();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRadios();

    _audioPlayer.onPlayerStateChanged.listen((event) {
      if(event == PlayerState.playing){
        _isPlaying = true;

      }
      else{
        _isPlaying = false;
      }
      setState(() {
        
      });
    });
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    // print(radios);
    setState(() {});
  }

   _playMusic(String url){
    _audioPlayer.play(UrlSource(url));
    _selectedRadio = radios.firstWhere((element) => element.url ==url);
    print(_selectedRadio?.name);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      // ignore: sort_child_properties_last
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

//appbar starts here with the animation

        AppBar(
          title: "AI Flutter".text.xl4.make().shimmer(
              primaryColor: Vx.purple300, secondaryColor: Colors.white),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
        ).h(100).p16(),
        radios!=null?VxSwiper.builder(
          itemCount: radios.length,
          aspectRatio: 1.0,
          enlargeCenterPage: true,
          itemBuilder: (context, index) {
            final rad = radios[index];
            // ignore: prefer_const_literals_to_create_immutables
            return VxBox(
                    child: ZStack([
              Positioned(
                top: 0.0,
                right: 0.0,
                child: VxBox(
                        child: rad.category.text.uppercase.white.make().px16(),)
                    
                    .height(40)
                    .black
                    .alignCenter
                    .withRounded(value: 10.0)
                    .make(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: VStack(
                  [
                    rad.name.text.xl3.white.bold.make(),
                    5.heightBox,
                    rad.tagline.text.sm.white.semiBold.make(),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: [
                    Icon(
                      CupertinoIcons.play_circle,
                      color: Colors.white,
                    ),
                    10.heightBox,
                    "Double tap to play".text.gray300.make(),
                  ].vStack())
            ], clip: Clip.antiAlias,)).clip(Clip.antiAlias)
                .bgImage(
                  DecorationImage(
                      image: NetworkImage(rad.image),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.darken)),
                )
                .border(color: Colors.black, width: 5.0)
                .withRounded(value: 50.0)
                .make()
                .onInkDoubleTap(() {
                  _playMusic(rad.url);
                })
                .p16();
                
          },
        ).centered(): Center(child: CircularProgressIndicator(),),
        Align(
          alignment: Alignment.bottomCenter,
          child: [

            if(_isPlaying)
              "Playing Now - ${_selectedRadio?.name} FM".text.makeCentered(),
            
            Icon(
            _isPlaying? CupertinoIcons.stop_circle : CupertinoIcons.play_circle,
          color: Colors.white, size: 40,)
          .onInkTap(() {
            if(_isPlaying){
              _audioPlayer.stop();
            }else{
              _playMusic(_selectedRadio!.url);
            }
          })
          
          
          
          ].vStack(),

        ).pOnly(bottom: context.percentHeight*12)
      ], fit: StackFit.expand),
    );
  }
}
