# tsini-get-radio-ekpompi

help() {
  echo ""
  echo "Run the script by providing the base url, which has the form:"
  echo "https://audio6.mixcloud.com/secure/dash2/b/9/d/e/77f2-f2ef-4a64-a9cf-2e2f7b5e405a.m4a/init-a1-x3.mp4;"
  echo "Beware of the init part. This must be the initial part of the segments".
  echo "You can filter in the browser dev tools with init".
  echo "You can get the number of segments by moving to the end and checking the requests".
  echo "The following segments is asserted to have an m4s extension. Beware!!!!"
  echo ""
  echo "Example usage:"
  echo "$0 <numberOfSegments> <url>"
  echo ""
}

if [ ! "$2" ]; then
  help
  exit 1
fi


tmpDir=/tmp/tsini/radio
echo "Creating tmp dir: $tmpDir"
mkdir -p $tmpDir
cd $tmpDir
rm -rf ./*

# Set the variables.
numberOfSegments="$1"
url="$2"

echo -e "\n Getting the initial segment"
curl -o 0.mp4 "$url"

echo -e "\n Getting the following segments"
seq "$numberOfSegments" | while read -r n; do
  # Replacing init with the fragment-number, and the extension.
  tmpUrl=$(echo "$url" | sed "s|init|fragment-${n}|g; s|mp4|m4s|")
  echo "tmpUrl: $tmpUrl"
  curl -s -o "${n}.mp4" "${tmpUrl}"
done

echo -e "\n Creating the output.m4a"
cat $(ls -1 | grep mp4 | sort -g | xargs) >output.mp4

vlc ./output.mp4
