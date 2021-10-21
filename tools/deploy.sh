#!/bin/bash

git fetch -f --all --tags; echo ""

function listdpl {
	while read i; do
		VERSION=$(git show -s --format=%N $i | grep -E "stage|prod")
		if [ ! -z "$VERSION" ]; then
			echo ${VERSION} $i
		fi
	done <<< "$(git tag | grep -E "^[0-9]*\.[0-9]*\.[0-9]*$" | sort -Vr)"
}

function settag {
	COMMIT_ID=$(git rev-list -n 1 $1 2> /dev/null)
	if [ -z "$COMMIT_ID" ]; then
		printf "\n\e[31mNo such tag:\e[0m $1\n"
		printf "To see available tags run: git tag | sort -V\n\n"
		exit 0
	fi
	if [ "$2" = "reset" ]; then
		git tag -f $1  $COMMIT_ID
	else
		git tag -af $1 -m "$2" $COMMIT_ID
	fi
	
	git push -f origin --tags
}

function printusage {
	printf "\nUsage $0 [stage|prod|reset|list] [version-tag]\n"
	echo "'stage' and 'prod' and the only valid environment keywords"
	echo "'reset' will clear any previously set flags on a tag"
	echo "'list' will show all tags flagged for stage or prod deploys"
}

if [ "$1" = "stage" ]; then
	settag $2 "stage"
elif [ "$1" = "prod" ]; then
	settag $2 "production"
elif [ "$1" = "reset" ]; then
	settag $2 "reset"
elif [ "$1" = "list" ]; then
	listdpl
else
	printusage
fi
