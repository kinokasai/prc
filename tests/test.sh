#!/usr/bin/sh

ok () {
    echo -e "\033[92m [OK] "$1"\033[0m"
}

ko () {
    echo -e "\033[91m [KO] "$1"\033[0m"
}

files=`ls -R | grep -E "*.sol"`
files=`find . -name \*.sol`
counter=0
correct=0
for file in $files
do
    let "counter++"
    ./sdt $file &> /dev/null 2>&1
    ret=$?
    if [ $ret -ne 0 ]; then
        ko $file
    else
        let "correct++"
        ok $file
    fi
done
if [ $counter -ne $correct ]; then
    exit -1
fi
