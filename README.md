# mackerel
Derpy web server for Explosion Monday

## Requests

Request-Line:
```
Method SP Request-URI SP HTTP-Version CRLF
```
For example:
```
GET / HTTP/1.1\r\n
```

## Respones

Status-Line:
```
HTTP-Version SP Status-Code SP Reason-Phrase CRLF
```
For example:
```
HTTP/1.1 200 OK\r\n
```

Full range of status codes & phrases:
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
