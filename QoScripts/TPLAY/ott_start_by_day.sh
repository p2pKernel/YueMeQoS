#! /usr/bin/bash

# $(date +"%Y%m%d")
date=$1 

hour=24

perl filter_log_by_svrtype.pl tmp/${date}/*

svr_type=('B2B' 'B2C')
for type in ${svr_type[@]}
do
	mkdir -p log/${type}
	mv tmp/${date}/*_${type} log/${type}/
done

mkdir -p tmp/${date}

for type in ${svr_type[@]}
do
	mkdir -p ${type}/${date}

	# column 6 is devType, 1 is to write subfile
	perl key_distribution_calc.pl ${type} ${date} ${hour} dev 6 1 log/${type}/*

	bash ott_qos_by_dev.sh ${type} ${date} ${hour} ${type}/${date}/distribution_data_dev_${hour} 

	rm log/${type}/*
done

rm -rf tmp/${date}