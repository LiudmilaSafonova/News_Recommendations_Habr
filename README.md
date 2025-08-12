# News_Recommendations_Habr
Веб-сайт рекомендованных статей с Habr, созданный на основе размеченных данных с применением наивного байесовского классификатора.

## Используемые технологии
1. Парсинг: BeautifulSoup
2. Для предобработки текста: nltk, pymorphy3
3. Реализация NaiveBayesClassifier: collections, math
4. База данных: sqlalchemy, DB Browser (SQLite)
5. Сайт: bottle и Bootstrap для html

## Использование

1. Запустите файл  ```habrnews.py ```
2. Появится окно "Разметка": каждой новости можно дать лейбл, который сохранится в базе данных
3. Для подгрузки новых новостей - кнопка "Больше новостей". Для перехода к рекомендациям - "Рекомендации"
4. Чтобы вернуться к разметке, можно воспользоваться кнопкой в колонтитуле или внизу страницы.
5. Для того, чтобы прочитать статью, перейдите по названию.

### Страница разметки данных
<img width="2080" height="1250" alt="image" src="https://github.com/user-attachments/assets/695df536-b787-495f-ad69-73d4e61f95d2" />


### Страница рекомендаций, с точностью размеченных данных
<img width="1910" height="1160" alt="image" src="https://github.com/user-attachments/assets/66f54eb1-789c-4f43-96d5-cb956ea8cd65" />
<img width="1990" height="1070" alt="image" src="https://github.com/user-attachments/assets/f828b2cb-017a-4e32-93a7-3ec6ffa3a453" />
