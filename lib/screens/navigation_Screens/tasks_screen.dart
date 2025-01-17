import 'package:flutter/material.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              ' daha is almadin ',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Text(
                  ' aradigin hizmeti bul ',
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
