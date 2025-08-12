import re  # type: ignore

import nltk
from nltk import ngrams  # type: ignore
from nltk.corpus import stopwords  # type: ignore
from pymorphy3 import MorphAnalyzer  # type: ignore

nltk.download("stopwords")


def process(texts, author=None):
    morph = MorphAnalyzer()
    stop_words = set(stopwords.words("russian"))
    processed_texts = []

    for text in texts:
        clean_text = re.sub(r"[^а-яА-ЯёЁa-zA-Z\s]", "", text)
        if not clean_text:
            processed_texts.append(author if author else "")
            continue
        tokens = clean_text.lower().split()
        lemmas = [morph.parse(token)[0].normal_form for token in tokens]
        filtered = [lemma for lemma in lemmas if lemma not in stop_words]
        if len(filtered) >= 2:
            filtered.extend(["_".join(gram) for gram in ngrams(filtered, 2)])
        processed_text = " ".join(filtered)
        processed_texts.append(processed_text)

    return processed_texts
