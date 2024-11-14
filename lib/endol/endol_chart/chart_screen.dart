import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endol/common/dialogs.dart';
import 'package:endol/common/text_widget.dart';
import 'package:endol/constants/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  Map<String, dynamic>? expenseData;

  final storageRef =
      FirebaseFirestore.instance.collection(Strings.expenseDatabase);
  final userData = FirebaseFirestore.instance
      .collection(Strings.expenseDatabase)
      .doc(FirebaseAuth.instance.currentUser?.uid);

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
        for (var doc in querySnapshot.docs) {
          expenseData = doc.data() as Map<String, dynamic>;
          log('Category ${expenseData?['category']}, Amount${expenseData?['amount']}');
          log('${expenseData?.length}');
        }
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
              child: StreamBuilder(
                stream: storageRef.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  return ListView.builder(
                    itemCount: expenseData?.length,
                    itemBuilder: (ctx, index) => TextWidget(
                      text: (expenseData?['category']),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
