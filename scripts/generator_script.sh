#!/bin/bash
echo "Beginning generation script"
mkdir -p generation_results0425

declare -a ops=(
    "FloatingPointAdder"
)

declare -a bits=(64 )
declare -a freqs=( 500  )
declare -a conversions=("none") # "input" "output" "both" are

for op in "${ops[@]}"; do
    for bit in "${bits[@]}"; do
        for freq in "${freqs[@]}"; do
            for conv in "${conversions[@]}"; do

                case $conv in
                    none)
                        in_flag=""
                        out_flag=""
                        conv_label="wIO"
                        ;;
                    input)
                        in_flag="--noInputConversion"
                        out_flag=""
                        conv_label="noIN"
                        ;;
                    output)
                        in_flag=""
                        out_flag="--noOutputConversion"
                        conv_label="noOUT"
                        ;;
                    both)
                        in_flag="--noInputConversion"
                        out_flag="--noOutputConversion"
                        conv_label="noINOUT"
                        ;;
                esac

                dir="../generation_results0425/${op}_${bit}_${freq}_${conv_label}"

                if [ -d "$dir" ]; then
                    continue
                fi

                mkdir -p "$dir"

                sudo python3 float_gen.py \
                    --name "$op" \
                    --bitSize "$bit" \
                    --targetFrequencyMHz "$freq" \
                    $in_flag \
                    $out_flag \
                    --wrapper_file_name "$dir/wrapper.vhd" \
                    --out_file_name "$dir/operator.vhd"

            done
        done
    done
done
