#!/bin/zsh

print_for_file () {
	printf '%-13s' "$1"
	echo ' =================================================================='
	echo '{{{'
	awk '{ printf("%3d %s\n", NR, $0) }' "$1"
	echo '}}}'
	./p2c2 "$1"
}

reset

make &> scrap

if [[ $? -eq 0 ]]; then
	if [[ $# -eq 0 ]]; then
		for f in $(ls test/**/*.pas); do
			print_for_file "$f" &>> scrap
		done
	else
		print_for_file "$1" &>> scrap
	fi
fi

vim scrap

