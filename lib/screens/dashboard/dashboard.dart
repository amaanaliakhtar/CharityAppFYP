import 'package:charity_app/screens/dashboard/filters_class.dart';
import 'package:charity_app/screens/projects/all_projects.dart';
import 'package:charity_app/screens/projects/project_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        // actions: [
        //   Container(
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10),
        //         color: Colors.transparent),
        //     child: IconButton(
        //       onPressed: () {},
        //       icon: const Image(image: AssetImage("assets/logo.png")),
        //     ),
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            //stack children vertically
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Hey!"),
              const Text(
                "Explore Charities",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
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
                    Opacity(
                      opacity: 0.4,
                      child: Text(
                        "Search...",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.search,
                      size: 24,
                    )
                  ], //todo change opacity
                ),
              ),

              const SizedBox(height: 20),

              //filter options
              const SizedBox(
                height: 45,
                child: FilterList(),
              ),

              const SizedBox(
                height: 20,
              ),

              //featured charities
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFF7F6F1),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: const Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Icon(Icons.menu_book_rounded),
                              ),
                              Flexible(
                                child: Image(
                                  image: AssetImage('assets/education.png'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Education for orphans",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFF7F6F1),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: const Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Icon(Icons.water_drop),
                              ),
                              Flexible(
                                child: Image(
                                  image: AssetImage('assets/water.png'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Give the gift of water",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AllProjects(),
                      ),
                    );
                  },
                  child: const Text("View All"),
                ),
              ),

              //recommended courses
              const SizedBox(height: 10),
              const Text(
                "Recommended for You",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              const SizedBox(
                height: 5,
              ),

              //Card
              SizedBox(
                height: 200,
                width: 320,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFF7F6F1),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "Food packs for orphans",
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          Flexible(
                            child: const Image(
                              image: AssetImage("assets/food.png"),
                              height: 110,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => const ProjectDetails(),
                              //   ),
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("Find out more!")
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterList extends StatelessWidget {
  const FilterList({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference filters =
        FirebaseFirestore.instance.collection('filters');

    return FutureBuilder(
        future: filters.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //if error
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/icons/warning.png'),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Error Loading Information',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            List<FilterClass> list = <FilterClass>[];

            for (var element in snapshot.data!.docs) {
              list.add(
                FilterClass(
                    category: element['category'], display: element['display']),
              );
            }
            return getFilters(list);
          }

          return const Center();
        });
  }
}

class FilterButton extends StatelessWidget {
  final FilterClass filter;
  const FilterButton({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        width: 170,
        height: 45,
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              child: Center(
                child: Text(
                  //todo change these to images
                  filter.display,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    filter.category,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget getFilters(List<FilterClass> data) {
  List<Widget> filters = <Widget>[];

  for (var i = 0; i < data.length; i++) {
    filters.add(FilterButton(filter: data[i]));
  }

  return ListView(
    scrollDirection: Axis.horizontal,
    shrinkWrap: true,
    children: filters,
  );
}
//TODO
//change fonts and text size