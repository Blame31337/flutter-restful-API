import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_flutter_app/models/post_model.dart';
import '../services/auth_services.dart';

class WhatsAppHome extends StatefulWidget {
  @override
  _WhatsAppHomeState createState() => _WhatsAppHomeState();
}

class _WhatsAppHomeState extends State<WhatsAppHome> {
  List id = [];

  List<String> images = [];

  List<int> like = [];

  List<int> likeCount = [];

  int length = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Test Flutter App',
        ),
        backgroundColor: Colors.black,
        leading: GestureDetector(
          child: Center(
            child: Text('logout'),
          ),
          onTap: () async {
            sendDataForLogout(context);
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.black,
        child: new Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          showAllPhoto();
        },
      ),
      body: FutureBuilder(
        future: showAllPhoto(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            print(id);
            return ListView.builder(
              itemCount: length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onDoubleTap: () async {
                        likeOrUnlike(index);
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(images[index]),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 20, 10),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              likeOrUnlike(index);
                            },
                            child: like[index] == 1
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 35,
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                    size: 35,
                                  ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(likeCount[index].toString()),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.comment,
                            color: Colors.black,
                            size: 35,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  sendDataForLogout(context) async {
    Map response = await (new AuthService()).sendDataToLogout();

    if (response["success"] == true) {
      Navigator.pushReplacementNamed(context, "/login");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
    } else {
      print(response.toString());
    }
  }

  showAllPhoto() async {
    Map response = await (new AuthService()).showAllPhotos();
    if (response["success"] == true) {
      length = response["data"]["data"].length;
      id = [];
      images = [];
      like = [];
      likeCount = [];
      for (int i = 0; i < length; i++) {
        images.add(response["data"]["data"][i]["images"][0]["image_url"]);
        id.add(response["data"]["data"][i]["images"][0]["id"]);
        like.add(response["data"]["data"][i]["is_liked"]);
        likeCount.add(response["data"]["data"][i]["users_liked_count"]);

//        id.add(data[i]["images"][0]["id"]);
      }
    } else {
      print("error");
    }
  }

  likeOrUnlike(index) async {
    Map response = await (new AuthService()).likeOrUnlike({
      "post_id": id[index].toString(),
    });
    print(response);
    if (response["success"] == "true" || response["success"] == true) {
      for (int i = 0; i < length; i++) {
        setState(() {
          showAllPhoto();
        });
      }

      print(response["liked"]);
    } else {
      print("error");
    }
  }
}
