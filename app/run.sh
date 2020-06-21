#!/bin/bash

HDR="${HDR:-/data/hdr.mkv}"
TMP="${TMP:-/data/sdr_tmp.mkv}"
FINAL="${FINAL:-/data/sdr_final.mkv}"

# HDR -> SDR 1080p h264 (video only)
ffmpeg -y -i ${HDR} -c copy -an -vf zscale=t=linear:npl=100,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=2,zscale=t=bt709:m=bt709:r=tv,format=yuv420p,zscale=h=1080:w=-1 -c:v libx264 -preset slower -crf 12 -max_muxing_queue_size 9999 -threads 8  ${TMP}

# Find all the default tracks of the HDR mkv container
ADD_DEFAULTS=
DEFAULT_TRACKS=$(mkvmerge -i -F json ${HDR} | jq '.tracks[] | select(.properties.default_track == true) | .id')

for track in $DEFAULT_TRACKS; do
  ADD_DEFAULTS="${ADD_DEFAULTS} --default-track ${track}:yes"
done

# Merge the SDR video and the rest of the HDR container (except HDR video)
mkvmerge --output "${FINAL}" --no-audio --no-subtitles --no-buttons --no-attachments --no-track-tags --no-global-tags --no-chapters --default-track 0:yes "(" "${TMP}" ")" --no-video $ADD_DEFAULTS "(" "${HDR}" ")"

# Outputs a json description of all tracks
# mkvmerge -i -F <file>
