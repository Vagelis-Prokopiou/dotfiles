find ~/projects/ -type d \( -name "target" -o -name "target-local" \) -prune -exec sh -c '
  for dir; do
    echo "Deleting $dir"
    sudo rm -rf "$dir"
  done
' _ {} +
