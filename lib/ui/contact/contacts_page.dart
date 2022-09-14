import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';
import 'package:vocechat_client/api/models/user/user_info.dart';
import 'package:vocechat_client/app.dart';
import 'package:vocechat_client/dao/init_dao/user_info.dart';
import 'package:vocechat_client/services/chat_service.dart';
import 'package:vocechat_client/ui/contact/contact_detail_page.dart';
import 'package:vocechat_client/ui/contact/contact_list.dart';
import 'package:vocechat_client/ui/contact/contact_tile.dart';
import 'package:vocechat_client/ui/contact/contacts_bar.dart';

class ContactsPage extends StatefulWidget {
  static const route = "/contacts";

  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin {
  late final _contactFuture;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    _contactFuture = getContactList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: ContactsBar(),
        body: SafeArea(
          child: FutureBuilder<List<UserInfoM>?>(
            future: _contactFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ContactList(
                    userList: snapshot.data!,
                    onTap: (userInfoM) => Navigator.of(context).pushNamed(
                        ContactDetailPage.route,
                        arguments: userInfoM));
              }
              return Center(child: CupertinoActivityIndicator());
            },
          ),
        ));
  }

  Future<List<UserInfoM>?> getContactList() async {
    return UserInfoDao().getUserList();
  }
}