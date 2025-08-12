import requests  # type: ignore
from bs4 import BeautifulSoup
from db import News, session


def extract_news(parser):
    """Extract news from a given web page"""
    news_list = []
    article_list = parser.find("div", {"class": "tm-articles-list"})
    ids = article_list.find_all("article")
    for article in ids:
        # 'author': 'Svetla79 ',
        # 'complexity': 'Простой',
        # 'id': '891528',
        # 'url': 'https://habr.com/ru/companies/rostelecom/articles/891528/',
        # 'title': ''
        post = {}
        name_part = article.find("a", class_="tm-user-info__userpic")
        post["author"] = name_part["title"] if name_part and "title" in name_part.attrs else "-"
        complexity_element = article.find("span", class_="tm-article-complexity__label")
        post["complexity"] = complexity_element.text.strip() if complexity_element else "-"
        post["habr_id"] = article.get("id", "-")
        fetch_link = article.find("h2", class_="tm-title tm-title_h2")
        post["url"] = "https://habr.com" + fetch_link.find("a").get("href") if fetch_link else "-"
        post["title"] = fetch_link.find("span").text.strip() if fetch_link else "-"
        news_list.append(post)

    return news_list


def extract_next_page(parser):
    """Extract next page URL"""
    curr_page = parser.find("span", class_="tm-pagination__page tm-pagination__page_current").text.strip()
    next_page = int(curr_page) + 1
    if next_page > 50:
        return None
    return f"/ru/feed/page{next_page}/"


def get_news(url, n_pages=1):
    """Collect news from a given web page"""
    s = session()
    news = 0
    page_count = 0

    while True:
        print("Collecting data from page: {}".format(url))
        response = requests.get(url)
        soup = BeautifulSoup(response.text, "html.parser")
        news_list = extract_news(soup)

        page_count += 1

        for new in news_list:
            nick = new["author"]
            title = new["title"]
            post = s.query(News).filter(News.author == nick, News.title == title).first()
            if not post:
                post = News(**new)
                s.add(post)
                s.commit()
                news += 1

        if page_count >= n_pages and news:
            break

        next_page = extract_next_page(soup)

        if not next_page:
            print('Больше новых новостей не осталось. Подождите час.')
            break

        url = "https://habr.com" + next_page

    return news
