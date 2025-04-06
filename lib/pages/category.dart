import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 46, 125),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.arrow_back_ios, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Search icon
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 20, 0),
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white),
                        Text(
                          "Location",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),

                        SizedBox(width: 40),

                        Icon(Icons.list, color: Colors.white),
                        Text(
                          "Categories",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              //box 1
              Center(
                child: Container(
                  height: 120,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/cate1.png',
                                fit: BoxFit.cover,
                                height: 103,
                                width: 120,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Software Engineer",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 46, 125),
                              ),
                            ),

                            SizedBox(height: 5),
                            Text(
                              "Software Engineer",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 46, 125),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 10),

              // Center(
              //   child: Container(
              //     height: 120,
              //     width: 350,
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(20),
              //     ),

              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [],
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10),
              // Center(
              //   child: Container(
              //     height: 120,
              //     width: 350,
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(20),
              //     ),

              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
