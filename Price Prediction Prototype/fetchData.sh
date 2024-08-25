#!/bin/bash


getNumberCountFromFile() {
	filename=$1
	appendInd=$2

	num=$(cat $filename | wc -l | xargs)
	if [ $appendInd == true ]; then
		num=$(($num + 1))
	fi
	echo $num
}


while IFS='\n' read var; do
    origin+=($var)
done < origin_pincodes

num_of_origin=$(getNumberCountFromFile origin_pincodes false)
num_of_dest=$(getNumberCountFromFile india_pincode_serviceable_dtdc true)
num_of_parcel_options=$(getNumberCountFromFile parcel_info.csv true)

for i in $(seq 1 2);
do
    # Read origin pincode using a random number from list of origin pincode array
    minInd=0
    min=1
    ind=$(shuf -i $minInd-$num_of_origin -n 1)
    org_pincode=${origin[$ind]}
    echo "origin is $org_pincode"

    # Generate random number for index to read destination pincode
    dest_ind=$(shuf -i $min-$num_of_dest -n 1)
    dest_info=$(sed -n "${dest_ind}p" india_pincode_serviceable_dtdc)
    arr_dest_info=(${dest_info//,/ })
    echo $dest_info
    
    dest_pincode=${arr_dest_info[0]}
    po_serviceable=${arr_dest_info[1]}
    state=${arr_dest_info[2]}
    dtdc_serviceable=${arr_dest_info[3]}
    echo "destination is $dest_pincode"

    # Pick Random parcel info, based on prob we will choose weight within certain limits
    parcel_ind=$(shuf -i $min-$num_of_parcel_options -n 1)
	parcel_info=$(sed -n "${parcel_ind}p" parcel_info.csv)
	echo $parcel_info
	arr_parcel_info=(${parcel_info//,/ })

	vol_weight=${arr_parcel_info[4]}
    echo "vol_weight is $vol_weight"

    # Call Dtdc API 

    # Pick higher of vol weight or dead weight and call porter API

    printf "\n" 

done




# NOTE: We will add logic to do multiple different parcel in same route based on probability to get variance of weight/vol distribution