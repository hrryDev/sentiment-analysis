function [documents] = preprocessReviews(textData)
%PREPROCESSREVIEWS Preprocesses text data for processing.
    cleanTextData = lower(textData); % Convert to lowercase.
    documents = tokenizedDocument(cleanTextData); % Tokenize the text.
    documents = erasePunctuation(documents); % Erase punctuation.
    documents = removeWords(documents, stopWords); % Remove all stop words.
end

