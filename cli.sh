#!/bin/bash
  
echo "Welcome to the CLI! \
Please use '-p initialise' if it's your first time. \
This CLI must be run in the directory folder of the cloned repository."
usage() { echo "Usage: $0 \
[-h help] \
[-p run program <initialise|path_to_file>] \
[-a arguments] \
[-n run jupyter notebook]" 1>&2; exit 1; }

port=$(shuf -i8000-9999 -n1)
node=$(hostname -s)

while getopts ":hp:a:n" opt; do
    case ${opt} in
        h)
            usage
        ;;
        p)
            p=${OPTARG}
        ;;
        a)
            a+=("${OPTARG}")
        ;;
        n)
            jupyter notebook --port=${port} --ip=${node}
        ;;
        \?)
            echo "Invalid option"
            usage
        ;;
    esac
done
shift $((OPTIND-1))

# Download data and install main code
if [[ "initialise" == "${p}" ]]; then
    bash get_data.sh
    pip install -e .
    exit 0
fi

# Run Python Program
if [[ -z "${p}" ]]; then
    usage
else
    python3 -u "${p}" "${a[@]}"
fi