import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:vocechat_client/api/lib/dio_retry/options.dart';
import 'package:vocechat_client/api/lib/dio_retry/retry_interceptor.dart';
import 'package:vocechat_client/api/lib/dio_util.dart';
import 'package:vocechat_client/api/models/group/group_create_request.dart';
import 'package:vocechat_client/api/models/group/group_update_request.dart';
import 'package:vocechat_client/app.dart';
import 'package:vocechat_client/app_consts.dart';

class GroupApi {
  late final String _baseUrl;

  GroupApi(String serverUrl) {
    _baseUrl = serverUrl + "/api/group";
  }

  Future<Response<int>> create(GroupCreateRequest req) async {
    final dio = DioUtil.token(baseUrl: _baseUrl);

    return await dio.post("", data: req);
  }

  Future<Response> addMembers(int gid, List<int> adds) async {
    final dio = DioUtil.token(baseUrl: _baseUrl);
    dio.options.headers["Content-Type"] = "application/json";

    return await dio.post("/$gid/members/add", data: json.encode(adds));
  }

  Future<Response> removeMembers(int gid, List<int> removes) async {
    final dio = DioUtil.token(baseUrl: _baseUrl);
    dio.options.headers["Content-Type"] = "application/json";

    return await dio.post("/$gid/members/remove", data: json.encode(removes));
  }

  Future<Response> delete(int gid) async {
    final dio = DioUtil.token(baseUrl: _baseUrl);

    return dio.delete("/$gid");
  }

  Future<Response> pin(int gid, int mid, bool toPin) async {
    // if pinned == 0, it has not pinned before. Thus needs to be pinned.
    String pinAction = toPin ? 'pin' : 'unpin';
    final dio = DioUtil.token(baseUrl: _baseUrl);
    dio.options.headers["Content-Type"] = "application/json";

    return await dio.post("/$gid/$pinAction", data: json.encode({'mid': mid}));
  }

  Future<Response<int>> sendTextMsg(
      int gid, String msg, Map<String, dynamic>? properties,
      {ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    final dio = DioUtil.token(baseUrl: _baseUrl);
    dio.options.headers["X-Properties"] =
        base64.encode(utf8.encode(json.encode(properties)));
    dio.options.headers["Content-Type"] = typeText;
    dio.options.receiveTimeout = 10000;

    final res = await dio.post("/$gid/send", data: msg);

    var newRes = Response<int>(
        headers: res.headers,
        requestOptions: res.requestOptions,
        isRedirect: res.isRedirect,
        statusCode: res.statusCode,
        statusMessage: res.statusMessage,
        redirects: res.redirects,
        extra: res.extra);

    if (res.statusCode == 200 && res.data != null) {
      final data = res.data as int;
      newRes.data = data;
    }
    return newRes;
  }

  Future<Response<int>> sendMarkdownMsg(int gid, String msg, String cid) async {
    final dio = DioUtil.token(baseUrl: _baseUrl);
    dio.options.headers["X-Properties"] =
        base64.encode(utf8.encode(json.encode({'cid': cid})));
    dio.options.headers["Content-Type"] = typeText;
    final res = await dio.post("/$gid/send", data: msg);

    var newRes = Response<int>(
        headers: res.headers,
        requestOptions: res.requestOptions,
        isRedirect: res.isRedirect,
        statusCode: res.statusCode,
        statusMessage: res.statusMessage,
        redirects: res.redirects,
        extra: res.extra);

    if (res.statusCode == 200 && res.data != null) {
      final data = res.data as int;
      newRes.data = data;
    }
    return newRes;
  }

  Future<Response<int>> sendArchiveMsg(
      int gid, String cid, String archiveId) async {
    final dio = DioUtil.token(baseUrl: _baseUrl);

    Map<String, dynamic> properties = {'cid': cid};

    dio.options.headers["X-Properties"] =
        base64.encode(utf8.encode(json.encode(properties)));
    dio.options.headers["Content-Type"] = typeArchive;

    final res = await dio.post("/$gid/send", data: archiveId);

    var newRes = Response<int>(
        headers: res.headers,
        requestOptions: res.requestOptions,
        isRedirect: res.isRedirect,
        statusCode: res.statusCode,
        statusMessage: res.statusMessage,
        redirects: res.redirects,
        extra: res.extra);

    if (res.statusCode == 200 && res.data != null) {
      final data = res.data! as int;
      newRes.data = data;
    }
    return newRes;
  }

  Future<Response<int>> sendFileMsg(int gid, String cid, String path,
      {int? width, int? height}) async {
    final dio = DioUtil.token(baseUrl: _baseUrl);

    Map<String, dynamic> properties = {'cid': cid};
    if (width != null && height != null) {
      properties.addAll({'width': width, 'height': height});
    }
    dio.options.headers["X-Properties"] =
        base64.encode(utf8.encode(json.encode(properties)));
    dio.options.headers["Content-Type"] = typeFile;

    final data = {'path': path};

    final res = await dio.post("/$gid/send", data: json.encode(data));

    var newRes = Response<int>(
        headers: res.headers,
        requestOptions: res.requestOptions,
        isRedirect: res.isRedirect,
        statusCode: res.statusCode,
        statusMessage: res.statusMessage,
        redirects: res.redirects,
        extra: res.extra);

    if (res.statusCode == 200 && res.data != null) {
      final data = res.data! as int;
      newRes.data = data;
    }
    return newRes;
  }

  Future<Response<String>> createInviteLink(int gid,
      {int expiredIn = 1800}) async {
    final dio = DioUtil.token(baseUrl: _baseUrl);

    return dio.get<String>(
      "/$gid/create_invite_link?expired_in=$expiredIn",
    );
  }

  Future<Response<String>> uploadGroupAvatar(
      int gid, Uint8List avatarBytes) async {
    final dio = DioUtil.token(baseUrl: _baseUrl);
    dio.options.headers["Content-Type"] = "image/png";

    return dio.post(
      "/$gid/avatar",
      data: Stream.fromIterable(avatarBytes.map((e) => [e])),
      options: Options(
        headers: {
          Headers.contentLengthHeader: avatarBytes.length, // set content-length
        },
      ),
    );
  }

  Future<Response> updateGroup(int gid, GroupUpdateRequest req) async {
    final dio = DioUtil.token(baseUrl: _baseUrl);
    return dio.put("/$gid", data: req);
  }

  Future<Response> leaveGroup(int gid) async {
    final dio = DioUtil.token(baseUrl: _baseUrl);
    return dio.get("/$gid/leave");
  }
}