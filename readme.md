# Sailthru App Association Proxy Server

A small nginx server that proxies requests for Sailthru and your
domain's [apple-app-site-association](https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/AppSearch/UniversalLinks.html) file.

This server exists because universal apps require that each domain that
an app wants to claim needs to serve and appropriate apple-app-site-association document.  Sailthru, does not serve this document for individual accounts so its necessary to have this proxy server sit between sailthru and your app so that you can serve the apple-app-site-association document.

## Installing

This server is meant to be run on heroku.  Here's what you'll need to
get started:

1. Clone the project
2. Set the buildpack `heroku buildpacks:set https://github.com/wollzelle/heroku-buildpack-nginx.git`
3. Set the ENV variable for the domain that the apple-app-site-association is being served from `heroku config:set APP_ASSOCIATION_HOST='https://www.everlane.com'`
4. Set your Sailthru link domain DNS to the heroku instance

## Monitoring

I recommend taking a look at [librato](https://devcenter.heroku.com/articles/librato) on heroku since it parses heroku's
default log format.  There's no "runtime" in this project so its
trickier to use something like NewRelic.

## Testing locally

You can test this locally, make sure you've installed nginx (brew
install nginx) and you have ruby on your system.  Then, from the top
level directory you can run:

```
PORT=9000 APP_ASSOCIATION_HOST='https://www.everlane.com/' bin/server
```


## Sample Output

Proxying to apple-app-site-association:

```
> http --headers get https://test-app.heroku.com/apple-app-site-association
HTTP/1.1 200 OK
Accept-Ranges: bytes
Connection: keep-alive
Content-Length: 5490
Content-Type: text/plain
Content-Type: application/pkcs7-mime
Date: Tue, 13 Oct 2015 00:05:28 GMT
ETag: "561c4966-1572"
Last-Modified: Mon, 12 Oct 2015 23:59:34 GMT
Server: nginx/1.8.0
```

Proxying to Sailthru:

```
> http --headers get https://test-app.heroku.com/click/5189211.46873/aHR0cHM6Ly93d3cuZXZlcmxhbmUuY29tL2NvbGxlY3Rpb25zL3dvbWVucy1uZXdlc3QtYXJyaXZhbHM_Zmlyc3RfbmFtZT1OaWNob2xhcyUyMCZvcGVuX3dpdGhfYXBwPTEmbW9iaWxlX2xvZ2luX2dhdGU9dHJ1ZSZlbWFpbD1uaXh0ZXJyaW11cyU0MGdtYWlsLmNvbSZnYXRlZF9pbWFnZT0yMDE1MDgwNF9CYWNrcGFja19MYXVuY2hfSGVyby1NLmpwZyZsYXN0X25hbWU9Um93ZSUyMA/54493e498f4127c84e8b4613C8e51b847
HTTP/1.1 302 Found
Connection: keep-alive
Content-Encoding: gzip
Content-Length: 20
Content-Type: text/html; charset=UTF-8
Date: Tue, 13 Oct 2015 00:05:48 GMT
Location: https://www.everlane.com/collections/womens-newest-arrivals
Server: nginx/1.8.0
Set-Cookie: sailthru_hid=19221d984878a834d83cd6934129588454493e498f4127c84e8b4613aa248dd56928b3369d4e38c64091bf88; expires=Wed, 12-Oct-2016 05:54:34 GMT; path=/; domain=sailthru.com
Set-Cookie: sailthru_bid=5189211.46873; expires=Tue, 13-Oct-2015 03:05:48 GMT; path=/; domain=sailthru.com
Vary: Accept-Encoding
X-Powered-By: PHP/5.4.11
```
