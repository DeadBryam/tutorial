library tutorial;

import 'package:flutter/material.dart';
import 'package:tutorial/src/models/tutorial_itens.dart';
import 'package:tutorial/src/painter/painter.dart';

class Tutorial {
  //FUNÇÃO QUE EXIBE O TUTORIAL
  static showTutorial(
    BuildContext context,
    List<TutorialItem> children, {
    void Function()? onInit,
    void Function(int index)? onChange,
    void Function()? onEnd,
  }) async {
    int count = 0;
    var size = MediaQuery.of(context).size;
    OverlayState? overlayState = Overlay.of(context);
    List<OverlayEntry> entrys = [];

    void _nextTutorial() {
      entrys[count].remove();
      count++;
      if (count != entrys.length) {
        onChange?.call(count);
        overlayState.insert(entrys[count]);
      }

      if (count == entrys.length) {
        onEnd?.call();
      }
    }

    children.forEach(
      (element) async {
        var offset = _capturePositionWidget(element.globalKey);
        var sizeWidget = _getSizeWidget(element.globalKey);
        entrys.add(
          OverlayEntry(
            builder: (context) {
              return GestureDetector(
                onTap: element.touchScreen == true ? _nextTutorial : () {},
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Stack(
                    children: [
                      CustomPaint(
                        size: size,
                        painter: HolePainter(
                          shapeFocus: element.shapeFocus,
                          dx: offset.dx + (sizeWidget.width / 2),
                          dy: offset.dy + (sizeWidget.height / 2),
                          width: sizeWidget.width,
                          height: sizeWidget.height,
                        ),
                      ),
                      Positioned(
                        top: element.top,
                        bottom: element.bottom,
                        left: element.left,
                        right: element.right,
                        child: Container(
                          width: size.width * 0.8,
                          child: Column(
                            crossAxisAlignment: element.crossAxisAlignment,
                            mainAxisAlignment: element.mainAxisAlignment,
                            children: [
                              ...element.children!,
                              GestureDetector(
                                child: element.widgetNext ??
                                    Text(
                                      "NEXT",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                onTap: _nextTutorial,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    overlayState.insert(entrys[0]);
    onInit?.call();
  }

  //FUNÇÃO PARA CAPTURAR A POSIÇÃO DO COMPONENTE
  static Offset _capturePositionWidget(GlobalKey? key) {
    RenderBox? renderPosition =
        key!.currentContext!.findRenderObject() as RenderBox;

    return renderPosition.localToGlobal(Offset.zero);
  }

  //FUNÇÃO PARA CAPTURAR AO TAMANHO DO COMPONENTE

  static Size _getSizeWidget(GlobalKey? key) {
    RenderBox? renderSize =
        key!.currentContext?.findRenderObject() as RenderBox;
    return renderSize.size;
  }
}
