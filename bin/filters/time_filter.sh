# vim: tabstop=4 shiftwidth=4 softtabstop=4 smarttab expandtab autoindent
#
# Tackler-NG 2017-2025
# SPDX-License-Identifier: Apache-2.0
#

sh_date () {
    date --utc "$@"
}

#
# Time Span filter body
#
# This is just body and 
# could be included into other filters
#
time_span_body () {
    local begin=$1
    local end=$2

    cat << EOF
         {
             "TxnFilterTxnTSBegin" : {
                 "begin" : "$begin"
             }
         },
    	{
            "TxnFilterTxnTSEnd" : {
            	"end" : "$end"
            }
        }
EOF
}

# Time Span filter 
#
# This is full filter
#
# 1: begin ts
# 2: end ts
time_span_filter () {
    local begin=$1
    local end=$2

    flt=$(cat << EOF | base64 --wrap=0
{
    "txnFilter" : {
        "TxnFilterAND" : {
            "txnFilters" : [
                $(time_span_body $begin $end)
            ]
        }
    }
}
EOF
)
    echo "base64:$flt"
}

# Time Window filters
#
# This is full filter and accepts `date` span descriptions 
#
# 1: Start date
# 2: Time window "+1 month"
time_window_filter () {
    local ts1=$(sh_date --date=$1 --iso-8601=s)
    local ts2=$(sh_date --date="$ts1 $2" --iso-8601=s)

    local begin=$(echo -e "$ts1\n$ts2" | sort -n | head -n1)
    local end=$(echo   -e "$ts1\n$ts2" | sort -n | tail -n1)

    time_span_filter "$begin" "$end"
}


