#!/bin/bash
set -e

echo -n "$CERTIFICATE" | base64 -w 0 --decode > ./cognite_code_signing.pfx


osslver="$(openssl version)"
if [[ "$osslver" == "OpenSSL 3"* ]]; then
    # Convert the pkcs12 file into a compatible format by passing it through openssl...
    # Technically the sign tool is also based on openssl, but it doesn't let you set the "legacy" flag,
    # so we have to convert it using openssl first.
    # Note that this is dependent on the version of openssl, and the type of certificate.
    # This works for the cognite code certificate
    openssl pkcs12 -in ./cognite_code_signing.pfx -out ./cognite_code_signing.pem -legacy \
        -passin "pass:$CERTIFICATE_PASSWORD" -passout "pass:$CERTIFICATE_PASSWORD"
    openssl pkcs12 -in ./cognite_code_signing.pem \
        -keypbe PBE-SHA1-3DES -certpbe PBE-SHA1-3DES \
        -export -out ./cognite_code_signing_2.pfx \
        -passin "pass:$CERTIFICATE_PASSWORD" -passout "pass:$CERTIFICATE_PASSWORD"
    mv ./cognite_code_signing_2.pfx ./cognite_code_signing.pfx
    rm ./cognite_code_signing.pem
fi

recurse=false
file_path="$1"

for var in "$@"; do
    if [ "$var" = "-Recurse" ] ; then
        recurse=true
    fi
done

if [ $recurse = true ] ; then
    echo "Sign all files in folder $file_path"
    for f in $(find $file_path -type f); do
        osslsigncode sign -pkcs12 ./cognite_code_signing.pfx -pass "$CERTIFICATE_PASSWORD" \
            -t "http://timestamp.digicert.com" \
            -in "$f" -out "$f.signed"
        mv "$f.signed" "$f"
    done
else
    echo "Sign a single binary"
    osslsigncode sign -pkcs12 ./cognite_code_signing.pfx -pass "$CERTIFICATE_PASSWORD" \
        -t "http://timestamp.digicert.com" \
        -in "$file_path" -out "$file_path.signed"
    mv "$file_path.signed" "$file_path"
fi

rm ./cognite_code_signing.pfx
