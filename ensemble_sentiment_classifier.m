% Define files to be used...
filename = getFile;

% Read reviews from given file and split them into text and sentiment score.
dataReviews = readtable(filename,'TextType','string');
textData = dataReviews.review; %get review text
actualScore = dataReviews.score; %get review sentiment

% Preprocess the text data to make it cleaner.
sents = preprocessReviews(textData);
fprintf('File: %s, Sentences: %d\n', filename, size(sents));

% Vector to contain the sentiment results.
sentimentScore = zeros(size(sents));

for ii = 1 : sents.length
    docwords = sents(ii).Vocabulary;
    for jj = 1 : length(docwords)
        if words_hash.containsKey(docwords(jj))
            sentimentScore(ii) = sentimentScore(ii) + words_hash.get(docwords(jj));
        end
    end

    % If word-based fails... Use SVM classifier
    if sentimentScore(ii) == 0
        [~,scores] = predict(model,vec);
        sentimentScore(ii) = mean(scores(:,1));
    end
    fprintf('Sent: %d, words: %s, FoundScore: %d, GoldScore: %d\n', ii, joinWords(sents(ii)), sentimentScore(ii), actualScore(ii));
end

notFound = sum(sentimentScore == 0);
covered = numel(sentimentScore) - notFound; 

sentimentScore(sentimentScore == 0) = NaN; % Mark neutral as unclassified
sentimentScore(sentimentScore > 0) = 1; % Take >1 to be 1 only
sentimentScore(sentimentScore < 0) = 0; % There is no neutral, only negative.

tp = 0; tn = 0; count = 0;

for i = 1:length(actualScore)
    if sentimentScore(i) == 1 && actualScore(i) == 1
        tp = tp + 1; count = count + 1;
    elseif sentimentScore(i) == 0 && actualScore(i) == 0
        tn = tn + 1; count = count + 1;
    end
end

accuracy = (tp + tn) * 100 / covered;
coverage = covered * 100 / numel(sentimentScore);

wordsC = confusionmat(actualScore, sentimentScore);
confusionchart(wordsC)

fprintf("\nCoverage: %d Found: %d Missed: %d\n", coverage, covered, notFound)
fprintf("Accuracy: %d TP: %d TN: %d\n", accuracy, tp, tn)

wordStats = statsOfMeasure(wordsC, 1)
