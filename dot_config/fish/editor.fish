#!/usr/bin/env fish
# Editor and AI tool abbreviations

if status is-interactive
    # Editor abbreviations
    abbr --add e $EDITOR
    abbr --add z 'zed'
    abbr --add z. 'zed .'
    abbr --add zp 'zed --preview'
    abbr --add zp. 'zed --preview .'
    abbr --add c. 'code .'
    abbr --add v. 'nvim .'
    abbr --add hx. 'helix .'

    # Claude Code
    abbr --add cl 'claude'
    abbr --add clc 'claude --continue'
end
