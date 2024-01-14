// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cotton/providers/provider.dart';
import 'package:intl/intl.dart';

import 'details.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List events = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final response = await getEvents();
      setState(() {
        events = json.decode(response)["content"]["data"];
      });
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Your Images'),
      ),
      body: events.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsPage(id: event["id"]),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: event["banner_image"].endsWith('svg')
                                ? SvgPicture(
                                    event["banner_image"],
                                    fit: BoxFit.cover,
                                    height: min(
                                        100,
                                        MediaQuery.of(context).size.width *
                                            0.25),
                                    width: min(
                                        100,
                                        MediaQuery.of(context).size.width *
                                            0.25),
                                  )
                                : Image.network(
                                    event["banner_image"],
                                    fit: BoxFit.cover,
                                    height: min(
                                        100,
                                        MediaQuery.of(context).size.width *
                                            0.25),
                                    width: min(
                                        100,
                                        MediaQuery.of(context).size.width *
                                            0.25),
                                  ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            height: min(
                                100, MediaQuery.of(context).size.width * 0.25),
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        DateFormat('E, MMM d').format(
                                            DateTime.parse(event["date_time"])),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromARGB(255, 33, 82, 243),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(
                                        Icons.circle,
                                        color: Color.fromARGB(255, 33, 82, 243),
                                        size: 6,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        DateFormat('h:mm a').format(
                                            DateTime.parse(event["date_time"])),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromARGB(255, 33, 82, 243),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Flexible(
                                    child: Text(
                                      event["title"],
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          event["venue_name"],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(
                                        Icons.circle,
                                        color: Colors.grey,
                                        size: 6,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Text(
                                          event["venue_city"] +
                                              ", " +
                                              event["venue_country"],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
