#!/bin/sh
# metaprogram
echo '#!/bin/sh' > program
for i in $(seq 992)
do
	echo "echo $i" >> program
done
chmod +x program
