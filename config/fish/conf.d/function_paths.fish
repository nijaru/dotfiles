# Add function subdirectories to function path
# This allows Fish to autoload functions from the subdirectories

set -l function_dirs editor fs git homebrew kubernetes modern-cli navigation utils docker

for dir in $function_dirs
    set -p fish_function_path $__fish_config_dir/functions/$dir
end
