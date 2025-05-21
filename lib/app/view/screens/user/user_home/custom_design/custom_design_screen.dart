import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';

import '../../../../../core/route_path.dart';

class CustomDesignScreen extends StatefulWidget {
  const CustomDesignScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CustomDesignScreenState createState() => _CustomDesignScreenState();
}

class _CustomDesignScreenState extends State<CustomDesignScreen> {
  String editableText = "Your Text";
  double posX = 100;
  double posY = 200;
  bool isEditing = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = editableText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        appBarContent: "Custom Image",
        iconData: Icons.arrow_back,
      ),
      body: Column(
        children: [

          Center(
            child: Stack(
              children: [
                // Network image (load from URL)
                Image.network(
                  AppConstants.teeShirt,
                  width: 300,
                  height: 400,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      width: 300,
                      height: 400,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return SizedBox(
                      width: 300,
                      height: 400,
                      child: const Center(child: Icon(Icons.error)),
                    );
                  },
                ),

                // Editable and draggable text
                Positioned(
                  left: posX,
                  top: posY,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        posX += details.delta.dx;
                        posY += details.delta.dy;
                      });
                    },
                    onDoubleTap: () {
                      setState(() {
                        isEditing = true;
                        _controller.text = editableText;
                      });
                    },
                    child: isEditing
                        ? SizedBox(
                            width: 150,
                            child: TextField(
                              autofocus: true,
                              controller: _controller,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(blurRadius: 3, color: Colors.black)
                                ],
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (value) {
                                setState(() {
                                  editableText = value;
                                  isEditing = false;
                                });
                              },
                            ),
                          )
                        : Text(
                            editableText,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(blurRadius: 3, color: Colors.black)],
                            ),
                          ),
                  ),
                ),

              ],
            ),
          ),
           SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(15),
            child: CustomButton(onTap: (){
              context.pushNamed(
                RoutePath.customOrderScreen,
              );
            },title: "Order Now",),
          )

        ],
      ),
    );
  }
}
