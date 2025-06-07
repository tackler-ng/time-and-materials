# vim: tabstop=4 shiftwidth=4 softtabstop=4 smarttab expandtab autoindent

exe_dir=$(readlink -f $(dirname $(realpath $0)))

. $exe_dir/time_filter.sh

billing_filter () {
    local client=$1
    local begin=$2
    local end=$3

    flt=$(cat << EOF | base64 --wrap=0
{
    "txnFilter" : {
        "TxnFilterAND" : {
            "txnFilters" : [
                $(time_span_body $begin $end)
                ,
                {
                    "TxnFilterPostingAmountGreater" : {
			            "regex" : "Billing:$client:.*",
			            "amount" : 0
                    }
                },
                {
                    "TxnFilterPostingAmountLess" : {
			            "regex" : "Client:$client:.*",
			            "amount" : 0
                    }
                }
            ]
        }
    }
}
EOF
)
    echo "base64:$flt"
}

if [ $# != 3 ]; then
    echo "usage: $0 <client> <begin date / timestamp> <end date / timestamp>"
    exit 1
fi

client=$1


# convert date to timestamp with offset
begin=$(date --utc --date="$2" --iso-8601=s)
end=$(date --utc --date="$3" --iso-8601=s)


billing_filter "$client" $begin $end
