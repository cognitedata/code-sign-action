#!/bin/bash

echo -n "$CERTIFICATE" | base64 --decode > ./cognite_code_signing.pfx

recurse=false
file_path="$1"

for var in "$@"; do
    if [ "$var" = "-Recurse" ] ; then
        recurse=true
    fi
done

if [ $recurse = true ] ; then
    echo "Sign all files in folder $file_path"
    for f in $(find $file_path); do
        osslsigncode sign -pkcs12 ./cognite_code_signing.pfx -pass $CERTIFICATE_PASSWORD \
            -t http://timestamp.digicert.com \
            -in "$f" -out "$f"
    done
else
    echo "Sign a single binary"
    osslsigncode sign -pkcs12 ./cognite_code_signing.pfx -pass $CERTIFICATE_PASSWORD \
        -t http://timestamp.digicert.com \
        -in "$file_path" -out "$file_path"
fi

rm ./cognite_code_signing.pfx
