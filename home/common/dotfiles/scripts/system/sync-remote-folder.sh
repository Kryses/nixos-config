cd /home/kryses/work/repos/ayon-workspace/addons
inotifywait -m -r --format '%e %w%f' \
  --exclude '(\.git/|\.kryses/|\.mypy_cache|__pycache__/|\./null-ls/.*/)' \
  -e modify -e create -e move -e delete "./$1" |
  while read -r event filename; do
    echo "Event: $event"
    echo "Filename: $filename"
    start=$(date +%s%N)
    rsync -azuptEP --delete \
      --exclude='**/.git' \
      --exclude='**/.kryses' \
      --exclude='**/.mypy_cache' \
      --exclude='**/.venv' \
      --exclude='**/__pycache__' \
      --exclude='**/package' \
      --exclude='**/*.pyc' \
      --include='*/' \
      --include='**/*.py' \
      --include='**/*.pyd' \
      --include='**/*.pyi' \
      --include='**/*.json' \
      --include='**/*.html' \
      --include='**/*.js' \
      --include='**/*.css' \
      --include='**/*.mel' \
      --include='**/*.mll' \
      --include='**/*.png' \
      --include='**/*.jpg' \
      --include='**/*.ini' \
      --include='**/*.env*' \
      --include='**/*.zip*' \
      --include='**/*.ui*' \
      --exclude='*' \
      "./$1" \
      kryses@10.205.42.100:/mnt/e/development/ayon-workspace/addons

    end=$(date +%s%N)
    runtime=$((end - start))
    seconds=$(($runtime / 1000000000))
    echo "Sync ran in: $seconds seconds"
  done
