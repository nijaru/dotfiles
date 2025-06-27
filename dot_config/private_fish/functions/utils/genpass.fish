function genpass --description 'Generate secure password'
    set -l length $argv[1]
    test -z "$length"; and set length 32
    
    if test "$length" -lt 8
        echo "Password length must be at least 8 characters" >&2
        return 1
    end
    
    LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c $length
    echo
end