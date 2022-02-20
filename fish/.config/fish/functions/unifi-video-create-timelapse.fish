# Combines all the small video files collected by the `unifi-video-collect` script into one file,
# and then creates a timelapse video file.
function unifi-video-create-timelapse --argument-names unifi_videos_dir output_text
    string length --quiet "$unifi_videos_dir"
    or return 1

    string length --quiet "$output_text"
    or return 1

    set listfile (mktemp --suffix ".txt")
    for f in $unifi_videos_dir/*.mp4
        echo "file '$f'" >>$listfile
    end
    ffmpeg -f concat -safe 0 -i $listfile -c copy $unifi_videos_dir/$output_text.mp4
    ffmpeg -i "$unifi_videos_dir/$output_text.mp4" -filter:v "setpts=0.05*PTS" -an "$unifi_videos_dir/$output_text_timelapse.mp4"
end
