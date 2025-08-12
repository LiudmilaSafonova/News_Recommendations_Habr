from bottle import route, run, template, request, redirect  # type: ignore

from scraputils import get_news
from db import News, session
from bayes import NaiveBayesClassifier
from text_processing import process


@route("/")
@route("/news")
def news_list():
    s = session()
    rows = s.query(News).filter(News.label == None).all()
    return template("news_template", rows=rows)


@route("/add_label/")
def add_label():
    """функция, котрая добавляет имя good maybe never"""
    s = session()
    label = request.query.label
    id = int(request.query.id)

    article = s.query(News).get(id)
    if article:
        article.label = label
        s.commit()

    if __name__ == "__main__":
        redirect("/news")


@route("/update_news")
def update_news():
    s = session()
    new_news = get_news("https://habr.com/ru/feed/", 9)

    if __name__ == "__main__":
        redirect("/news")


@route("/classify")
def classify_news():
    s = session()
    nbc = NaiveBayesClassifier()

    test_news = []
    test_label = []
    labeled_news = s.query(News).filter(News.label != None).all()
    for news in labeled_news:
        test_news.append(news.title)
        test_label.append(news.label)

    nbc.fit(process([news.title + " " + news.author for news in labeled_news]), [news.label for news in labeled_news])

    unlabeled_news = s.query(News).filter(News.label == None).all()

    test_fit = nbc.fit(process(test_news[:301]), test_label[:301])
    test_pred = nbc.predict(process(test_news[301:]))
    test_score = nbc.score(test_pred, test_label[301:])


    predictions = nbc.predict(process([news.title + " " + news.author for news in labeled_news]))

    for news, pred in zip(unlabeled_news, predictions):
        news.predicted_label = pred

    priority = {"good": 0, "maybe": 1, "never": 2}
    sorted_news = sorted(unlabeled_news, key=lambda x: priority[x.predicted_label])
    return sorted_news, test_score


@route("/recommendations")
def recommendations():
    # 1. Получить список неразмеченных новостей из БД
    # 2. Получить прогнозы для каждой новости
    # 3. Вывести ранжированную таблицу с новостями

    classified_news, test_score = classify_news()
    return template("news_recommendations", rows=classified_news, score=test_score)


if __name__ == "__main__":
    run(host="localhost", port=8080)
