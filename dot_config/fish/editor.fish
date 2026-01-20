#!/usr/bin/env fish
# Editor and AI tool abbreviations

if status is-interactive
    # Editor abbreviations
    abbr --add z. 'zed .'
    abbr --add nv. 'nvim .'
    abbr --add hx. 'hx .'

    # agents
    abbr --add cl 'claude'
    abbr --add clc 'claude --continue'
    abbr --add gemy 'gemini --yolo'
    abbr --add codexy 'codex --yolo'
end
