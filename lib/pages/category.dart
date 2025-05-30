import 'package:career_pulse/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:career_pulse/main.dart';

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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Dashboad()),
                          );
                        },

                        child: Icon(Icons.arrow_back_ios, color: Colors.white),
                      ),

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
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 0, 35, 114),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 40,
                          width: 100,
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // Center horizontally
                            crossAxisAlignment:
                                CrossAxisAlignment.center, // Center vertically
                            children: [
                              Icon(Icons.location_on, color: Colors.white),
                              SizedBox(width: 5), // Space between Icon and Text
                              Text(
                                "Location",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 40),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 0, 35, 114),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 40,
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.list, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                "Category",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
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

                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow),
                                Text('4.5', style: TextStyle(fontSize: 15)),
                                SizedBox(width: 80),
                                Icon(
                                  Icons.favorite,
                                  color: const Color.fromARGB(255, 252, 18, 1),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            Text(
                              "Electrician",
                              style: TextStyle(
                                fontSize: 15,

                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 46, 125),
                              ),
                            ),

                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                  size: 12,
                                ),
                                Text("Lakshan", style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                  size: 12,
                                ),
                                Text(
                                  "Homagama",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              //box 2
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
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow),
                                Text('4.5', style: TextStyle(fontSize: 15)),
                                SizedBox(width: 80),
                                Icon(Icons.favorite, color: Colors.red),
                              ],
                            ),
                            SizedBox(height: 10),

                            Text(
                              "Electrician",
                              style: TextStyle(
                                fontSize: 15,

                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 46, 125),
                              ),
                            ),

                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                  size: 12,
                                ),
                                Text("Pathum", style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                  size: 12,
                                ),
                                Text("Galle", style: TextStyle(fontSize: 12)),
                              ],
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
