class GlobalState {
  Map _toDos = {'main': [], 'archived': [], 'history': []};

  static GlobalState instance = new GlobalState._();
  GlobalState._();

  set(dynamic key, dynamic value) => _toDos[key] = value;
  get(key) => _toDos[key];
}
