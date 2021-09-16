errorList(int code) {
  if (code == 200) {
    return 'OK';
  } else if (code == 201) {
    return 'Created';
  } else if (code == 202) {
    return 'Accepted';
  } else if (code == 204) {
    return 'No Content';
  } else if (code == 300) {
    return 'Multiple Choices';
  } else if (code == 301) {
    return 'Moved Permanently';
  } else if (code == 302) {
    return 'Found';
  } else if (code == 303) {
    return 'See Other';
  } else if (code == 304) {
    return 'Not Modified';
  } else if (code == 307) {
    return 'Temporary Redirect';
  } else if (code == 400) {
    return 'Bad Request';
  } else if (code == 401) {
    return 'Unauthorized';
  } else if (code == 403) {
    return 'Forbidden';
  } else if (code == 404) {
    return 'Not Found';
  } else if (code == 405) {
    return 'Method Not Allowed';
  } else if (code == 406) {
    return 'Not Acceptable';
  } else if (code == 412) {
    return 'Precondition Failed';
  } else if (code == 415) {
    return 'Unsupported Media Type';
  } else if (code == 500) {
    return 'Internal Server Error';
  } else if (code == 501) {
    return 'Not Implemented';
  }
}
