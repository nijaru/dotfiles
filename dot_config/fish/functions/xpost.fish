function xpost --description "Fetch X/Twitter post content by URL"
    if test (count $argv) -eq 0
        echo "Usage: xpost <url>"
        return 1
    end

    yt-dlp --dump-json $argv[1] 2>/dev/null \
        | jq '{text: .description, author: .uploader, handle: .uploader_id, date: .upload_date, likes: .like_count, reposts: .repost_count, url: .webpage_url}'
end
