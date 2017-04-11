rm jsonfiles/*
for file in $(ls pgnfiles/)
do
 echo "Parsing $file"
 ./pgnparser pgnfiles/$file 1 500000 > jsonfiles/$file.json
done
rename 'pgn.json' 'json' jsonfiles/*

echo ' '
echo 'Done processing pgn files'
