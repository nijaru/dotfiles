#!/usr/bin/env fish
# Editor abbreviations - only load after env.fish ensures $EDITOR is set

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
end
