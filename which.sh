usage() {
    echo "usage: which [-a] name ..."
}

while getopts "a" option; do
    case "$option" in
        a) all=`true`
            ;;
        ?) usage && exit 1
            ;;
    esac
done    

shift $(($OPTIND-1))
[ "$#" == 0 ] && usage && exit 1

size=$#
found=0
path="$PATH"

default_path="/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin"

if [ -z "$path" ]; then
    path="$default_path"
fi

for cmd in $@; do
    foundfor=0
    if [[ "$cmd" == *"/"* ]]; then
        if [ -x "$cmd" ]; then
                echo "$cmd";
                foundfor=1
        fi
    else
        IFS=':'; for spath in $path; do
            spath=`echo $spath | sed -E 's/(.*[^/])[/]*/\1/'`
            if [ -x "$spath/$cmd" ]; then 
                echo "$spath/$cmd";
                foundfor=$(($foundfor+1))
                if [ ! $all ]; then
                    break
                fi
            fi
        done
    fi
    if [ "$foundfor" -ne "0" ]; then
        found=$(($found+1))
    else 
        echo "which: $cmd: Command not found." >&2
    fi
done


res=0
if [ "$found" -eq "$size" ]; then
    exit 0
elif [ "$found" -ne 0 ]; then
    exit 1
else 
    exit 2
fi
