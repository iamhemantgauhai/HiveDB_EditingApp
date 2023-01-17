import 'package:flutter/material.dart';
class SearchEngineOption extends StatefulWidget {
  const SearchEngineOption({Key? key}) : super(key: key);
  @override
  State<SearchEngineOption> createState() => _SearchEngineOptionState();
}
class _SearchEngineOptionState extends State<SearchEngineOption> {
  FocusNode focusNode = FocusNode();
  String hintText = 'Search Multiplier or type a URL';
  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        hintText = '';
      } else {
        hintText = 'Search Multiplier or type a URL';
      }
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text('Multiplier'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(10.0),
              child: const Image(
                  image: AssetImage('images/multiplier-square-logo.png')),),
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
                focusNode: focusNode,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIconColor: Colors.grey,
                  prefixIcon: const Icon(Icons.search),
                  suffixIconColor: Colors.grey,
                  suffixIcon: const Icon(Icons.keyboard_voice),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF000123)),
                      borderRadius: BorderRadius.all(Radius.circular(40.0))),
                  filled: true,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  hintText: hintText,
                  fillColor: Colors.white,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF000123)),
                      borderRadius: BorderRadius.all(Radius.circular(40.0))),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
