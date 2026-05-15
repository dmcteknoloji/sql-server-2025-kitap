#!/usr/bin/env bash
# SQL Server 2025 kitabı — kod örneği test koşucusu
# Plan Faz 4: kod doğrulama maratonu
#
# Kullanım:
#   1) Credential'ları environment'a koy (chat'e değil!):
#      export SQLCMDSERVER='HOST,PORT'
#      export SQLCMDUSER='kullanici'
#      export SQLCMDPASSWORD='parola'
#      export SQLCMDDBNAME='kitap_demo'   # opsiyonel, varsayılan: master
#
#   2) Çalıştır:
#      cd /Users/caglarozenc/kitap-sqlserver2025
#      ./kontrol/run-tests.sh                # tüm bölümler
#      ./kontrol/run-tests.sh bolum-01       # tek bölüm
#      ./kontrol/run-tests.sh bolum-01 bolum-05  # birden çok bölüm
#
#   3) Çıktılar: kontrol/test-runs/chXX-NN.txt
#      Özet: kontrol/test-runs/_summary.txt

set -u  # tanımlı değişken zorunlu
set -o pipefail

readonly ROOT="$(cd "$(dirname "$0")/.." && pwd)"
readonly CODE_DIR="$ROOT/kod-ornekleri"
readonly OUT_DIR="$ROOT/kontrol/test-runs"
readonly SUMMARY="$OUT_DIR/_summary.txt"
readonly SETUP_SQL="$CODE_DIR/_ortak/00-demo-veritabani.sql"

# Renkler (TTY ise)
if [[ -t 1 ]]; then
  C_GREEN=$'\033[0;32m'; C_RED=$'\033[0;31m'; C_YEL=$'\033[0;33m'; C_BLU=$'\033[0;34m'; C_OFF=$'\033[0m'
else
  C_GREEN=''; C_RED=''; C_YEL=''; C_BLU=''; C_OFF=''
fi

# Ön kontroller
if ! command -v sqlcmd >/dev/null 2>&1; then
  echo "${C_RED}HATA${C_OFF}: sqlcmd bulunamadı. Kurulum:"
  echo "  brew install --cask sql-server-tools  # macOS"
  echo "  veya: https://learn.microsoft.com/en-us/sql/tools/sqlcmd/sqlcmd-utility"
  exit 1
fi

for var in SQLCMDSERVER SQLCMDUSER SQLCMDPASSWORD; do
  if [[ -z "${!var:-}" ]]; then
    echo "${C_RED}HATA${C_OFF}: $var environment değişkeni boş."
    echo "Önce: export $var='...'"
    exit 1
  fi
done

readonly DBNAME="${SQLCMDDBNAME:-master}"

mkdir -p "$OUT_DIR"

# Bağlantı sağlığını kontrol et
echo "${C_BLU}[*]${C_OFF} Bağlantı testi: (redacted) db=$DBNAME"
if ! sqlcmd -S "$SQLCMDSERVER" -U "$SQLCMDUSER" -P "$SQLCMDPASSWORD" -d "$DBNAME" \
            -l 10 -t 10 -Q "SELECT @@VERSION;" -h -1 -W >/dev/null 2>"$OUT_DIR/_connection-test.err"; then
  echo "${C_RED}[X]${C_OFF} Bağlantı başarısız. Hata logu: $OUT_DIR/_connection-test.err"
  cat "$OUT_DIR/_connection-test.err"
  exit 2
fi
echo "${C_GREEN}[+]${C_OFF} Bağlantı OK"

# Demo veritabanı setup
if [[ -f "$SETUP_SQL" ]]; then
  echo "${C_BLU}[*]${C_OFF} Setup: $SETUP_SQL"
  if sqlcmd -S "$SQLCMDSERVER" -U "$SQLCMDUSER" -P "$SQLCMDPASSWORD" -d "$DBNAME" \
            -b -l 30 -t 60 -i "$SETUP_SQL" > "$OUT_DIR/_setup.txt" 2>&1; then
    echo "${C_GREEN}[+]${C_OFF} Setup tamam"
  else
    echo "${C_YEL}[!]${C_OFF} Setup hatalı, devam ediliyor (bkz: $OUT_DIR/_setup.txt)"
  fi
fi

# Hangi bölümler koşulacak?
if [[ $# -gt 0 ]]; then
  BOLUMLER=("$@")
else
  # bolum-01..32 sıralı liste
  BOLUMLER=()
  for d in "$CODE_DIR"/bolum-*; do
    [[ -d "$d" ]] && BOLUMLER+=("$(basename "$d")")
  done
fi

# Sayaçlar
total=0
ok=0
fail=0
empty=0

echo "" > "$SUMMARY"
printf 'SQL Server 2025 kitap kod doğrulama özeti — %s\n' "$(date)" >> "$SUMMARY"
printf 'Server: (redacted) | DB: %s\n\n' "$DBNAME" >> "$SUMMARY"

# Bölüm bazında koşturma
for bolum in "${BOLUMLER[@]}"; do
  bdir="$CODE_DIR/$bolum"
  if [[ ! -d "$bdir" ]]; then
    echo "${C_YEL}[!]${C_OFF} Bölüm yok: $bolum (atlanıyor)"
    continue
  fi

  # Bölüm numarası: bolum-01 → 01
  bnum="${bolum##bolum-}"

  # Klasördeki .sql sayısı
  sql_count=$(find "$bdir" -maxdepth 1 -name '*.sql' | wc -l | tr -d ' ')
  if [[ "$sql_count" == "0" ]]; then
    echo "${C_YEL}[ ]${C_OFF} $bolum: boş, atlandı"
    echo "$bolum: boş (kod örneği yok)" >> "$SUMMARY"
    ((empty++))
    continue
  fi

  echo "${C_BLU}[*]${C_OFF} $bolum ($sql_count script)"
  printf '\n[%s]\n' "$bolum" >> "$SUMMARY"

  # Her .sql dosyası sıralı çalışsın
  for sql in $(find "$bdir" -maxdepth 1 -name '*.sql' | sort); do
    fname="$(basename "$sql" .sql)"  # 01-vector-tipi-temel
    snum="${fname%%-*}"               # 01
    out="$OUT_DIR/ch${bnum}-${snum}.txt"

    ((total++))

    {
      printf -- '-- Kaynak: %s\n' "${sql#$ROOT/}"
      printf -- '-- Çalıştırma: %s\n' "$(date)"
      printf -- '-- DB: %s\n\n' "$DBNAME"
    } > "$out"

    # Kurumsal DB isimlerini maskelemek için opsiyonel pattern:
    #   export REDACT_DB_PATTERN='myproject|myproject_test'
    if sqlcmd -S "$SQLCMDSERVER" -U "$SQLCMDUSER" -P "$SQLCMDPASSWORD" -d "$DBNAME" \
              -b -l 30 -t 120 -I -i "$sql" 2>&1 \
       | SRV="$SQLCMDSERVER" USR="$SQLCMDUSER" \
         REDACT_DB_PATTERN="${REDACT_DB_PATTERN:-}" perl -pe '
            s/\Q$ENV{SRV}\E/(redacted-server)/g;
            s/\b\Q$ENV{USR}\E\b/(redacted-user)/g;
            if (length $ENV{REDACT_DB_PATTERN}) {
                my $pat = $ENV{REDACT_DB_PATTERN};
                s/$pat/(redacted-db)/g;
            }
         ' >> "$out"; then
      echo "  ${C_GREEN}[+]${C_OFF} ch${bnum}-${snum}: $fname"
      printf '  OK   ch%s-%s : %s\n' "$bnum" "$snum" "$fname" >> "$SUMMARY"
      ((ok++))
    else
      echo "  ${C_RED}[X]${C_OFF} ch${bnum}-${snum}: $fname (bkz: $out)"
      printf '  FAIL ch%s-%s : %s\n' "$bnum" "$snum" "$fname" >> "$SUMMARY"
      ((fail++))
    fi
  done
done

# Özet
{
  printf '\n--- Özet ---\n'
  printf 'Toplam koşulan: %d\n' "$total"
  printf 'Başarılı     : %d\n' "$ok"
  printf 'Başarısız    : %d\n' "$fail"
  printf 'Boş bölüm    : %d\n' "$empty"
} >> "$SUMMARY"

echo ""
echo "${C_BLU}=== Özet ===${C_OFF}"
echo "Toplam: $total | ${C_GREEN}OK: $ok${C_OFF} | ${C_RED}FAIL: $fail${C_OFF} | Boş: $empty"
echo "Detay: $SUMMARY"

# Exit kodu: hata varsa 1
if [[ "$fail" -gt 0 ]]; then
  exit 1
fi
