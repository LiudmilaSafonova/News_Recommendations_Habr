<!DOCTYPE html>
<html lang="ru">
  <head>
    <meta charset="UTF-8" />
    <title>Разметка новостей</title>
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
        background-color: #2c2c2c;
        border: 1px solid #444;
      }
      .first-news {
          background-color: #3c2c2c;
          border-left: 8px solid #ffb3ab;
          color: #fff;
          box-shadow:
            0 0 10px rgba(255, 150, 170, 0.5),
            0 0 20px rgba(255, 150, 170, 0.6),
            0 0 40px rgba(255, 150, 170, 0.8);
          border-radius: 0.5rem;
      }

      .first-news .card-title a {
         color: #ffe6ec;
         text-shadow: none;
      }

      .btn-success {
        background-color: #a8e6cf;
        border: none;
        color: #000;
      }
      .btn-warning {
        background-color: #ffd3b6;
        border: none;
        color: #000;
      }
      .btn-danger {
        background-color: #ffaaa5;
        border: none;
        color: #000;
      }
      .btn-success:hover {
        background-color: #91d9bb;
      }
      .btn-warning:hover {
        background-color: #ffc099;
      }
      .btn-danger:hover {
        background-color: #ff918c;
      }

      .navbar-brand {
        font-size: 1.8rem;
        font-weight: 700;
      }

      /* info box */
      .info-box {
        position: relative;
        border: 2px solid #91d9bb;
        border-radius: 1rem;
        padding: 2rem 2rem 1.5rem;
        margin-bottom: 2rem;
        background-color: #1f1f1f;
        opacity: 0;
        transform: translateY(20px);
        transition: all 0.6s ease-out;
        max-width: 600px;
      }

      .info-box.visible {
        opacity: 1;
        transform: translateY(0);
      }

      .info-label {
        position: absolute;
        top: 0;
        left: 1rem;
        transform: translateY(-50%);
        background-color: #1e1e1e;
        padding: 0 1rem;
        font-weight: bold;
        color: #29AB87;
        font-size: 1.1rem;
      }
    </style>
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-dark" style="background-color: #333;">
      <div class="container">
        <a class="navbar-brand" href="/">Разметка</a>
        <div>
          <a class="btn btn-outline-light me-2" href="/update_news">
            <i class="bi bi-plus-circle me-1"></i> Больше новостей
          </a>
          <a class="btn btn-light" href="/recommendations">
            <i class="bi bi-stars me-1"></i> Рекомендации
          </a>
        </div>
      </div>
    </nav>

    <div class="container py-4">
      <!-- Информационный блок -->
      <div class="info-box" id="infoBox">
        <div class="info-label">info</div>
        <p><strong>Рекомендательная система</strong> — алгоритм, который помогает подобрать наиболее интересные новости на основе ваших предпочтений. Она обучается на тех новостях, которые вы уже оценили.</p>
        <p><strong>Разметка данных</strong> — процесс, в котором вы вручную помечаете новости как "Интересно", "Возможно" или "Не интересно", чтобы система лучше поняла ваши вкусы.</p>
      </div>

      <div class="row">
        %for i, row in enumerate(rows):
        %if i == 0:
        <!-- Первая новость -->
        <div class="col-12 mb-4">
          <div class="card news-card first-news shadow">
            <div class="card-body">
              <h3 class="card-title fw-bold">
                <a href="{{ row.url }}" target="_blank" class="text-white text-decoration-none">{{ row.title }}</a>
              </h3>
              <p class="card-subtitle mb-3 text-white">Автор: {{ row.author }} | Сложность: {{ row.complexity }}</p>
              <div class="d-flex gap-2">
                <a href="/add_label/?label=good&id={{ row.id }}" class="btn btn-success">Интересно</a>
                <a href="/add_label/?label=maybe&id={{ row.id }}" class="btn btn-warning">Возможно</a>
                <a href="/add_label/?label=never&id={{ row.id }}" class="btn btn-danger">Не интересно</a>
              </div>
            </div>
          </div>
        </div>
        %else:
        <!-- Остальные новости -->
        <div class="col-md-6">
          <div class="card news-card shadow-sm">
            <div class="card-body">
              <h5 class="card-title">
                <a href="{{ row.url }}" target="_blank" class="text-white text-decoration-none">{{ row.title }}</a>
              </h5>
              <p class="card-subtitle mb-2 text-white">Автор: {{ row.author }} | Сложность: {{ row.complexity }}</p>
              <div class="mt-3 d-flex gap-2">
                <a href="/add_label/?label=good&id={{ row.id }}" class="btn btn-success btn-sm">Интересно</a>
                <a href="/add_label/?label=maybe&id={{ row.id }}" class="btn btn-warning btn-sm">Возможно</a>
                <a href="/add_label/?label=never&id={{ row.id }}" class="btn btn-danger btn-sm">Не интересно</a>
              </div>
            </div>
          </div>
        </div>
        %end
        %end
      </div>
    </div>

    <script>
      // Анимация появления инфоблока при прокрутке
      const observer = new IntersectionObserver(
        (entries) => {
          entries.forEach((entry) => {
            if (entry.isIntersecting) {
              entry.target.classList.add("visible");
              observer.unobserve(entry.target);
            }
          });
        },
        { threshold: 0.3 }
      );
      const infoBox = document.getElementById("infoBox");
      if (infoBox) {
        observer.observe(infoBox);
      }
    </script>
  </body>
</html>

