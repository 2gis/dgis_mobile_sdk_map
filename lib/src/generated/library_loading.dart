part of dart_bindings;

class _LibraryProvider {
  ffi.DynamicLibrary? _sdkLibrary;

  // Lazily initialized DynamicLibrary getter.
  ffi.DynamicLibrary get sdkLibrary =>
      _sdkLibrary ??= Platform.isIOS ? ffi.DynamicLibrary.process() : ffi.DynamicLibrary.open(_libraryFullName);

  String get _libraryFullName => _libraryFullNameGetter();

  // Setter for updating the function that provides the library's full name.
  set libraryFullNameGetter(String Function() newLibraryFullNameGetter) {
    _libraryFullNameGetter = newLibraryFullNameGetter;
    _sdkLibrary = null;
  }

  // Store the function that provides the library's full name.
  String Function() _libraryFullNameGetter = _defaultGetLibraryFullName;

  static String _defaultGetLibraryFullName() {
    if (Platform.isAndroid) {
      return 'libdgis_c_bindings_android.so';
    } else if (Platform.isLinux) {
      return 'libdgis_c_bindings_linux.so';
    } else {
      throw UnsupportedError(
        'Unsupported platform ${Platform.operatingSystem}',
      );
    }
  }
}

@visibleForTesting
final libraryProvider = _LibraryProvider();
