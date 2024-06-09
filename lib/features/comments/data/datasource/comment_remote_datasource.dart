import 'dart:convert';

import 'package:itodo/common/extensions/app_extension.dart';
import 'package:itodo/common/utils/log_utils.dart';
import '../../../../common/errors/error_response.dart';
import '../../../../common/errors/exceptions.dart';
import '../../../../common/network/api_client.dart';
import '../../../../common/network/api_config.dart';
import '../../domain/usecase/add_comment.dart';
import '../model/comment_model.dart';

abstract interface class CommentRemoteDataSource {
  Future<CommentModel> add(AddCommentParams name);

  Future<List<CommentModel>> getAll(String taskId);
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final ApiClient api;
  CommentRemoteDataSourceImpl(this.api);

  @override
  Future<CommentModel> add(AddCommentParams params) async {
    try {
      var response = await api.post(
        endpoint: ApiConfig.comments,
        body: jsonEncode(params.toJson()),
      );
      printInfo(response.body);
      if (response.statusCode.success) {
        return CommentModel.fromJson(jsonDecode(response.body));
      } else {
        var error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw ServerException(error.error ?? 'Error occured');
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<CommentModel>> getAll(taskId) async {
    try {
      var response =
          await api.get(endpoint: "${ApiConfig.comments}/?task_id=$taskId");

      if (response.statusCode.success) {
        var projects = (jsonDecode(response.body) as List)
            .map((data) => CommentModel.fromJson(data))
            .toList();
        return projects;
      } else {
        var error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw ServerException(error.error ?? 'Error occured');
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }
}
