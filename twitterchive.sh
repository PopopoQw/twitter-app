## declare an array variable containing all your search terms. 
## prefix any hashtags with a \
declare -a arr=(bioinformatics metagenomics rna-seq \#rstats)
 
## How many results would you like for each query?
n=250
 
## cd into where the script is being executed from.
DIR="$(dirname "$(readlink $0)")"
cd $DIR
echo $DIR
echo $(pwd)
 
echo
 
## now loop through the above array
for query in ${arr[@]}
do
  ## if your query contains a hashtag, remove the "#" from the filename
	filename=$DIR/${query/\#/}.txt
	echo "Query:\t$query"
	echo "File:\t$filename"
 
	## create the file for storing tweets if it doesn't already exist.
	if [ ! -f $filename ]
	then
		touch $filename
	fi
 
	## use t (https://github.com/sferik/t) to search the last $n tweets in the query, 
	## concatenating that output with the existing file, sort and uniq that, then 
	## write the results to a tmp file. 
	search_cmd="t search all -ldn $n '$query' | cat - $filename | sort | uniq | grep -v ^ID > $DIR/tmp"
	echo "Search:\t$search_cmd"
	eval $search_cmd
 
	## rename the tmp file to the original filename
	rename_cmd="mv $DIR/tmp $filename"
	echo "Rename:\t$rename_cmd"
	eval $rename_cmd
 
	echo
done
