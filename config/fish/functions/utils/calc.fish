function calc --description 'Calculator with interactive mode support'
    if test (count $argv) -eq 0
        python3 -ic 'from math import *; import sys; sys.ps1="calc> "'
    else
        python3 -c "from math import *; print($argv)"
    end
end