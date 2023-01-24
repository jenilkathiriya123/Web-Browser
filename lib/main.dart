import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: firstpage(),
    ),
  );
}

class firstpage extends StatefulWidget {
  const firstpage({Key? key}) : super(key: key);

  @override
  State<firstpage> createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {
  InAppWebViewController? inAppWebViewController;
  late PullToRefreshController pullToRefreshController;
  List allUri = [];

  @override
  void initState() {
    pullToRefreshController = PullToRefreshController(
        options: PullToRefreshOptions(color: Colors.blue),
        onRefresh: () async {
          await inAppWebViewController?.reload();
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () async {
              await inAppWebViewController?.loadUrl(
                  urlRequest:
                      URLRequest(url: Uri.parse("https://www.cricbuzz.com/")));
            },
            icon: Icon(Icons.home),
          ),
          IconButton(
            onPressed: () async {
              await inAppWebViewController?.goBack();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          IconButton(
            onPressed: () async {
              await inAppWebViewController?.reload();
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              await inAppWebViewController?.goForward();
            },
            icon: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
      body: InAppWebView(
        initialUrlRequest:
            URLRequest(url: Uri.parse("https://www.cricbuzz.com/")),
        onWebViewCreated: (controller) {
          setState(() {
            inAppWebViewController = controller;
          });
        },
        pullToRefreshController: pullToRefreshController,
        onLoadStop: (controller, url) async {
          await pullToRefreshController.endRefreshing();
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              Uri? uri = await inAppWebViewController?.getUrl();

              String url = uri.toString();
              allUri.add(url);
            },
            child: Icon(Icons.bookmark_added_outlined),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  scrollable: true,
                  title: Center(
                    child: Text("All-URI"),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: allUri
                        .map(
                          (e) => GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pop();
                              await inAppWebViewController?.loadUrl(
                                urlRequest: URLRequest(
                                  url: Uri.parse(e),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Text("${allUri.indexOf(e)+1}.$e"),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            },
            child: Icon(Icons.bookmark),
          )
        ],
      ),
    );
  }
}
