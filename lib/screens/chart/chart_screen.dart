import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endol/common/text_widget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final storageRef = FirebaseFirestore.instance.collection('expensedetails');
  final userData = FirebaseFirestore.instance
      .collection('expensedetials')
      .doc(FirebaseAuth.instance.currentUser?.uid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.cream,
        title: ExtendedImage.asset(
          'assets/images/endol.png',
          scale: 4,
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
