class AuthState{
  final String errorMessage;
  final bool isSuccess;
  final bool isLoad;
  final bool isLogOut;

  AuthState({
    required this.errorMessage, required this.isLoad, required this.isSuccess,required this.isLogOut
});

  AuthState copyWith({bool? isLoad, String? errorMessage, bool? isSuccess, bool? isLogOut}){
    return AuthState(
      errorMessage: errorMessage ?? this.errorMessage,
      isLoad: isLoad ?? this.isLoad,
      isSuccess : isSuccess ?? this.isSuccess,
        isLogOut: isLogOut ?? this.isLogOut
    );
  }

  factory AuthState.empty(){
    return AuthState(errorMessage: '', isLoad: false, isSuccess: false, isLogOut: false);
  }
}