#!/bin/sh
echo "/**********************************************"
echo "/* Author: BH_Lin"
echo "/* Tool to download videos for Demo"
echo "**********************************************/"
fileHost="https://my.cdn.tokyo-hot.com/media/samples/"
webHost="https://www.tokyo-hot.com/product/"
fileExtension=".mp4"

STARTED_INDEX_NUMBER=1157
MAX_INDEX_NUMBER=2999
fileIndex=${STARTED_INDEX_NUMBER}
prefixText=""

outputFile="sampleVideos.json"

if [ -f "${outputFile}" ]; then
    rm -f "${outputFile}"
fi

echo "[" >"${outputFile}"

while [ ${fileIndex} -le ${MAX_INDEX_NUMBER} ]; do
    fileName="n${fileIndex}${fileExtension}"
    videoSrc="${fileHost}${fileName}"
    echo "► Ready to download: ${videoSrc}"
    [ -f "${fileName}" ] && rm -f ${fileName}
    wget ${videoSrc}

    if [ -f "${fileName}" ]; then

        filePath="n${fileIndex}"
        webPage="${webHost}${filePath}"
        echo "► Ready to download ${webPage}"
        [ -f "index.html" ] && rm -f "index.html"
        wget ${webPage} -O index.html

        posterUrl=$(cat "index.html" | grep -i -E "poster" | sed 's/.*=\"//g' | sed 's/\">.*//g')
        posterFileName="${filePath}.jpg"
        [ -f "${posterFileName}" ] && rm -f "${posterFileName}"
        echo "► Ready to download poster ${posterUrl}"
        wget ${posterUrl} -O "${posterFileName}"

        title=$(cat index.html | grep -i -E "<title" | sed 's/.*<title>//g' | sed 's/<\/title>//g')
        echo ">---------------------------------------------------------------->"
        echo "title: ${title}"
        echo "src: ${fileName}"
        echo "poster: ${posterFileName}"
        echo "<----------------------------------------------------------------<\n"
        echo "${prefixText}{ \"title\": \"${title}\",  \"src\": \"${fileName}\", \"poster\": \"${posterFileName}\"}" >>"${outputFile}"
        prefixText=","
    fi

    ((fileIndex++))
done

echo "]" >>"${jsonFile}"
