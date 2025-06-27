function flac2wav --description 'Convert FLAC files to WAV'
    for file in *.flac
        # Skip if no flac files are found
        if test ! -e "$file"
            continue
        end
        
        set -l wav_file (string replace -r '\.flac$' '.wav' "$file")
        if test ! -f "$wav_file"
            echo "Converting $file to $wav_file"
            ffmpeg -i "$file" "$wav_file"
        else
            echo "Skipping $file, $wav_file already exists"
        end
    end
end