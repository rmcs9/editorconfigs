export PATH="/opt/homebrew/bin:$PATH"
export BASH_SILENCE_DEPRECATION_WARNING=1

COW_BANK="/Users/ryan/cow_bank.txt"

# Count the number of lines in the file
num_lines=$(wc -l < "$COW_BANK")

# Generate a random number within the range of lines
random_num=$((RANDOM % num_lines + 1))

# Get the word at the random line number
random_word=$(awk "NR==$random_num" "$COW_BANK")

#get a random fortune and cowsay with the randomly selected 
#avatar from the bank
fortune | cowsay -f $random_word
