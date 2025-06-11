require 'pycall/import'
include PyCall::Import

pyimport :nltk

nltk.download('punkt_tab')
nltk.download('averaged_perceptron_tagger_eng')

sentence = 'English is one of the languages of all time'

tokens = nltk.tokenize.word_tokenize(sentence)

pos_tags = nltk.pos_tag(tokens)

# pos_tags is [
#   ('English', 'NNP'), ('is', 'VBZ'), ('one', 'CD'), ('of', 'IN'), ('the', 'DT'),
#   ('languages', 'NNS'), ('of', 'IN'), ('all', 'DT'), ('time', 'NN')
# ]
