import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
        title: const Text(
          "Charity Navigator",
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent),
            child: IconButton(
              onPressed: () {},
              icon: const Image(image: AssetImage("assets/logo.png")),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            //stack children vertically
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Hey!"),
              const Text("Explore Charities"),
              const SizedBox(
                height: 20,
              ),

              //search bar
              Container(
                decoration: (const BoxDecoration(
                    border: Border(left: BorderSide(width: 3)))),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Search..."),
                    Icon(
                      Icons.search,
                      size: 24,
                    )
                  ], //todo change opacity
                ),
              ),

              const SizedBox(height: 20),

              //filter options
              SizedBox(
                width: 170,
                height: 50,
                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0x212833),
                      ),
                      child: Center(
                        child: Text(
                          "E",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


//TODO
//change fonts and text size