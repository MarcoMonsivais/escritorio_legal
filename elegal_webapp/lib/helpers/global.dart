String role = '', userName = '';

class ProblemList {
  final String id;
  final String description;

  ProblemList({required this.id, required this.description});

  @override
  String toString() => id;

  @override
  operator ==(o) => o is ProblemList && o.id == id;

  @override
  int get hashCode => id.hashCode^id.hashCode;

}

class RequestItem {

  final String cateroy;
  final String description;
  final String name;
  final String phone;

  RequestItem({required this.cateroy, required this.description, required this.name, required this.phone});

}