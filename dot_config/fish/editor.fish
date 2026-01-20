#!/usr/bin/env fish
# Editor and AI tool abbreviations

if status is-interactive
    # Editor abbreviations
    abbr --add z. 'zed .'
    abbr --add nv. 'nvim .'
    abbr --add hx. 'hx .'

    # Claude Code
    abbr --add cl 'claude'
    abbr --add clc 'claude --continue'
    abbr --add codexy 'codex --yolo'
end
