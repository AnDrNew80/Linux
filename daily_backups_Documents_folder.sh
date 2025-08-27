#!/bin/bash
# Komentarze zaczynają się od symbolu #

# Poniżej zmienne. Nie musisz ich zmieniać, ale możesz :)
SOURCE_DIR="/home/youruser/Documents" # To jest katalog, który chcesz skopiować. Zmień 'youruser' na swoją nazwę użytkownika.
DEST_DIR="/home/youruser/backups/Documents"    # To jest katalog docelowy, gdzie trafi kopia. Zmień 'youruser' na swoją nazwę użytkownika.

# Sprawdzanie, czy katalog docelowy istnieje.
# Jeśli go nie ma, to go tworzymy.
if [ ! -d "$DEST_DIR" ]; then
    echo "Katalog backupu nie istnieje. Tworzę go..."
    mkdir -p "$DEST_DIR"
    # Nadanie uprawnień do zapisu, odczytu i wykonywania dla właściciela katalogu.
    # Właściciel: odczyt, zapis, wykonywanie (4+2+1=7)
    # Grupa: odczyt, wykonywanie (4+1=5)
    # Inni: odczyt, wykonywanie (4+1=5)
    chmod 755 "$DEST_DIR"
    echo "Katalog $DEST_DIR został utworzony i ma nadane uprawnienia."
fi

# Tworzenie nazwy pliku backupu, dodając datę, żeby łatwo je rozróżnić.
# np. backups_2023-10-27.tar.gz
BACKUP_FILE="$DEST_DIR/backups_$(date +%Y-%m-%d).tar.gz"

# Kompresowanie katalogu źródłowego do pliku backupu.
# 'tar' to program do archiwizacji
# '-zcvf' to opcje, które mówią:
# z - skompresuj
# c - stwórz archiwum
# v - pokaż co robisz (verbose)
# f - nazwa pliku archiwum
# Następnie podajemy nazwę pliku, który tworzymy i ścieżkę do katalogu źródłowego.
tar -zcvf "$BACKUP_FILE" "$SOURCE_DIR"

# Ta linijka wyświetli komunikat po zakończeniu
echo "Backup z dnia $(date +%Y-%m-%d) został pomyślnie utworzony w katalogu $DEST_DIR"