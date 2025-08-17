# BoQCalc — ведомость работ (web + mobile)

Готов для деплоя на **GitHub Pages** (см. `.github/workflows/deploy-pages.yml`).

## Быстрый старт локально
```
flutter pub get
flutter run -d chrome
```

## Деплой на GitHub Pages
1) Залейте проект в репозиторий (ветка `main`).  
2) В Settings → Pages выберите Source: **GitHub Actions**.  
3) Workflow соберёт `build/web` и опубликует сайт.
