class GlobalState {
  // this is what the map should be and this is what I'm trying to save as a json
  Map _toDos = {'main': [], 'archived': [], 'history': []};

  // this sets the global state
  static GlobalState instance = new GlobalState._();
  GlobalState._();

  // this sets the value of something that was changed in the global state across pages
  set(dynamic key, dynamic value) {
    _toDos[key] = value;
  }

  // this gets the value across pages
  get(key) => _toDos[key];
}
