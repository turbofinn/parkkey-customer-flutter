import 'package:flutter/material.dart';
class BackTopTitle extends StatefulWidget {
  late String title;
  late String assetImage = '';
  late String backIncon;
  late Color titleColor;

  BackTopTitle(this.backIncon,this.titleColor,this.title,this.assetImage, {super.key});




  @override
  State<BackTopTitle> createState() => _BackTopTitleState();
}



class _BackTopTitleState extends State<BackTopTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: widget.backIncon == '' ? Container() : Container(
                height: 20,
                width: 20,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Image(
                      image: AssetImage(
                          widget.backIncon)),
                )),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(widget.title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
              color: widget.titleColor),
            ),
          ),
          widget.assetImage != '' ? Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                    image: AssetImage(
                        widget.assetImage)),
              )) : Container(
            height: 40,
            width: 40,
          )
        ],
      ),
    );
  }
}
