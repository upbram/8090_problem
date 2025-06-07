#!/usr/bin/env bash
#
# run.sh –– Top Coder Challenge “Black Box Legacy Reimbursement System”
#
# Usage:
#   ./run.sh <trip_duration_days> <miles_traveled> <total_receipts_amount>
#
# Outputs a single number: the reimbursement amount, rounded to 2 decimals.

set -eo pipefail

days=$1
miles=$2
receipts=$3

# 1. Per-diem allowance for lodging & meals:
#    $75 per day, regardless of actual receipts
ALLOWANCE_PER_DAY=75.00
allowance=$(awk -v d="$days" -v r="$ALLOWANCE_PER_DAY" 'BEGIN { printf("%.2f", d * r) }')

# 2. Mileage reimbursement rate:
#    $0.12 per mile
MILEAGE_RATE=0.12
mileage=$(awk -v m="$miles" -v r="$MILEAGE_RATE" 'BEGIN { printf("%.2f", m * r) }')

# 3. The legacy rule is “whichever is higher: actual receipts or flat per-diem”
#    for lodging + meals, then add mileage on top.
#
#    reimbursement = max(receipts, allowance) + mileage
reimb_core=$(awk -v rc="$receipts" -v al="$allowance" \
                 'BEGIN { printf("%.2f", (rc > al ? rc : al)) }')

# 4. Sum and round
total=$(awk -v c="$reimb_core" -v m="$mileage" \
             'BEGIN { printf("%.2f", c + m) }')

echo "$total"

