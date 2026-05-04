# 1. Wybierz oficjalny obraz bazowy (tu: lekki Python 3.9)
FROM python:3.9-slim

# 2. Ustaw katalog roboczy wewnątrz kontenera
WORKDIR /app

# 3. Skopiuj plik z zależnościami (upewnij się, że masz requirements.txt w repo)
COPY requirements.txt .

# 4. Zainstaluj biblioteki
RUN pip install --no-cache-dir -r requirements.txt

# 5. Skopiuj cały kod z Twojego repozytorium do kontenera
COPY . .

# 6. Wystaw port, na którym działa apka (zmień, jeśli aplikacja używa np. 5000 albo 3000)
EXPOSE 8080

# 7. Komenda uruchamiająca aplikację (podmień 'main.py' na główny plik Twojej apki)
CMD ["python", "main.py"]
