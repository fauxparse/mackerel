# mackerel
Derpy web server for Explosion Monday

## Example Request/Response pair
```
GET /index.html HTTP/1.0
User-Agent: MyBrowser/1.0

_______________________________________

HTTP/1.0 200 OK 
Content-Type: text/html
Content-Length: 145
<!DOCTYPE html>
<html>
<head>
  <title>Hello HTTP</title>
</head>
<body>
  <h1>HELLO WORLD</h1>
  <p>My first HTTP request.</p>
</body>
</html>
```

## Requests
```
Full-Request   = Request-Line              ; Section 5.1
                 *( General-Header         ; Section 4.3
                  | Request-Header         ; Section 5.2
                  | Entity-Header )        ; Section 7.1
                 CRLF
                 [ Entity-Body ]           ; Section 7.2
```

#### Request-Line:
```
Method SP Request-URI SP HTTP-Version CRLF
```
For example:
```
GET / HTTP/1.1\r\n
```

#### General-Header
```
General-Header = Date                     ; Section 10.6
               | Pragma                   ; Section 10.12
```

#### Request-Header
```
Request-Header = Authorization            ; Section 10.2
               | From                     ; Section 10.8
               | If-Modified-Since        ; Section 10.9
               | Referer                  ; Section 10.13
               | User-Agent               ; Section 10.15
```

#### Methods
- GET:
The GET method means retrieve whatever information (in the form of an entity) is identified by the Request-URI.

- HEAD:
The HEAD method is identical to GET except that the server must not return any Entity-Body in the response. 

- POST:
The POST method is used to request that the destination server accept the entity enclosed in the request as a new subordinate of the resource identified by the Request-URI in the Request-Line. 

## Respones
```
 Full-Response   = Status-Line              ; Section 6.1
                   *( General-Header        ; Section 4.3
                    | Response-Header       ; Section 6.2
                    | Entity-Header )       ; Section 7.1
                   CRLF
                   [ Entity-Body ]          ; Section 7.2
```

#### Status-Line:
```
HTTP-Version SP Status-Code SP Reason-Phrase CRLF
```
For example:
```
HTTP/1.1 200 OK\r\n
```

#### Full range of status codes & phrases:
```
 Status-Code    = "200"   ; OK
                | "201"   ; Created
                | "202"   ; Accepted
                | "204"   ; No Content
                | "301"   ; Moved Permanently
                | "302"   ; Moved Temporarily
                | "304"   ; Not Modified
                | "400"   ; Bad Request
                | "401"   ; Unauthorized
                | "403"   ; Forbidden
                | "404"   ; Not Found
                | "500"   ; Internal Server Error
                | "501"   ; Not Implemented
                | "502"   ; Bad Gateway
                | "503"   ; Service Unavailable
```

#### Response-Headers
```
 Response-Header = Location                ; Section 10.11
                 | Server                  ; Section 10.14
                 | WWW-Authenticate        ; Section 10.16
```
