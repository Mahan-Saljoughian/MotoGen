import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:motogen/core/services/api_service.dart';

class ChatRepository {
  final ApiService _api = ApiService();
  var logger = Logger();

  Future<Map<String, dynamic>> createSession(String prompt) async {
    try {
      final response = await _api.post("users/me/chat-session", {
        "prompt": prompt,
      });

      /* if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to create chat session');
      } */
      debugPrint("debug the repsonse in createSession is $response");
      response['success'] = false;
      return response;
    } catch (e) {
      logger.e("Error creating chat session ");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllSessions() async {
    try {
      final response = await _api.get('users/me/chat-session');
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to get chat sessions');
      }
      debugPrint(
        "debug the repsonse in getAllSessions is ${List<Map<String, dynamic>>.from(response['data'] ?? [])}",
      );
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      logger.e("Error fetching chat sessions");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getSessionMessages(
    String sessionId,
  ) async {
    try {
      final response = await _api.get('users/me/chat-session/$sessionId');
      if (response['success'] != true) {
        throw Exception(
          response['message'] ?? 'Failed to get session messages',
        );
      }
      debugPrint(
        "debug the repsonse in getSessionMessages is ${List<Map<String, dynamic>>.from(response['data'] ?? [])}",
      );
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      logger.e("Error fetching chat messages for sessionId: $sessionId");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendMessage(
    String sessionId,
    String prompt,
  ) async {
    try {
      final response = await _api.post('users/me/chat-session/$sessionId', {
        "prompt": prompt,
      });
      /*  if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to send chat message');
      } */
      debugPrint("debug the repsonse in sendMessage is $response");
      return response;
    } catch (e) {
      logger.e("Error sending message to sessionId: $sessionId");
      rethrow;
    }
  }
}
