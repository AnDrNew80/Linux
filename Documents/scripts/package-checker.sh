#!/bin/bash
# package-checker.sh

## Opis

#  Skrypt `package-checker.sh` jest skryptem Bash, kt  ry wy ^{wietla list ^y zainstalowanych pakiet  w w systemie Linux wraz z datami ich instalacji. Skrypt analizuje plik `/var/log/dpkg.log`, kt  ry zawiera>

## Wymagania

#  System Linux z dost ^ypem do pliku `/var/log/dpkg.log` (np. Debian, Ubuntu).
#  Bash.

## Uzycie

# 1. Pobierz skrypt `package-checker.sh`.
# 2.  Nadaj skryptowi uprawnienia do wykonywania:

    #  ```bash
    #  chmod +x package-checker.sh
    #  ```
# 3.  Uruchom skrypt:

   # ```bash
   # ./package-checker.sh
   # ```

## Wyjscie

# Skrypt wyswietla na standardowym wyjsciu listy zainstalowanych pakiet  w  formacie tabeli. Kazdy wiersz zawiera nazwe pakietu i daty jego instalacji.

#    Nazwa pakietu | Wersja Pakietu | Data instalacji
#    ----------------------------------------
#   nazwa-pakietu-1 |6.4-4          | 2024-07-15 10:00:00
#   nazwa-pakietu-2 | 6.4-4         |2024-07-16 12:30




LOG_FILE="/var/log/dpkg.log"

# Check if the dpkg log file exists

if [ ! -f "$LOG_FILE" ]; then
  echo "Error: Plik $LOG_FILE nie istnieje."
  exit 1
fi

# Print table header
header="Nazwa pakietu           | Wersja pakietu  | Data instalacji
------------------------------------------------------------"

# Function to safely get package version
get_package_version() {
  local package="$1"
  local version=$(dpkg-query -W -f='${Version}' "$package" 2>/dev/null)
  if [ -z "$version" ]; then
    echo "Warning: Nie można pobrać wersji dla pakietu: $package" >&2
    echo "          Sprawdź, czy pakiet jest poprawnie zainstalowany." >&2
    echo "N/A" # Return "N/A" to be printed, not as exit code
  else
    echo "$version"
  fi
}

# Extract install entries and format them
output=$(grep " install " "$LOG_FILE" | while read -r line; do
  datetime=$(echo "$line" | awk '{print $1, $2}')
  package=$(echo "$line" | awk '{print $4}' | cut -d: -f1) # Extract package name correctly
  formatted_date=$(date -d "$datetime" "+%Y-%m-%d %H:%M:%S" 2>/dev/null)

  if [ -z "$package" ]; then
     echo "Warning: Package name is empty for line: $line" >&2
     continue # Skip this iteration
  fi

  version=$(get_package_version "$package")

  if [ -n "$formatted_date" ]; then
    printf "%-20s | %-15s | %s\n" "$package" "$version" "$formatted_date"
  fi
done)

# Print the output
if [ -z "$output" ]; then
  echo "$header"
  echo "No packages found in the specified log."
  echo ""
  echo "(q - for exit)"
else
  echo -e "$header\n$output\n\n(q - for exit)" | less
fi
exit 0
