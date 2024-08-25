#!/bin/bash

while IFS="," read -r column1 column2 column3
do
    echo "Checking for pincode: $column1"
    RESPONSE=$(curl --location "https://ebookingbackend.shipsy.in/serviceablePickup?src=${column1}&fetchServiceability=true&fetchWeight=false&isQRBooking=false")
    isServiceableDTDC=$(echo $RESPONSE | jq -r '.data.serviceable')
    echo $column1,$column2,$column3,$isServiceableDTDC >> india_pincode_serviceable_dtdc
done < "$1"