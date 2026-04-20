FROM python:3.11-slim AS builder

# Instalujemy narzędzia niezbędne do kompilacji niektórych paczek Pythona
RUN apt-get update && apt-get install -y --no-install-recommends gcc python3-dev

WORKDIR /app

# Kopiujemy listę zależności
COPY requirements.txt .

# Instalujemy paczki do folderu użytkownika, aby łatwo je przenieść
RUN pip install --user --no-cache-dir -r requirements.txt

# Kopiujemy kod źródłowy aplikacji i testy
COPY . .

RUN python -m unittest discover tests
# Lub jeśli masz pytest: RUN python -m pytest

FROM python:3.11-slim AS runtime

WORKDIR /app

# Kopiujemy TYLKO zainstalowane biblioteki z poprzedniego etapu
COPY --from=builder /root/.local /root/.local
# Kopiujemy tylko kod aplikacji (bez plików testowych, jeśli chcesz pełnej hermetyzacji)
COPY . .

# Aktualizujemy PATH, aby system widział zainstalowane biblioteki
ENV PATH=/root/.local/bin:$PATH

EXPOSE 5000

CMD ["python", "main.py"]
