# Create pipes for the audio and video streams
mkfifo /tmp/streamaudio.wav
mkfifo /tmp/streamvideo

# Pipe the audio to the audio pipe
# pipe the video to the video pipe
# Combine these pipes and stream to ffmpeg
arecord -D plughw:1 -f s16 -r 44100 -d 0 --buffer-size=1000000 > /tmp/streamaudio.wav &
raspivid -n -t 0 -w 1280 -h 720 -fps 12 -b 250000 -o - > /tmp/streamvideo &
ffmpeg -thread_queue_size 4096 -i /tmp/streamvideo -thread_queue_size 4096 -itsoffset 15.0 -i /tmp/streamaudio.wav -acodec libmp3lame -codec copy -strict experimental -acodec mp3 -ar 44100 -b:a 128k -b:v 1500k -threads 2 -f flv $1