import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endol/common/dialogs.dart';
import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_colors.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  List<Map<String, dynamic>> expenseData = [];

  final storageRef =
      FirebaseFirestore.instance.collection(Strings.expenseDatabase);

  // final userData = FirebaseFirestore.instance
  //     .collection(Strings.expenseDatabase)
  //     .doc(FirebaseAuth.instance.currentUser?.uid);

  Future<void> _getUserExpenses() async {
    final User? user = auth.currentUser;
    final uid = user?.uid;

    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      QuerySnapshot querySnapshot =
          await storageRef.where('uid', isEqualTo: uid).get();
      log('The expense data: $querySnapshot');

      if (querySnapshot.docs.isNotEmpty) {
        expenseData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        // for (var doc in querySnapshot.docs) {
        //   expenseData = doc.data() as Map<String, dynamic>;
        //   log('Category ${expenseData?['category']}, Amount${expenseData?['amount']}');
        //   log('${expenseData?.length}');
        // }
      } else {
        log('Collection is empty ');
      }
    } catch (e) {
      log('$e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.cream,
        title: const TextWidget(
          text: 'Charts',
          color: AppColors.thatBrown,
          fontWeight: FontWeight.bold,
          size: 20,
        ),
      ),
      body: isLoading
          ? Dialogs.loadingInScreen()
          : SafeArea(
              child: StreamBuilder<QuerySnapshot>(
                stream: storageRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const TextWidget(text: 'Empty');
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      final expense = doc.data() as Map<String, dynamic>;
                      DateTime dateTime = expense['expenseDate'].toDate();
                      String formattedDate =
                          DateFormat('MM, dd, yyyy').format(dateTime);

                      log('$dateTime');
                      return Row(
                        children: [
                          const Icon(Icons.abc),
                          Column(
                            children: [
                              TextWidget(text: expense['category']),
                              TextWidget(text: formattedDate)
                            ],
                          )
                        ],
                      );
                      //   ListTile(
                      //   title: Text(expense['category']),
                      //   subtitle: Text('Amount: ${expense['amount']}'),
                      // );
                    }).toList(),
                  );
                },
              ),
            ),
    );
  }
}
