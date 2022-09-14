import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //create behavior subject every time widget rebuilds
    final subject = useMemoized(
      () => BehaviorSubject(),
      [key],
    );

    //dispose subject every time widget rebuilds
    useEffect(
      () => subject.close,
      [subject],
    );
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          stream: subject.stream.distinct().debounceTime(
                const Duration(seconds: 1),
              ),
          initialData: "Please start typing...",
          builder: (context, snapshot) {
            return Text(snapshot.requireData.toString());
          },
        ),
      ),
      body: TextField(
        onChanged: subject.sink.add,
      ),
    );
  }
}
