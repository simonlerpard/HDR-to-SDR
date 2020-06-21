# HDR to SDR converter
This is a WIP project to convert HDR video to SDR video using ffmpeg with filter zscale tonemapping.

After the conversion the SDR video will be remuxed into a mkv container with all the original content from the HDR source, except for the actual HDR video.

## Build
```
docker build -t simonlerpard/hdr-to-sdr:latest .
```

## Run
```
docker run -d --rm -v ${PWD}/data:/data simonlerpard/hdr-to-sdr:latest
```

## Custom env variables
```
HDR=/data/hdr.mkv
TMP=/data/sdr_tmp.mkv
FINAL=/data/sdr_final.mkv
```

## Progress / logs
Check the docker logs for progress and/or errors
