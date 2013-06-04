# API PEGjs

A collection of PEG parsers for HTTP, API and related syntaxes


# Parsers

```coffee
apiPEG = require 'api-pegjs'

apiPEG.module.parser input
```

where `module.parser` can be

* http
  * version
  * method
  * start_line
  * header_field
  * status_line
  * status_code
  * date
* httpHeader
  * Tranfer_Encoding
  * TE
  * Host
  * Via
  * Connection
  * Upgrade
  * Content_Type
  * Content_Encoding
  * Content_Language
  * Content_Location
  * Expect
  * Max_Forwards
  * Accept
  * Accept_Charset
  * Accept_Encoding
  * Accept_Language
  * From
  * Referer
  * User_Agent
  * Date
  * Location
  * Retry_After
  * Vary
  * Allow
  * Server
* uri
* media_type
* charset
* language

# License

MIT
