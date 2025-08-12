from collections import Counter, defaultdict
import math


class NaiveBayesClassifier:
    def __init__(self, alpha=1.0):
        self.alpha = alpha
        self.prob_class = {}  # P(C = c)
        self.word_probs = defaultdict(dict)  # P(w_i | C = c)
        self.vocab = set()  # Множество всех слов
        self.class_total_words = {}  # n_c — общее число слов в классе

    def fit(self, X, y):
        """Fit Naive Bayes classifier according to X, y.
        обучение: рассчитать вероятности для классов и вероятнсть
        встретить такое-то слово в таком-то классе
        словарь или другое, где каждому слову для каждого класса приписаны вероятности"""
        total_docs = len(y)
        number_of_classes = Counter(y)
        self.prob_class = {label: count / total_docs for label, count in number_of_classes.items()}

        X_tokenized = [el.split() for el in X]

        for tokens in X_tokenized:
            self.vocab.update(tokens)
        vocab_size = len(self.vocab)

        class_word_counts = defaultdict(Counter)
        for label, words in zip(y, X_tokenized):
            class_word_counts[label].update(words)

        self.class_total_words = {label: sum(counter.values()) for label, counter in class_word_counts.items()}
        for label in class_word_counts:
            total_words_class = self.class_total_words[label]
            for word in self.vocab:
                word_specific_class = class_word_counts[label][word]
                prob = (word_specific_class + self.alpha) / (total_words_class + self.alpha * vocab_size)
                self.word_probs[label][word] = math.log(prob)
        self.prob_class = {label: math.log(prob) for label, prob in self.prob_class.items()}

    def predict(self, X):
        """Perform classification on an array of test vectors X.
        реализовать просчет с логарифмами"""
        X_token = [el.split() for el in X]
        predictions = []

        for text in X_token:
            label_probs = {}
            for label, log_class_prob in self.prob_class.items():
                total_log_prob = log_class_prob

                for word in text:
                    if word in self.word_probs[label]:
                        total_log_prob += self.word_probs[label][word]

                label_probs[label] = total_log_prob

            best_label = max(label_probs, key=label_probs.get)
            predictions.append(best_label)
        return predictions

    def score(self, X_test, y_test):
        """Returns the mean accuracy on the given test data and labels.
        вызвать predict, посчситать предсказание для X_test
        посчитать долю правильных ответов относительно значений y_test"""
        predictions = self.predict(X_test)
        correct = sum(1 for a, b in zip(predictions, y_test) if a == b)
        return correct / len(y_test)
