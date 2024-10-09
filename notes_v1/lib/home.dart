import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "Get Go",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const Image(image: AssetImage("assets/images/note.jpg")),
              const Spacer(),
              IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, "/signin");
                },
                icon: const Icon(Icons.forward),
                iconSize: 64,
              ),
              const Spacer()
            ]
          )
        )
      ),
    );
  }
}
