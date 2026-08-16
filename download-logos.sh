#!/usr/bin/env bash
# Give Israel — download charity logos from the old Supabase Storage bucket
# into public/logos/ so the site no longer depends on the database.
#
# Run this from the project root:   ./download-logos.sh

set -u

cd "$(dirname "$0")" || exit 1
mkdir -p public/logos

ok=0
fail=0

download() {
  url="$1"
  name="$2"
  if curl -fsSL --retry 2 --max-time 60 -o "public/logos/$name" "$url"; then
    echo "OK      $name"
    ok=$((ok + 1))
  else
    echo "FAILED  $name  <-  $url"
    rm -f "public/logos/$name"
    fail=$((fail + 1))
  fi
}

echo "Downloading 50 charity logos into public/logos/ ..."
echo
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/aleh.png" "aleh.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/birthright-israel.png" "birthright-israel.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/fidf.svg" "fidf.svg"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/galilee-ecocenter.png" "galilee-ecocenter.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/israel-trauma-coalition.png" "israel-trauma-coalition.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/jnf.png" "jnf.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/leket-israel.png" "leket-israel.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/lone-soldier-center.png" "lone-soldier-center.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/magen-david-adom.png" "magen-david-adom.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/meir-panim.webp" "meir-panim.webp"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/nefesh-bnefesh.png" "nefesh-bnefesh.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/onefamily.png" "onefamily.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/save-a-childs-heart.svg" "save-a-childs-heart.svg"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/technion.png" "technion.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/united-hatzalah.png" "united-hatzalah.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/yemin-orde.png" "yemin-orde.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/akim-israel.png" "akim-israel.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/amcha.png" "amcha.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/awis-soldiers.png" "awis-soldiers.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/beit-issie-shapiro.jpg" "beit-issie-shapiro.jpg"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/bnei-akiva.png" "bnei-akiva.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/centre-holocaust-survivors.png" "centre-holocaust-survivors.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/elem.png" "elem.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/emunah.svg" "emunah.svg"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/freedom-farm-sanctuary.png" "freedom-farm-sanctuary.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/aftau.jpg" "aftau.jpg"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/hadassah-medical.svg" "hadassah-medical.svg"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/hasoub.png" "hasoub.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/hebrew-university.png" "hebrew-university.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/ican.jpg" "ican.jpg"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/idf-widows-orphans.png" "idf-widows-orphans.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/guide-dog-center.png" "guide-dog-center.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/israel-museum.png" "israel-museum.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/israel-philharmonic.png" "israel-philharmonic.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/kayan-feminist.png" "kayan-feminist.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/krembo-wings.svg" "krembo-wings.svg"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/latet.svg" "latet.svg"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/let-animals-live.png" "let-animals-live.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/naamat.png" "naamat.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/natal.png" "natal.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/ort-israel.png" "ort-israel.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/pantry-packers.png" "pantry-packers.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/shekel.jpg" "shekel.jpg"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/spca-israel.svg" "spca-israel.svg"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/spni.svg" "spni.svg"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/holocaust-foundation.png" "holocaust-foundation.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/tzohar.png" "tzohar.png"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/yad-eliezer.gif" "yad-eliezer.gif"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/zaka.svg" "zaka.svg"
download "https://psrtcjaxfeutecirypwd.supabase.co/storage/v1/object/public/charity-logos/zalul.png" "zalul.png"

echo
echo "----------------------------------------"
echo "Downloaded: $ok"
echo "Failed:     $fail"
echo "Total:      50"
echo "Files are in: public/logos/"

if [ "$fail" -gt 0 ]; then exit 1; fi
