# vim: tabstop=4 shiftwidth=4 softtabstop=4 smarttab expandtab autoindent

exe_dir=$(readlink -f $(dirname $(realpath $0)))

. $exe_dir/time_filter.sh

if [ $# != 2 ]; then
    echo "usage: $0 <begin date / timestamp> <end date / timestamp>"
    exit 1
fi

# convert date to timestamp with offset
begin=$(TZ=UTC date --utc --date="$1" --iso-8601=s)
end=$(TZ=UTC date --utc --date="$2" --iso-8601=s)


time_span_filter $begin $end
