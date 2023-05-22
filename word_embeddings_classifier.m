% Word embeddings classifier
% Source: https://uk.mathworks.com/help/textanalytics/ug/train-a-sentiment-classifier.html

rng('default');
emb = fastTextWordEmbedding;

 % Set up the positive and negative wordlist as a Matlab table.
words = [wordsPositive; wordsNegative];
labels = categorical(nan(numel(words), 1));
labels(1:numel(wordsPositive)) = "Positive";
labels(numel(wordsPositive) + 1 : end) = "Negative";

data = table(words, labels, 'VariableNames', {'Word', 'Label'});

idx = ~isVocabularyWord(emb, data.Word);
data(idx, :) = [];

% Set aside 10% of the words at random for testing.
numWords = size(data, 1);
cvp = cvpartition(numWords, 'HoldOut', 0.01); % Holdout fewer if applying model.

dataTrain = data(training(cvp), :);
dataTest = data(test(cvp), :);

% Convert the words in the training data to word vectors using word2vec.
wordsTrain = dataTrain.Word;
XTrain = word2vec(emb, wordsTrain);
YTrain = dataTrain.Label;

% Train a support vector machine (SVM) Sentiment Classifier which
% classifies  word vectors into positive and negative categories.

model = fitcsvm(XTrain, YTrain);


% Test classifier
wordsTest = dataTest.Word;
XTest = word2vec(emb, wordsTest);
YTest = dataTest.Label;

% Predict the sentiment labels of the test word vectors.
[YPred, scores] = predict(model, XTest);

% Visualise the classification accuracy in a confisuion matrix.
figure
confusionchart(YTest, YPred, 'ColumnSummary','column-normalized');
