# API PEGjs

A collection of PEG parsers for HTTP, API and related syntaxes


# Parsers

```coffee
apiPEG = require 'api-pegjs'

apiPEG.module.parser input
```

where `module.parser` can be

* http
  * header_field
  * message
  * method
  * request_line
  * request_target
  * status_code
  * status_line
  * version
* httpHeader
  * Accept
  * Accept_Charset
  * Accept_Encoding
  * Accept_Language
  * Allow
  * Connection
  * Content_Encoding
  * Content_Language
  * Content_Location
  * Content_Type
  * Date
  * Expect
  * From
  * Host
  * Location
  * Max_Forwards
  * Referer
  * Retry_After
  * Server
  * TE
  * Tranfer_Encoding
  * Upgrade
  * User_Agent
  * Vary
  * Via
* uri
* media_type
* charset
* language

# License

MIT
