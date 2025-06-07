#!/usr/bin/env bash
set -euo pipefail

days=$1
miles=$2
receipts=$3

# Flat per‐diem: $75/day
ALLOWANCE_PER_DAY=75.00
allowance=$(awk -v d="$days" -v r="$ALLOWANCE_PER_DAY" 'BEGIN { printf("%.2f", d * r) }')

# Mileage: $0.12/mile
MILEAGE_RATE=0.12
mileage=$(awk -v m="$miles" -v r="$MILEAGE_RATE" 'BEGIN { printf("%.2f", m * r) }')

# “Best of” lodging+meals: max(actual receipts, flat per‐diem)
core=$(awk -v rc="$receipts" -v al="$allowance" \
            'BEGIN { printf("%.2f", (rc > al ? rc : al)) }')

# Total reimbursement
total=$(awk -v c="$core" -v m="$mileage" \
             'BEGIN { printf("%.2f", c + m) }')

echo "$total"
