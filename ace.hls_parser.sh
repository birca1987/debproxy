#!/bin/sh

path=`dirname $0`
parser="/usr/bin/jq"
filepath="/mnt/media/playlists"

playlist_url="http://pomoyka.win/trash/ttv-list/ttv.json"
json="$filepath/m3u/as.json"
outdir="$filepath/m3u"

header="#EXTM3U"
newline="ZFZFaZZZ"
pron="Эротика"

url_prefix="http://192.168.0.x:6878/ace/getstream?id="
url_prefix1="http://192.168.0.x:6878/ace/manifest.m3u8?id="
url_postfix=""

mkdir -p $filepath >> /dev/null 2>&1
mkdir $filepath/m3u >> /dev/null 2>&1

rm $json >> /dev/null 2>&1
wget $playlist_url -O $json

data=`cat $json |$parser  '.channels|=sort_by(.cat,.name)'`
size=`echo $data |$parser  '.channels|length'`

if [ $size -gt 1 ]
then
  param="'.channels|=sort_by(.cat,.name)|.channels[]|select(.cat = \"$pron\")|\"#EXTINF:-1 group-title=\\\"\"+.cat+\"\\\", \"+.name+\"$newline\"+\"$url_prefix\"+.url+\"$url_postfix\"'|sed 's/$newline/\n/g'"
  eval "echo \$header; echo \$data | " $parser "-r" $param > $outdir/kodi.m3u
  
  param="'.channels|=sort_by(.cat,.name)|.channels[]|select(.cat = \"$pron\")|\"#EXTINF:-1 group-title=\\\"\"+.cat+\"\\\", \"+.name+\"$newline\"+\"$url_prefix1\"+.url+\"$url_postfix\"'|sed 's/$newline/\n/g'"
  eval "echo \$header; echo \$data | " $parser "-r" $param > $outdir/kod1.m3u

  param="'.channels|=sort_by(.cat,.name)|.channels[]|select(.cat = \"$pron\")|\"#EXTINF:-1, \"+.name+\" (\"+.cat+\")$newline\"+\"$url_prefix\"+.url+\"$url_postfix\"'|sed 's/$newline/\n/g'"
  eval "echo \$header; echo \$data | " $parser "-r" $param > $outdir/ttv.m3u
fi
