#!/bin/bash

location="$1"
temp="$2"
style="$3"

mkdir -p "$temp/symlinks"

#####################################################
## Create symlinks for SNP & SRP using servicelist ##
#####################################################
if [[ $style = "snp" ]] || [[ $style = "srp" ]]; then
    cat "$location/build-output/servicelist-"*"$style" | tr -d [:blank:] | tr -d [=*=] | while read line ; do
        IFS="|"
        line_data=($line)
        serviceref=${line_data[0]}
        link_srp=${line_data[2]}
        link_snp=${line_data[3]}

        IFS="="
        link_srp=($link_srp)
        logo_srp=${link_srp[1]}
        link_snp=($link_snp)
        logo_snp=${link_snp[1]}
        snpname=${link_snp[0]}

        if [[ ! $logo_srp = "--------" ]]; then
            ln -s -f "logos/$logo_srp.png" "$temp/symlinks/$serviceref.png"
        fi

        if [[ $style = "snp" ]] && [[ ! $logo_snp = "--------" ]]; then
            ln -s -f "logos/$logo_snp.png" "$temp/symlinks/$snpname.png"
        fi
    done
fi

##########################################
## Create symlinks using only snp-index ##
##########################################
if [[ $style = "snp-full" ]]; then
    sed '1!G;h;$!d' "$location/build-source/snp-index" | while read line ; do
        IFS="="
        link_snp=($line)
        logo_snp=${link_snp[1]}
        snpname=${link_snp[0]}

        if [[ $snpname == *"_"* ]]; then
            ln -s -f "logos/$logo_snp.png" "$temp/symlinks/"'1_0_1_'"$snpname"'_0_0_0'".png"
        else
            ln -s -f "logos/$logo_snp.png" "$temp/symlinks/$snpname.png"
        fi
    done
fi

##########################################
## Create symlinks using only srp-index ##
##########################################
if [[ $style = "srp-full" ]]; then
    sed '1!G;h;$!d' "$location/build-source/srp-index" | while read line ; do
        IFS="="
        link_srp=($line)
        logo_srp=${link_srp[1]}
        unique_id=${link_srp[0]}

        ln -s -f "logos/$logo_srp.png" "$temp/symlinks/"'1_0_1_'"$unique_id"'_0_0_0'".png"
    done
fi
