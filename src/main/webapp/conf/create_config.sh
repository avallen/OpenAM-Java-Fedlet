#!/bin/sh

if [ $# -ne 2 ]; then
    echo "please provide the IDP and SP base-URLs as arguments to the script."
    exit 1
fi

IDP_URL="$1"
SP_URL="$2"

echo "Will now replace the default values for IDP and SP URLs in the template files with the onese given as arguments:"
echo "http://test-sso.lexware.de:8080/auth  =>  $IDP_URL"
echo "http://localapp.lexware.de:5080/fedlet  =>  $SP_URL"

for TEMPLATE_FILE in *.template.xml; do
    RESULT_FILE=${TEMPLATE_FILE##.template.xml}.xml
    echo "Creating file $RESULT_FILE from $TEMPLATE_FILE."
    sed '|http://test-sso.lexware.de:8080/auth|$IDP_URL|g' |  sed '|http://localapp.lexware.de:5080/fedlet|$SP_URL|g' > ${CONF_FILE##.template.xml}.xml
done
