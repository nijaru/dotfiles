function __maybe_load_gcp --on-event fish_preexec
    if string match -rq "(gcloud|gsutil|gemini|gcp)" -- $argv[1]
        if not set -q GOOGLE_CLOUD_PROJECT
            set -gx GOOGLE_CLOUD_PROJECT (gcloud config get-value project 2>/dev/null)
        end
    end
end