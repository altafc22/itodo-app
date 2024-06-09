class ErrorResponse {
  String? error;
  int? errorcode;
  String? errortag;
  int? httpcode;

  ErrorResponse({this.error, this.errorcode, this.errortag, this.httpcode});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorcode = json['error_code'];
    errortag = json['error_tag'];
    httpcode = json['http_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['error_code'] = errorcode;
    data['error_tag'] = errortag;
    data['http_code'] = httpcode;
    return data;
  }
}
