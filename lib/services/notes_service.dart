import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/note.dart';

class NotesService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Note>> getNotes() async {
    final response = await _supabase
        .from('notes')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((json) => Note.fromJson(json)).toList();
  }

  Future<Note> createNote({
    required String title,
    required String content,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await _supabase
        .from('notes')
        .insert({
          'user_id': userId,
          'title': title,
          'content': content,
        })
        .select()
        .single();

    return Note.fromJson(response);
  }

  Future<Note> updateNote({
    required String id,
    required String title,
    required String content,
  }) async {
    final response = await _supabase
        .from('notes')
        .update({
          'title': title,
          'content': content,
        })
        .eq('id', id)
        .select()
        .single();

    return Note.fromJson(response);
  }

  Future<void> deleteNote(String id) async {
    await _supabase.from('notes').delete().eq('id', id);
  }

  Stream<List<Note>> watchNotes() {
    return _supabase
        .from('notes')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Note.fromJson(json)).toList());
  }
}