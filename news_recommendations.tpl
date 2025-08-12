<!DOCTYPE html>
<html lang="ru">
  <head>
    <meta charset="UTF-8" />
    <title>Рекомендации новостей</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
      body {
        background-color: #1e1e1e;
        color: #fefefe;
      }
      .card-subtitle {
        color: #ffffff !important;
      }
      .news-card {
        margin-bottom: 20px;
        border: 1px solid #444;
        color: white;
      }
      .news-card.good {
        background-color: #2e7d32; /* зелёный */
      }
      .news-card.maybe {
        background-color: #ffb300; /* жёлтый */
        color: black;
      }
      .news-card.never {
        background-color: #c62828; /* красный */
      }
      .navbar-brand {
        font-size: 1.8rem;
        font-weight: 700;
      }
    </style>
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-dark" style="background-color: #333;">
      <div class="container">
        <a class="navbar-brand" href="/">Рекомендации {{ score }}</a>
        <div>
          <a class="btn btn-outline-light me-2" href="/news">
            <i class="bi bi-arrow-left"></i> Вернуться
          </a>
        </div>
      </div>
    </nav>

    <div class="container py-4">
      <div class="row">
        %for i, row in enumerate(rows):
        %if i % 2 == 0 and i != 0:
      </div>
      <div class="row">
        %end
        <div class="col-md-6">
          <div class="card news-card {{ row.predicted_label }}">
            <div class="card-body">
              <h5 class="card-title">
                <a href="{{ row.url }}" target="_blank" class="text-white text-decoration-none">
                  {{ row.title }}
                </a>
              </h5>
              <p class="card-subtitle mb-2">Автор: {{ row.author }} | Сложность: {{ row.complexity }}</p>
              <span class="badge bg-light text-dark">{{ row.predicted_label }}</span>
            </div>
          </div>
        </div>
        %end
      </div>

      <div class="d-flex justify-content-center mt-4">
        <a href="/news" class="btn btn-light">Вернуться</a>
      </div>
    </div>
  </body>
</html>


