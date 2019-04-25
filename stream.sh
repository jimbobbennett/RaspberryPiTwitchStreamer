# Create pipes for the audio and video streams
mkfifo /tmp/streamaudio.wav
mkfifo /tmp/streamvideo

# Pipe the audio to the audio pipe
# pipe the video to the video pipe
# Combine these pipes and stream to ffmpeg
arecord -D plughw:1 -f s16 -r 22050 -d 0 --buffer-size=1000000 > /tmp/streamaudio.wav &
raspivid -t 0 -fps 25 -p 0,0,400,400 -b 2000000 -o - > /tmp/streamvideo &
ffmpeg -thread_queue_size 512 -r 30 -i /tmp/streamvideo -thread_queue_size 512 -i /tmp/streamaudio.wav -acodec libmp3lame -codec copy -strict experimental -acodec mp3 -ar 44100 -b:a 128k -b:v 1500k -threads 2 -fflags nobuffer -f flv $1