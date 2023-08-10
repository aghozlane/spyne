
#!/bin/bash
# Wrapper to install downloaded packages 

PACKAGE_ROOT=/opt/bbtools
RESOURCE_ROOT=/spyne/bbtools
bbtools_file=${RESOURCE_ROOT}/bbtools_file.txt
bbtools_file_cleaned=${RESOURCE_ROOT}/bbtools_file_cleaned.txt

# Make the bbtools directory exits, if not, create it
if [[ ! -d ${PACKAGE_ROOT} ]]
then
	mkdir ${PACKAGE_ROOT}
fi

# Extract bbmap package to the bbtools directory
if [[ -f ${bbtools_file} ]]
then

	echo "Install bbtools"

	# Remove blank lines from the file and save a cleaner version of it
	awk NF <${bbtools_file} > ${bbtools_file_cleaned}

	# Get number of rows in bbtools_file_clean.txt
	n=`wc -l < ${bbtools_file_cleaned}`
	i=1

	# Wget the file and install the package
	while [[ i -le $n ]]
	do
		echo $i
		file=$(head -${i} ${bbtools_file_cleaned} | tail -1 | sed 's,\r,,g')
		echo $file
		if [[ -f ${RESOURCE_ROOT}/${file} ]]
		then
			sudo tar -zxf ${RESOURCE_ROOT}/${file} -C ${PACKAGE_ROOT}
			rm -rf ${RESOURCE_ROOT}/${file}
		fi
		i=$(($i+1))
	done

	echo "Done"

fi