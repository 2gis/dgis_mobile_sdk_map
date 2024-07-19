class NativeException implements Exception {
  final String _description;

  NativeException(this._description);

  @override
  String toString() {
    return this._description;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NativeException &&
            runtimeType == other.runtimeType &&
            this._description == other._description;
  }

  @override
  int get hashCode => this._description.hashCode;
}
