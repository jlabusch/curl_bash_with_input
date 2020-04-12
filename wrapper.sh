#!/usr/bin/env bash

TEMP=$(tempfile)
echo "Downloading script.sh as ${TEMP}"
curl -sL https://raw.githubusercontent.com/jlabusch/curl_bash_with_input/master/script.sh -o ${TEMP}
chmod 755 ${TEMP}

echo "Executing script.sh"
exec ${TEMP} --fix-stdin
