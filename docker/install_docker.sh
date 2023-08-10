
#!/bin/bash
# Wrapper to install downloaded packages

RESOURCE_ROOT=/spyne/docker
docker_file=${RESOURCE_ROOT}/docker_file.txt
docker_file_cleaned=${RESOURCE_ROOT}/docker_file_cleaned.txt

if [[ -f ${docker_file} ]]
then

	echo "Install docker"

	# Remove blank lines from the file and save a cleaner version of it
	awk NF < ${docker_file} > ${docker_file_cleaned}

	# Count number of lines in a file
	n=`wc -l < ${docker_file_cleaned}`
	i=1

	# Wget the file and install the package
	while [[ i -le $n ]];
	do
		echo $i
		file=$(head -${i} ${docker_file_cleaned} | tail -1 | sed 's,\r,,g')
		echo $file
		if [[ -f ${RESOURCE_ROOT}/${file} ]]
		then
			sudo dpkg -i ${RESOURCE_ROOT}/${file}
		fi
		i=$(($i+1))
		rm -rf ${RESOURCE_ROOT}/${file}
	done

	echo "Done"

fi