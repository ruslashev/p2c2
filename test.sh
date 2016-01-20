#!/bin/zsh

reset
make

for f in $(ls *.pas)
do
	printf '%-13s' "$f"
	echo ' ==================================================================='
	echo '{{{'
	awk '{ printf("%3d %s\n", NR, $0) }' "$f"
	echo '}}}'
	./p2c2 "$f"
done

