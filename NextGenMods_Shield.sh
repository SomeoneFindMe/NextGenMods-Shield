#!/bin/bash

# --- COLOR DEFINITIONS ---
R='\e[1;31m'
G='\e[1;32m'
Y='\e[1;33m'
B='\e[1;34m'
P='\e[1;35m'
C='\e[1;36m'
W='\e[1;37m'
N='\e[0m'

# --- SMART PATH DETECTOR ---
if [ -z "$1" ]; then
    echo -e "${R}[!] ERROR: Please provide the APK path!${N}"
    echo -e "${Y}Usage: ./NextaGen_Shield.sh /sdcard/Download/your_app.apk${N}"
    exit 1
fi

TARGET_APK=$(realpath "$1")
APK_DIR=$(dirname "$TARGET_APK")

if [ ! -f "$TARGET_APK" ]; then
    echo -e "${R}[!] ERROR: APK not found at '$TARGET_APK'${N}"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- YOUR DETAILS ---
MY_NAME="𑲭𑲭𑲭𑲭𑲭𑲭𑲭𑲭◄⏤‌‌🦋꯭𝆺𝅥⃝꯭S‌‌‌‌‌‌om‌‌‌‌‌‌‌‌‌‌‌‌‌e‌o‌‌‌‌‌‌‌‌‌‌‌‌‌‌‌‌‌‌n‌‌e⏤‌‌🦋꯭"
GH_LINK="https://github.com/SomeoneFindMe"
TG_LINK="https://t.me/NextGenModsOfficial"
YT_LINK="https://youtube.com/@nextgenmodsofficial"

clear

# --- 1. SHOW THE SLEEK BANNER ---
echo -e "${C}╭───────────────────────────────────────────╮${N}"
echo -e "${C}│           ${P}ℕ 𝔼 𝕏 𝕋 𝔾 𝔼 ℕ 𝕄 𝕆 𝔻 𝕊${C}           │${N}"
echo -e "${C}│          ${Y}N a t i v e   S h i e l d${C}          │${N}"
echo -e "${C}╰───────────────────────────────────────────╯${N}"
echo ""
echo -e "${P}◈ CREATOR:${N} ${Y}$MY_NAME${N}"
echo -e "${P}◈ ORIGIN: ${N} ${G}West Bengal, India${N}"
echo -e "${P}◈ SKILLS: ${N} ${W}Reverse Engineering & Modding${N}"
echo ""
echo -e "${C}[ NETWORK ]${N}"
echo -e "${B}▪ GitHub:   ${W}SomeoneFindMe${N}"
echo -e "${B}▪ Telegram: ${W}NextGenModsOfficial${N}"
echo -e "${B}▪ YouTube:  ${W}NextGenModsOfficial${N}"
echo -e "${C}─────────────────────────────────────────────${N}"
echo ""

termux-open-url "$GH_LINK"
sleep 1

# --- 2. PRE-PROCESSING: KEYSTORE GENERATION ---
echo -e "${Y}▶ Preparing Auto-Signer & stripping old signatures...${N}"
zip -q -d "$TARGET_APK" "META-INF/*" > /dev/null 2>&1

KEYSTORE_PATH="$SCRIPT_DIR/shield.keystore"
rm -f "$KEYSTORE_PATH"
# Generate a silent, temporary keystore for auto-signing
keytool -genkey -v -keystore "$KEYSTORE_PATH" -alias shield -keyalg RSA -keysize 2048 -validity 10000 -storepass nextgen123 -keypass nextgen123 -dname "CN=NextGenMods, OU=Modding, O=NextGen, L=West Bengal, C=IN" > /dev/null 2>&1

# --- 3. DYNAMIC CONFIG WITH SIGNATURE INCLUDED ---
cat <<JSON > "$SCRIPT_DIR/config.json"
{
  "shellPkgName" : "com.NextaGenMod.Official",
  "signature" : { 
      "keystore" : "$KEYSTORE_PATH", 
      "alias" : "shield", 
      "storepass" : "nextgen123", 
      "keypass" : "nextgen123" 
  }
}
JSON

# --- 4. START PRODUCTION ENGINE ---
echo -e "${C}▶ Target Locked: ${W}$(basename "$TARGET_APK")${N}"
sleep 1
echo -e "${C}▶ Injecting Native Shield: com.NextaGenMod.Official${N}"

# TOTAL SILENCE ENGINE
java -jar "$SCRIPT_DIR/dpt.jar" -c "$SCRIPT_DIR/config.json" -o "$APK_DIR" -f "$TARGET_APK" > /dev/null 2>&1 &
PID=$!

while kill -0 $PID 2>/dev/null; do
    echo -ne "${P}▶ Processing & Auto-Signing... [#####-----] 50%\r"
    sleep 2
    echo -ne "${G}▶ Finalizing Core...           [#########-] 90%\r"
    sleep 2
done

# --- 5. AUTOMATIC CLEANUP & TRASH REMOVAL ---
echo -ne "${Y}▶ Sweeping unzipped files and unsigned APKs...${N}\r"
sleep 1
# Delete config and keystore from the script folder
rm -f "$SCRIPT_DIR/config.json"
rm -f "$KEYSTORE_PATH"

# Delete unsigned APKs and unzipped folders from your target directory
find "$APK_DIR" -type f -name "*_unsigned.apk" -delete
find "$APK_DIR" -type d -name "*unzip*" -exec rm -rf {} +
find "$APK_DIR" -type d -name ".*unzip*" -exec rm -rf {} +

# --- 6. SUCCESS PHASE ---
echo -e "${G}▶ PRODUCTION FINISHED!         [##########] 100%${N}"
echo ""
echo -e "${C}─────────────────────────────────────────────${N}"
echo -e "${G}✔ SUCCESS: Clean & SIGNED APK saved in:${N}"
echo -e "${W}  $APK_DIR${N}"
echo -e "${C}─────────────────────────────────────────────${N}"

termux-open-url "$TG_LINK"
sleep 1
termux-open-url "$YT_LINK"

