clc; clear; % Clear screen and clear workspace.

% Open the positive wordlist.
findPositive = fopen(fullfile('opinion-lexicon-English/positive-words.txt'));
c =  textscan(findPositive, '%s', 'CommentStyle',';');  % Skips comment lines.
wordsPositive = string(c{1});
fclose all;

% Open the negative wordlist.
findNegative = fopen(fullfile('opinion-lexicon-English/negative-words.txt'));
d = textscan(findPositive, '%s', 'CommentStyle', ';'); % Skip comment lines.
wordsNegative = string(d{1});
fclose all;

% Create a HashTable for storing all the words.
words_hash = java.util.Hashtable;

% Store all positive words in the HashTable
[possize, ~] = size(wordsPositive);
for ii = 1:possize
    words_hash.put(wordsPositive(ii, 1), 1);
end

% Store all negative words in the HashTable
[negsize, ~] = size(wordsNegative);
for jj = 1:negsize
    words_hash.put(wordsNegative(jj, 1), -1);
end

