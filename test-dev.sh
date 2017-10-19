# Run this file (with 'entr' installed) to watch all files and rerun tests on changes
# (brew install entr)

ls -d **/* | entr ./test.sh
