#!/usr/bin/env bash
set -euo pipefail

# 1. Git init if needed
if [ ! -d .git ]; then
  git init
  git branch -M main
fi

# 2. Placeholder assets so the build never fails on missing files
mkdir -p assets/sounds assets/models
[ -f "assets/sounds/water_drop.mp3" ] || printf '\x00' > "assets/sounds/water_drop.mp3"

MODELS="squat pushup plank lunge glute_bridge hip_thrust jumping_jacks \
mountain_climber burpee high_knees wall_sit side_plank superman bird_dog \
donkey_kick tricep_dip barbell_squat leg_press rdl leg_curl calf_raise \
bench_press incline_press cable_fly lat_pulldown seated_row barbell_row \
deadlift shoulder_press lateral_raise face_pull bicep_curl hammer_curl \
pushdown hanging_leg_raise cable_crunch"

for m in $MODELS; do
  [ -f "assets/models/$m.glb" ] || printf '\x00' > "assets/models/$m.glb"
done

# 3. Native raw notification sound
mkdir -p android/app/src/main/res/raw
[ -f "android/app/src/main/res/raw/water_drop.mp3" ] || cp assets/sounds/water_drop.mp3 android/app/src/main/res/raw/water_drop.mp3

# 4. Workflow file
mkdir -p .github/workflows
cat > .github/workflows/build-apk.yml <<'YAML'
name: Build PlateWise APK
on:
  push: { branches: [main] }
  workflow_dispatch:
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with: { distribution: temurin, java-version: '17' }
      - uses: subosito/flutter-action@v2
        with: { flutter-version: '3.24.0', channel: stable, cache: true }
      - run: flutter pub get
      - run: flutter build apk --release
      - run: |
          mkdir -p out
          cp build/app/outputs/flutter-apk/app-release.apk out/PlateWise-universal.apk
      - uses: actions/upload-artifact@v4
        with:
          name: PlateWise-APK
          path: out/*.apk
          retention-days: 30
YAML

# 5. Commit
git add .
git commit -m "Bootstrap: workflow + placeholder assets" || true

echo
echo "Done. Now push:"
echo "  git remote add origin https://github.com/<you>/platewise.git"
echo "  git push -u origin main"
echo
echo "Then open https://github.com/<you>/platewise/actions"
