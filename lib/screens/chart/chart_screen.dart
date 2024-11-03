import 'package:cloud_firestore/cloud_firestore.dart';
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
  final storageRef =
      FirebaseFirestore.instance.collection(Strings.expenseDatabase);
  final userData = FirebaseFirestore.instance
      .collection(Strings.expenseDatabase)
      .doc(FirebaseAuth.instance.currentUser?.uid);
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
      body: SafeArea(
        child: StreamBuilder(
          stream: storageRef.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            return ListView.builder(
              itemCount: streamSnapshot.data?.docs.length,
              itemBuilder: (ctx, index) => TextWidget(
                text: (streamSnapshot.data?.docs[index]['category']),
              ),
            );
          },
        ),
      ),
    );
  }
}
