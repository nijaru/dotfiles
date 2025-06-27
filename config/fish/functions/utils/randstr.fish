function randstr --description 'Generate random string'
    set -l length $argv[1]
    set -l charset $argv[2]
    
    test -z "$length"; and set length 32
    test -z "$charset"; and set charset 'A-Za-z0-9'
    
    if test "$length" -lt 1
        echo "Length must be positive" >&2
        return 1
    end
    
    LC_ALL=C tr -dc $charset < /dev/urandom | head -c $length
    echo
end