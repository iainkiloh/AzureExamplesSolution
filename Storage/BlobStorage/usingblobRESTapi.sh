#vars setup
storage_account="kilohcosmossa"
container_name="container1"
access_key="WFuXDdDLZK6OmyeS+0Vhihd4zuaX9eCOhNRDy/utDDIvMaAL4MjPj0w0Qx60jPgk1kMvilPazHqwHIcmnxV94A=="
blob_store_url="blob.core.windows.net"
authorization="SharedKey"
storage_service_version="2011-08-18"
# Decode the Base64 encoded access key, convert to Hex (required for singing the https request).
decoded_hex_key="$(echo -n $access_key | base64 -d -w0 | xxd -p -c256)"


 # download blob
request_method="GET"
request_date=$(TZ=GMT date "+%a, %d %h %Y %H:%M:%S %Z")

# HTTP Request headers
x_ms_date_h="x-ms-date:$request_date"
x_ms_version_h="x-ms-version:$storage_service_version"

# Build the signature string
canonicalized_headers="${x_ms_date_h}\n${x_ms_version_h}"
canonicalized_resource="/${storage_account}/${container_name}/file4.txt"

string_to_sign="${request_method}\n\n\n\n\n\n\n\n\n\n\n\n${canonicalized_headers}\n${canonicalized_resource}"

# Create the HMAC signature for the Authorization header
signature=$(printf "$string_to_sign" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:$decoded_hex_key" -binary |  base64 -w0)

authorization_header="Authorization: $authorization $storage_account:$signature"

curl \
  -H "$x_ms_date_h" \
  -H "$x_ms_version_h" \
  -H "$authorization_header" \
  "https://kilohcosmossa.blob.core.windows.net/container1/file4.txt" > fileexample2.txt





 # upload blob
request_method="PUT"
request_date=$(TZ=GMT date "+%a, %d %h %Y %H:%M:%S %Z")

content_type="text/plain"
#file_length=$(wc -m fileexample.txt)
file_length=$(stat -c%s "fileexample.txt")

# HTTP Request headers
x_ms_date_h="x-ms-date:$request_date"
x_ms_version_h="x-ms-version:$storage_service_version"

# Build the signature string
canonicalized_headers="x-ms-blob-type:BlockBlob\n${x_ms_date_h}\n${x_ms_version_h}"
canonicalized_resource="/${storage_account}/${container_name}/file4.txt"

string_to_sign="${request_method}\n\n\n$file_length\n\n$content_type\n\n\n\n\n\n\n${canonicalized_headers}\n${canonicalized_resource}"

# Create the HMAC signature for the Authorization header
signature=$(printf "$string_to_sign" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:$decoded_hex_key" -binary |  base64 -w0)

authorization_header="Authorization: $authorization $storage_account:$signature"

curl -X PUT -H "x-ms-blob-type:BlockBlob" \
  -H "$x_ms_date_h" \
  -H "$x_ms_version_h" \
  -H "$authorization_header" \
  -H "Content-Length:$file_length" \
  -H "Content-Type:$content_type" \
  --data-binary "@fileexample.txt" \
  "https://kilohcosmossa.blob.core.windows.net/container1/file4.txt"



# set blob metadata
request_method="PUT"
request_date=$(TZ=GMT date "+%a, %d %h %Y %H:%M:%S %Z")

# HTTP Request headers
x_ms_date_h="x-ms-date:$request_date"
x_ms_version_h="x-ms-version:$storage_service_version"
content_length=0

# Build the signature string
canonicalized_headers="${x_ms_date_h}\nx-ms-meta-isuseful:no\n${x_ms_version_h}"
canonicalized_resource="/${storage_account}/${container_name}/file4.txt"

#string_to_sign="${request_method}\n\n\n\n\n\n\n\n\n\n\n\n${canonicalized_headers}\n${canonicalized_resource}\ncomp:metadata"
string_to_sign="${request_method}\n\n\n$content_length\n\n\n\n\n\n\n\n\n${canonicalized_headers}\n${canonicalized_resource}\ncomp:metadata"

# Create the HMAC signature for the Authorization header
signature=$(printf "$string_to_sign" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:$decoded_hex_key" -binary |  base64 -w0)

authorization_header="Authorization: $authorization $storage_account:$signature"

curl -X PUT -H "$x_ms_date_h" \
  -H "x-ms-meta-isuseful:no" \
  -H "$x_ms_version_h" \
  -H "$authorization_header" \
  -H "Content-Length:0" \
  "https://kilohcosmossa.blob.core.windows.net/container1/file4.txt?comp=metadata"



# get blob metadata (note check the response headers for the metadata - you need some user defined metadata with the blob)
request_method="GET"
request_date=$(TZ=GMT date "+%a, %d %h %Y %H:%M:%S %Z")

# HTTP Request headers
x_ms_date_h="x-ms-date:$request_date"
x_ms_version_h="x-ms-version:$storage_service_version"

# Build the signature string
canonicalized_headers="${x_ms_date_h}\n${x_ms_version_h}"
canonicalized_resource="/${storage_account}/${container_name}/file4.txt"

string_to_sign="${request_method}\n\n\n\n\n\n\n\n\n\n\n\n${canonicalized_headers}\n${canonicalized_resource}\ncomp:metadata"

# Create the HMAC signature for the Authorization header
signature=$(printf "$string_to_sign" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:$decoded_hex_key" -binary |  base64 -w0)

authorization_header="Authorization: $authorization $storage_account:$signature"

curl -v \
  -H "$x_ms_date_h" \
  -H "$x_ms_version_h" \
  -H "$authorization_header" \
  "https://kilohcosmossa.blob.core.windows.net/container1/file4.txt?comp=metadata"




# get blob properties
request_method="GET"
request_date=$(TZ=GMT date "+%a, %d %h %Y %H:%M:%S %Z")

# HTTP Request headers
x_ms_date_h="x-ms-date:$request_date"
x_ms_version_h="x-ms-version:$storage_service_version"

# Build the signature string
canonicalized_headers="${x_ms_date_h}\n${x_ms_version_h}"
canonicalized_resource="/${storage_account}/${container_name}/file4.txt"

string_to_sign="${request_method}\n\n\n\n\n\n\n\n\n\n\n\n${canonicalized_headers}\n${canonicalized_resource}"

# Create the HMAC signature for the Authorization header
signature=$(printf "$string_to_sign" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:$decoded_hex_key" -binary |  base64 -w0)

authorization_header="Authorization: $authorization $storage_account:$signature"

curl -v \
  -H "$x_ms_date_h" \
  -H "$x_ms_version_h" \
  -H "$authorization_header" \
  "https://kilohcosmossa.blob.core.windows.net/container1/file4.txt"



# get list of blobs in container
request_method="GET"
request_date=$(TZ=GMT date "+%a, %d %h %Y %H:%M:%S %Z")

# HTTP Request headers
x_ms_date_h="x-ms-date:$request_date"
x_ms_version_h="x-ms-version:$storage_service_version"

# Build the signature string
canonicalized_headers="${x_ms_date_h}\n${x_ms_version_h}"
canonicalized_resource="/${storage_account}/${container_name}"

string_to_sign="${request_method}\n\n\n\n\n\n\n\n\n\n\n\n${canonicalized_headers}\n${canonicalized_resource}\ncomp:list\nrestype:container"

# Create the HMAC signature for the Authorization header
signature=$(printf "$string_to_sign" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:$decoded_hex_key" -binary |  base64 -w0)

authorization_header="Authorization: $authorization $storage_account:$signature"

curl \
  -H "$x_ms_date_h" \
  -H "$x_ms_version_h" \
  -H "$authorization_header" \
  "https://${storage_account}.${blob_store_url}/${container_name}?restype=container&comp=list"


# acquire lease, download blob, edit it, and PUT and free the lease
# 1 get the lease
request_method="PUT"
request_date=$(TZ=GMT date "+%a, %d %h %Y %H:%M:%S %Z")

# HTTP Request headers
x_ms_date_h="x-ms-date:$request_date"
x_ms_version_h="x-ms-version:$storage_service_version"
content_length=0

# Build the signature string
canonicalized_headers="${x_ms_date_h}\nx-ms-lease-action:acquire\n${x_ms_version_h}"
canonicalized_resource="/${storage_account}/${container_name}/file4.txt"

string_to_sign="${request_method}\n\n\n$content_length\n\n\n\n\n\n\n\n\n${canonicalized_headers}\n${canonicalized_resource}\ncomp:lease"

# Create the HMAC signature for the Authorization header
signature=$(printf "$string_to_sign" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:$decoded_hex_key" -binary |  base64 -w0)

authorization_header="Authorization: $authorization $storage_account:$signature"

curl -v -X PUT -H "x-ms-lease-action:acquire" -H "$x_ms_date_h" \
  -H "$x_ms_version_h" \
  -H "$authorization_header" \
  -H "Content-Length:0" \
  "https://kilohcosmossa.blob.core.windows.net/container1/file4.txt?comp=lease"
