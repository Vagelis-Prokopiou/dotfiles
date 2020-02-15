user="va";
user_home="/home/${user}";

export PATH=$PATH:~/bin;
export PATH=$PATH:~/.cargo/bin;

# The following is for the tesseract build from source.
export TESSDATA_PREFIX=/usr/local/share/tessdata; 

# Drupal Console
if [[ -f ~/.console/console.rc ]]; then
    . ~/.console/console.rc 2>/dev/null;
fi

# Add git completion.
if [[ -f ~/git-completion.bash ]]; then
    . ~/git-completion.bash;
fi

# Site aliases
if [[ -f ~/.sites_aliases ]]; then
    . ~/.sites_aliases;
fi

# Aliases
# alias code='code --user-data-dir=/tmp';

alias rider="$(find ${user_home}/jetbrains -type f -iname rider.sh)";
alias clion="$(find ${user_home}/jetbrains -type f -iname clion.sh)";
alias phpstorm="$(find ${user_home}/jetbrains -type f -iname phpstorm.sh)";
alias datagrip="$(find ${user_home}/jetbrains -type f -iname datagrip.sh)";

alias update="echo ${USER} | sudo -S bash ~/bin/update.sh";
alias karma='su va -c "npm run test:karma"';

# Git stuff:
alias gc='git commit --signoff -m ';
alias gs='clear && git status';
alias grh='clear && git reset --hard';
alias gl='clear && git log --oneline';
alias gba='clear && git branch --all';
alias gcf='git checkout -- ';
alias ga='git add ';
alias git-show-tracked-files='clear && git ls-tree --full-tree -r --name-only HEAD';
alias gstf='git-show-tracked-files';

# Postgresql
alias psql='sudo -u postgres psql';
alias torrents='cd /media/va/local_disk/TORRENTS';

# Create a patch (diff) file, for only the tracked files of the repository.
# Useful when the master branch tracks for files than the current branch.
function git-diff-master() {
	clear;
    alias git-show-tracked-files='git ls-tree --full-tree -r --name-only HEAD';
    for file in $(git-show-tracked-files); do
        # Make sure you skip .gitignore.
        if [[ ! $file = '.gitignore'  ]]; then
            git diff master $file >> $(git rev-parse --abbrev-ref HEAD).patch;
        fi
    done
}
# Create a formatted git patch.
function git-patch-formatted() {
	clear;
    if [[ $1 && $2 ]]; then
        branchName="$1";
        patchName="$2";
        # Remove a pre-existing patch.
        rm "${patchName}".patch 2> /dev/null;
        git format-patch --binary "${branchName}" --stdout > "${patchName}".patch;
        # Removing the last unnecessary line. Act only after the "--" line.
        sed -i '/^--/,$ {/windows/d}' "${patchName}".patch;
        echo "The ${patchName}.patch was created successfully.";
    else
        echo "Usage: git-format branchName patchName";
    fi
}

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# ffmpef stuff
function ffmpeg-convert-to-mp4()
{
	mkdir mp4Folder;
	for file in $(find ./ -type f); do ffmpeg -i "$file" ./mp4Folder/"${file%.*}.mp4"; done;
}

function ffmpeg-record-with-audio()
{
	cd ~/Videos;
	ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0 -f pulse -ac 2 -i default recording.mp4;
}

function ffmpeg-subtitles-add-soft()
{
    if [[ "$1" && "$2" ]]; then
        videoFile="${1}";
        subtitlesFile="${2}";
        ffmpeg -i "${videoFile}" -i ${subtitlesFile} -c copy -c:s mov_text output.mp4;
    else
        echo "Usage: ffmpeg-subtitles-add-soft <videoFile> <subtitlesFile>";
    fi
}

function ffmpeg-subtitles-add-hard()
{
    if [[ "$1" && "$2" ]]; then
        videoFile="${1}";
        subtitlesFile="${2}";
        ffmpeg -i "${videoFile}" -vf subtitles="${subtitlesFile}" output.mp4;
    else
        echo "Usage: ffmpeg-subtitles-add-hard <videoFile> <subtitlesFile>";
    fi
}

function ffmpeg-subtitles-extract-from-mkv() 
{
    if [[ $1 ]]; then
        videoFile=$1;
        subtitles=$(ffprobe "${videoFile}" |& grep Subtitle | awk '{ print $2 }' | sed 's/#//; s/):/)/');

        for i in $subtitles; do
            stream=$(echo $i | sed "s|(.*||");
            language=$(echo $i | sed "s|^.*(||; s|)||");
            ffmpeg -y -i ""${videoFile}"" -map "$stream" ""${videoFile}"-$language.srt";
        done;
    else
        echo 'Usage: ffmpeg-subtitles-extract-from-mkv <videoFile>';
    fi
}

function ffmpeg-video-audio-from-multiple-streams() 
{
    if [[ "$1" && "$2" && "$3" ]]; then
        videoFile=${1};
        videoStream="${2}";
        audioStream="${3}";
        ffmpeg -i "${videoFile}" -vf subtitles=${subtitlesFile} outfile-with-subs.mp4;
        ffmpeg -i "${videoFile}" -map 0:$videoStream -map 0:$audioStream -c copy output.mp4;
    else
        echo "Usage: ffmpeg-video-audio-from-multiple-streams <videoFile> <videoStream> <audioStream>";
    fi
}

function ffmpeg-video-extract-from-dvd()
{
    echo '1. Find out which VOB files contain the movie.';
    echo '2. Find out which streams are the video and audio (with ffprobe. E.g.: ffprobe VTS_01_1.VOB |& grep Stream).';
    echo '3. Run the resulting command. E.g.: ffmpeg -i "concat:VTS_01_1.VOB|VTS_01_2.VOB|VTS_01_3.VOB" -map 0:1 -map 0:4 -f mpeg -c copy concatenated.mpeg'
    echo '';
    echo 'For more info checkout https://newspaint.wordpress.com/2016/07/27/ripping-a-video-from-dvd-using-ffmpeg/';
}

function ffmpeg-dvd-create()
{
    sudo apt install dvdauthor;
    sudo apt install ffmpeg;
    
    if [[ "$1" ]]; then
        videoFile=$1;
        ffmpeg -i "${videoFile}" -target pal-dvd dvd-video.mpg;
        export VIDEO_FORMAT=PAL;
        dvdauthor -o dvd-folder -t dvd-video.mpg;
        dvdauthor -o dvd-folder -T;
    else
        echo "Usage: ffmpeg-dvd-create <videoFile>";
    fi
}

function ffmpeg-video-resize() {
    # https://trac.ffmpeg.org/wiki/Scaling%20(resizing)%20with%20ffmpeg
    if [[ "$1" && "$2" && "$3" ]]; then
        videoFile="${1}";
        scaleSize="${2}";
        outputFile="${3}";
        ffmpeg -i "${videoFile}" -vf scale=${scaleSize}:-1 "${outputFile}";
    else
        echo "Usage: ffmpeg-video-resize <videoFile> <scaleSize> <outputFile>";
    fi
}

function ffmpeg-video-resize-for-youtube() {
    # https://trac.ffmpeg.org/wiki/Scaling%20(resizing)%20with%20ffmpeg
    # -b:v 2M = bitrate setting
    # -c:a copy = copy audio    

    if [[ "$1" ]]; then
        videoFile="${1}";
        ffmpeg -i "${videoFile}" -b:v 2M -vf scale=854:480 -c:a copy 854x480.mp4;
    else
        echo "Usage: ffmpeg-video-resize-for-youtube <videoFile>";
    fi

    echo "Check https://support.google.com/youtube/answer/1722171 for details."
}

# youtube-dl wrapper
function youtube-dl-best-quality() {
	if [[ "${1}" ]]; then
		youtube-dl -f bestvideo+bestaudio "${1}";
	else
		echo "Usage: youtube-dl-best-quality <URL>";
	fi
}

function youtube-dl-best-quality-for-sony-usb() {
	if [[ "${1}" ]]; then
		for video in $(cat "${1}");
		do
			youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 "$video";
		done

		clean-filenames;
	else
		echo "Usage: youtube-dl-best-quality-for-sony-usb <file>";
	fi
}

function youtube-dl-best-quality-audio() {
	if [[ "${1}" ]]; then
		youtube-dl -f 251 "${1}";
	else
		echo "Usage: youtube-dl-best-quality-audio <URL>";
	fi
}

function drush-siteInstall()
{
	# See: https://drushcommands.com/drush-8x/core/site-install/
	if [[ "$1" ]]; then
		drush si standard --site-name="$1" --account-pass=admin  --db-url=mysql://root:root@localhost:3306/"$1";
	else
		echo "Usage: drush-siteInstall <databaseName>";l
	fi
}

function setPermissions-ToApacheUser() {
    sudo chown -R www-data:www-data /var/www/html;
    sudo chmod -R 777 sites/default/files;
}

function setPermissions-ForFilesFolders() {
    find ./ -type d -exec chmod 775 "{}" \;
    find ./ -type f -exec chmod 644 "{}" \;
}

# Test it
function string-substitute()
{
    if [[ -n "${3}" ]]; then
        find . -type f -name "${1}" -exec sed -i "s/${2}/${3}/g" "{}" \;;
    else
        echo "Usage: sed-substitute <fileType> <sourceString> <targetString>";
        clear && ls -F --color=auto --show-control-chars --color=auto -lAh;
    fi
}

# DotNet
function fix-corrupted-new-dotnet-command()
{
    dotnet new --debug:reinit;
    echo -e '\nTry the fix: "dotnet new console -lang c# appName"';
}

# apt
function apt-fix()
{
	sudo apt --fix-broken install -y;
}

function show-non-printing-characters()
{
	if [[ "$1" ]]; then
		cat -A "$1";
	else
		echo 'Usage: show-non-printing-characters <file>';
	fi
}

function convert-to-unix-line-endings()
{
	if [[ "$1" ]]; then
		dos2unix "$1";
	else
		echo 'Usage: convert-to-unix-line-endings <file>';
	fi
}

function teamviewer-start()
{
    service teamviewerd restart;
}

function ripgrep-install-latest()
{
    system="$(uname)";
    ripGrepUrl="https://github.com/BurntSushi/ripgrep/releases";
    latestVersion=$(curl ${ripGrepUrl} 2> /dev/null | grep '<a href="/BurntSushi/ripgrep/tree/' | head -1 | sed 's/" class="css-truncate">//ig;s/<a href="\/BurntSushi\/ripgrep\/tree\///ig;s/ \+//g');
    installedVersion=$(rg --version | awk '{print $2}' | head -n1);
    windowsDownloadUrl="https://github.com/BurntSushi/ripgrep/releases/download/${latestVersion}/ripgrep-${latestVersion}-x86_64-pc-windows-gnu.zip";
    linuxDownloadUrl="https://github.com/BurntSushi/ripgrep/releases/download/${latestVersion}/ripgrep-${latestVersion}-x86_64-unknown-linux-musl.tar.gz";

    if [[ "${latestVersion}" != "${installedVersion}" ]]; then
        echo -e "\nDownloading the latest version...\n";

        if [[ ${system} == MINGW* ]]; then
            curl -L -o latestRipGrep.zip "${windowsDownloadUrl}";
            unzip latestRipGrep.zip -d latestRipGrep;
            cp latestRipGrep/rg.exe /C/Users/Vangelisp/bin;
        else
            curl -L -o latestRipGrep.zip.gz "${linuxDownloadUrl}";
            tar xvzf latestRipGrep.zip.gz;
            cp ripgrep-*/rg /usr/local/bin;
            cp ripgrep-*/complete/rg.bash /etc/bash_completion.d;
        fi

        rm -rf latestRipGrep* ripgrep-*;
    else
        echo -e "\nYou are using the latest version (${latestVersion}).\n";
    fi
}

function drush-install-latest()
{
    application="Drush";
    githubUrl="https://github.com/drush-ops/drush/releases";
    latestVersion=$(curl ${githubUrl} | grep '<a href="/drush-ops/drush/releases/download/' | head -1 | sed 's/<a href="\/drush-ops\/drush\/releases\/download\///g; s/\/drush.phar" rel="nofollow">//g; s/ \+//g');
    installedVersion=$(drush --version | sed 's/ Drush Version   :  //i; s/ \+//g');
    downloadUrl="https://github.com/drush-ops/drush/releases/download/${latestVersion}/drush.phar";

    if [[ "${latestVersion}" != "${installedVersion}" ]]; then
        echo -e "\nDownloading the latest ${application} version...\n";

        curl -L -O "${downloadUrl}";
        php drush.phar core-status;
        chmod +x drush.phar;
        sudo mv drush.phar /usr/local/bin/drush;
        drush init;
    else
        echo -e "\nYou are using the latest ${application} version (${latestVersion}).\n";
    fi
}

function drupal-rename-module()
{
	if [[ "$3" ]]; then
		path="$1";
        old_name="$2";
        new_name="$3";
        new_path=$(echo "${path}" | sed "s/${old_name}/${new_name}/g")
        old_name_upper="$(tr '[:lower:]' '[:upper:]' <<< ${old_name:0:1})${old_name:1}";
        new_name_upper="$(tr '[:lower:]' '[:upper:]' <<< ${new_name:0:1})${new_name:1}";
        find "${path}" -name "*${old_name}*" -print0 | sort -rz |  while read -d $'\0' f;
        do mv -v "${f}" "$(dirname "${f}")/$(basename "${f//${old_name}/${new_name}}")";
        done;
        find "${new_path}" -type f -exec sed -i "s/${old_name}/${new_name}/g;
        s/${old_name_upper}/${new_name_upper}/g" "{}" \+;
	else
		echo 'Usage: drupal-rename-module <modulePath> <oldName> <newName>';
	fi
}

function vscode-black-bg()
{
	fileName='monokai-color-theme.json';
	if [[ $(uname -s) == "MINGW"* ]]; then
		find /c/Users/Vangelisp/Downloads -type f -name ${fileName} -exec sed -i 's/"editor\.background":.\+/"editor\.background": "#000000",/g' "{}" \;
	else
		find /root -type f -name ${fileName} -exec sed -i 's/"editor\.background":.\+/"editor\.background": "#000000",/g' "{}" \;
		find /home -type f -name ${fileName} -exec sed -i 's/"editor\.background":.\+/"editor\.background": "#000000",/g' "{}" \;
	fi
}

function motogp-download-race()
{
	# 1. Download the first json file (filter by XHR).
	# 2. From this json, get the first m3u8, delete the "\" slashes, and go to the url. A new file (master.m3u8) will be downloaded.
	# 3. Copy the last URL from the master.m3u8 and paste in the browser. Tha final file (index_4_av.m3u8) with get downloaded.

    if [[ "$1" ]]; then
	touch ./motogpFiles.txt;
    counter=1;
    while read line; do
        if [[ "$line" == "http"*  ]]; then
            curl --silent -o ${counter}.mp4 "$line";
			echo "file ${counter}.mp4" >> ./motogpFiles.txt;
            ((counter++));
        fi
    done < "$1";

	ffmpeg-concat-files ./motogpFiles.txt race.mp4;
    else
        echo 'Usage: motogp-download-race <file.m3u8>'
    fi
}

function get-gpu-info()
{
    reset;
    lspci -v | grep -A19 'VGA compatible controller';
}

function get-database-server-info() {
    mysql --version | awk '{print $5}' | sed 's/,//g';
}

function get-release-info() {
    lsb_release -a 2>/dev/null | grep Description;
    echo "Database server: $(get-database-server-info)";
    echo "Kernel release: $(uname -r)";
}

function perl-example()
{
    echo '';
    echo "Example 1: curl https://google.com 2> /dev/null | perl -ne 'if (/(302)/) { print \"\$1\\n\" }';";
    echo "Example 2: perl -ne 'if (/(regexExpression)/) { print \"\$1\\n\" }' <file>;";
    echo "The -e flag provides an inline program to Perl.";
    echo "The -n flag runs the -e on every input line, without printing the current line. Use -p if you want to print it.";
    echo "Quantifiers:";
    echo "  * matching 0 or more occurrence.";
    echo "  + matching 1 or more occurrence.";
    echo "  ? matching 0 or 1 occurrence (used for non greedy matches).";
}

function string-to-binary()
{
    if [[ "$1" ]]; then
        # 00001010 = 10 = new line
        echo "$1" | xxd -b | sed "s/00000000:\s*//g; s/\s*00001010//g; s/\.//; s/\s*$1/ -> $1/";
    else
        echo 'Usage: string-to-binary <string>'
    fi
}

function string-to-hex()
{
    if [[ "$1" ]]; then
        # 0a || 0A = 10 = new line
        echo "$1" | xxd | sed "s/00000000:\s*//g; s/\s*0[aA]//g; s/\.//; s/\s*$1/ -> $1/";
    else
        echo 'Usage: string-to-hex <string>'
    fi
}

function drupal-module-rename() {
    if [ -z "$2" ]; then
        echo "Usage: module-rename <old-module-name> <new-module-name>";        
    else
        old_name="$1";
        path=$(find . -type d -name ${old_name});
        new_name="$2";
        new_path=$(echo "$path" | sed "s/$old_name/$new_name/g");
        old_name_upper_first_char="$(tr '[:lower:]' '[:upper:]' <<< ${old_name:0:1})${old_name:1}";
        new_name_upper_first_char="$(tr '[:lower:]' '[:upper:]' <<< ${new_name:0:1})${new_name:1}";
        old_name_upper=$(echo "$old_name" | awk '{ print toupper($0) }');
        new_name_upper=$(echo "$new_name" | awk '{ print toupper($0) }');
        
        # Move the lowercase files.
        find "$path" -name "*$old_name*" -print0 | sort -rz |  while read -d $'\0' f;
            do mv "$f" "$(dirname "$f")/$(basename "${f//$old_name/$new_name}")";
        done;

        # Move the upper_first_char files.
        find "$new_path" -name "*$old_name_upper_first_char*" -print0 | sort -rz |  while read -d $'\0' f;
            do mv "$f" "$(dirname "$f")/$(basename "$f" | sed "s|$old_name_upper_first_char|$new_name_upper_first_char|g")";
        done;

        # Replace the old strings.
        find "$new_path" -type f -exec sed -i "s/$old_name/$new_name/g; \
        s/$old_name_upper_first_char/$new_name_upper_first_char/g; \
        s/$old_name_upper/$new_name_upper/g" "{}" \;    
    fi;
}

function viber-clean() {
	find ${user_home}/.ViberPC/ ${user_home}/Documents/ViberDownloads/ \( -iname "*jpg" -or -iname "*png*" -or -iname "*jpeg" -or -iname "*gif" -or -iname "*mp4" \) -delete;
}

function get-vscode-settings() {
    curl -s -o "$HOME/.config/Code/User/settings.json" https://raw.githubusercontent.com/Vagelis-Prokopiou/vscode-settings/master/settings.json
}
