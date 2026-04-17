abstract class AddBaseAccount {
  Future<void> add(AddBaseAccountParams params);
}

class AddBaseAccountParams {
  final int userId;
  final int classId;

  AddBaseAccountParams({
    required this.userId,
    required this.classId,
  });

  Map toMap() => {
        'user_id': userId,
        'class_id': classId,
      };
}
