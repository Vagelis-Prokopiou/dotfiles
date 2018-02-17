user="va";
user_home="/home/${user}";

# GO stuff.
mkdir ${user_home}/go/ 2> /dev/null;
export PATH=$PATH:/usr/local/go/bin;
export GOPATH=$user_home/go;
export PATH=$PATH:$GOPATH/bin;

# Drupal Console
if [[ -f ~/.console/console.rc ]]; then
    . ~/.console/console.rc 2>/dev/null;
fi

# Add git completion.
if [[ -f ~/git-completion.bash ]]; then
    . ~/git-completion.bash;
fi

# Aliases
alias code='code --user-data-dir=/tmp';
alias jetbrains-server='/media/va/local_disk/Dropbox/JetBrains/LicenceServer.v1.3/*amd64';
alias storm='echo vadead | sudo -S bash /media/va/52AF7EBE182A63E2/jetbrains/PhpStorm/bin/phpstorm.sh';
alias datagrip='echo vadead | sudo -S bash /media/va/52AF7EBE182A63E2/jetbrains/datagrip/bin/datagrip.sh';
alias localhost='cd /var/www/html';

alias tsini='cd /var/www/html/tsinikopoulos/public_html/';
alias tsinigulp='cd /var/www/html/tsinikopoulos/public_html/sites/all/themes/tsinikopoulos && sudo find /usr/lib/node_modules -type f -name "*.info" -exec sudo rm "{}" \+ && modules=$(ls /usr/lib/node_modules) && npm link $modules && gulp';

alias drupaland='cd /var/www/html/drupaland/public_html/';
alias drupalandgulp='cd /var/www/html/drupaland/public_html/themes/drupaland && sudo find /usr/lib/node_modules -type f -name "*.info" -exec sudo rm "{}" \+ && modules=$(ls /usr/lib/node_modules) && npm link $modules && gulp';

alias rs='cd /var/www/html/riggingservices/public_html/';
alias rsgulp='cd /var/www/html/riggingservices/public_html/sites/all/themes/skeletontheme_testing && sudo find /usr/lib/node_modules -type f -name "*.info" -exec sudo rm "{}" \+ && modules=$(ls /usr/lib/node_modules) && npm link $modules && gulp';

alias om='cd /var/www/html/olympus-marathon/public_html && git status';
alias contentimport='cd /var/www/html/contentimport && git status';

alias update='echo vadead | sudo -S bash ~/bin/update.sh';
alias karma='su va -c "npm run test:karma"';

# Git stuff:
alias gc='git commit --signoff -m ';
alias gl='clear && git log --oneline';
alias gcf='git checkout -- ';
alias gs='clear && git status';
alias gba='clear && git branch --all';
alias grh='clear && git reset --hard';
alias ga='git add ';
alias git-show-tracked-files='clear && git ls-tree --full-tree -r --name-only HEAD';
alias gstf='git-show-tracked-files';

# Postgresql
alias 'psql'='sudo -u postgres psql';

function git-show-todays-commits()
{
	reset;
	if [[ "$1" ]]; then
		echo "${1} commits:";
		echo "";
		git log | grep -A2 "${1}" | grep -v Date | grep -v -- '--' | grep -v '^$' | sed 's/^ \+//g';
	else
		echo "Usage: git-show-todays-commits <date> (in \"Dec 5\" format)";
	fi
}

# Fix the '^M' in git diffs. See: http://stackoverflow.com/questions/1889559/git-diff-to-ignore-m
function git-fix-line-endings() {
	clear;
    git config --global core.autocrlf true;
    git rm --cached -r .;
    git diff --cached --name-only -z | xargs -0 git add;
    git commit -m "Fix CRLF";
    echo -e "\n\tRun it per branch.\n";
}

# Show only filenames with differences.
function git-diff-files() {
	clear;
    if [[ "$1" ]]; then
    	echo -e "\n*** Show only the filenames of the files with differences ***\n";
	git diff "$1" | grep -- '--- a/' | sed 's/--- a\///g';
    else
	echo -e "\nUsage: git-diff-files <branch>\n"
    fi
}

# Report from git log.
function git-log-report() {
	clear;
    if [[ "$1" ]]; then
        git log --since="$1" --no-merges --date=format:'%Y-%m-%d, %H:%M' --format='%ad: %s.' > report.txt;
        sed -i 's|\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\(, \)\([0-9]\{2\}:[0-9]\{2\}\)\(: \)\(.*\)|Date: \1 on \3. Task: \5|g' report.txt;
        echo "";
        echo "\"report.txt\" is ready.";
    else
        echo 'Usage: git-create-report <date>';
    fi
}

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
# Delete local and remote branch.
# Delete local and remote branch.
function git-delete-branch() {
	clear;
    # The "git branch -rd origin/<branchName>" removed the local branch reference, when all other failed.
    if [[ $1 ]]; then
        git checkout master 2> /dev/null;
        branch_name="$1";
        echo "Deleting local $branch_name branch...";
        git branch -D "$branch_name";
        echo "Deleting remote $branch_name branch...";
        git push origin --delete "$branch_name";
        # If the develop branch is available switch to it.
        git checkout develop 2> /dev/null;
	# Updates all local branch references.
        git remote prune origin;
        echo "Your current branches are:";
        git branch -a;
    else
        echo "Usage: git-delete-branch <branch_name>"
    fi
}

function git-patch-apply-fromUrl()
{
    if [[ "$1" ]]; then
        curl "${1}" | git apply -v
    else
        echo "Usage: git-patch-apply-fromUrl <url>"
    fi
}

# Site audit stuff:
alias siteaudit7='rm -r ~/.drush/commands/site_audit && unzip ~/.drush/commands/site_audit-7*.zip -d ~/.drush/commands/';
alias siteaudit8='rm -r ~/.drush/commands/site_audit && unzip ~/.drush/commands/site_audit-8*.zip -d ~/.drush/commands/';

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
# Include Drush bash customizations.
if [ -f "/root/.drush/drush.bashrc" ] ; then
  source /root/.drush/drush.bashrc
fi

# Include Drush completion.
if [ -f "/root/.drush/drush.complete.sh" ] ; then
  source /root/.drush/drush.complete.sh
fi

# Include Drush prompt customizations.
if [ -f "/root/.drush/drush.prompt.sh" ] ; then
  source /root/.drush/drush.prompt.sh
fi

# General functions.
# Create a report from a GA csv.
function google-analytics-report() {
    if [[ $1 ]]; then
        sourceFile="$1";
        cat "$sourceFile" | awk -F ',' '{print $1, $2}' | sed "s|/el/άρθρα/|Άρθρο: |g;s|\(\ \)\([0-9]\{1,3\}\)|\. Θεάσεις: \2\.|g" > article_views.txt;
        echo "The article_views.txt was created successfully.";
    else
        echo "Usage: google_analytics_report sourceFile";
    fi
}

# Display the free space remaining in the Linux partition.
function disk-usage() {
    disk_usage=$(df | head -n 2 | tail -n 1);
    if [[ $(uname) == "MINGW"* ]]; then
        echo "Disk usage ($(echo $disk_usage | awk '{ print $1 }')): $(echo $disk_usage | awk '{ print $6 }').";
    else
        echo "Disk usage ($(echo $disk_usage | awk '{ print $1 }')): $(echo $disk_usage | awk '{ print $5 }').";
        # echo "Disk usage ($(df | head -n 2 | tail -n 1 | awk '{ print $1 }')): $(df | head -n 2 | tail -n 1 | awk '{ print $5 }').";
    fi
}

# Docker
function docker-stop-containers()
{
    reset;
    docker stop --time 0 $(docker ps -a -q);
}

function docker-remove-containers()
{
    docker-stop-containers;
    docker rm -f $(docker ps -a -q);
}

function docker-remove-containers-and-images()
{
    docker-remove-containers;
    docker rmi -f $(docker images --quiet); # -q, --quiet Only show numeric ID
}

function docker-get-container-network-settings()
{
    if [[ "$1" ]]; then
        containerID=$(docker ps | grep -i "$1" | awk '{ print $1 }');
        docker inspect "$containerID" | grep -A50 -i 'networksettings';
    else
        echo "Usage: docker-get-container-network-settings <containerName>";
        echo "The avaiable containers are the following:";
        docker ps -a;
    fi
}

# Drupal functions.
# Fix "The following module is missing from the file system..."
# See: https://www.drupal.org/node/2487215
function drupal-fix-missing-module() {
    if [[ $1 ]]; then
        drush sql-query "DELETE from system where name = '"$1"' AND type = 'module';";
    else
        echo "Usage: drupal-fix-missing-module <moduleName>";
    fi
}

function dbs-import() {
    cd  /media/va/local_disk/Dropbox/dbs/*/;
    for db in *; do
        new_db=$( echo "$db" | sed "s|/home/va/Dropbox/dbs/.*/||g; s|\.sql\.gz||g");
        mysql -u root -p'root' -e "CREATE DATABASE IF NOT EXISTS $new_db;";
        zcat "${new_db}.sql.gz" | mysql -u root -p'root' "$new_db";
    done;
    cd ~;
}

function dbs-export() {
    # If Dropbox exits.
    basePath="/media/va/local_disk";
    if [[ -d ${basePath}/Dropbox/ ]]; then
        # If folder for today does not exits, do the backup.
        if [[ ! -d ${basePath}/Dropbox/dbs/$(date +%Y-%m-%d)/ ]]; then
            # ----- Backup all databases -----
            echo ''; \
            echo "----- Exporting the databases to ${basePath}/Dropbox/dbs/$(echo $(date +%Y-%m-%d))/ -----"; \
            echo ''; \
            dbs=$(echo $( mysql -uroot -proot -e 'show databases;') | \
            sed "s/Database//g; s/information_schema//g; \
            s/performance_schema//g; \
            s/sys//g; \
            s/d7//g; \
            s/d8//g; \
            s/mysql//g; \
            s/phpmyadmin//g"; \
            ); \
            mkdir ${basePath}/Dropbox/dbs/$(date +%Y-%m-%d) 2>/dev/null; \
            IFS=' ' read -ra dbs_array <<< "$dbs"; \
            for db in "${dbs_array[@]}"; do \
                mysql -uroot -proot -e "TRUNCATE TABLE $db.watchdog"; \
                mysqldump -uroot -proot "$db" | gzip > ${basePath}/Dropbox/dbs/$(date +%Y-%m-%d)/"$db".sql.gz;
            done;
            echo '';
            echo '----- Databases exported successfully -----';
            echo '';

            # Remove the previous folders.
            find ${basePath}/Dropbox/dbs/* -type d ! -name "$(date +%Y-%m-%d)" -exec rm -r "{}" \+ 2>/dev/null;
        else
            # Refactor the 'if else'.
            sudo rm -rf ${basePath}/Dropbox/dbs/$(date +%Y-%m-%d)/;
            dbs-export;
        fi
    fi

    sudo chown -R ${user}:${user} ${user_home}/;
}

# Vhosts
function vhost-create() {
    if [[ "$1" ]]; then
      base_path='/var/www/html';
      domain="$1";

      if [[ ! -d "${base_path}/${domain}" ]]; then
        sudo mkdir "${base_path}/${domain}";
        sudo mkdir "${base_path}/${domain}/public_html/";
        sudo mkdir "${base_path}/${domain}/logs/";
        # Create an index file.
        echo "<h1>${domain}.local has been created successfully.</h1>" | sudo tee "${base_path}/${domain}/public_html/index.html";

        # Create the Apache config files.
        echo "
<VirtualHost *:80>
    # Enable the site with sudo a2ensite site_name && sudo /etc/init.d/apache2 restart
    ServerName ${domain}.local
    ServerAlias www.${domain}.local
    ServerAdmin ${domain}@localhost
    DocumentRoot /var/www/html/${domain}/public_html
    <Directory /var/www/html/${domain}/public_html/>
      Options Indexes FollowSymLinks
      AllowOverride All
      Require all granted
    </Directory>
    LogLevel info warn
    ErrorLog /var/www/html/${domain}/logs/error.log
    CustomLog /var/www/html/${domain}/logs/access.log combined
</VirtualHost>" | sudo tee "/etc/apache2/sites-available/${domain}.local.conf";

        # Enable the site.
        sudo a2ensite "${domain}.local";
        # Add the vhost to the vhosts file.   
        echo "127.0.0.1   ${domain}.local" | sudo tee --append /etc/hosts;
        # Restart Apache.
        sudo service apache2 restart;
        echo "Done.";
        echo "You can access the site at http://${domain}.local/";
      else
        echo "${domain} already exists. Skipping...";
      fi
    else
      echo "Usage: vhost-create <hostName>"
    fi
}

function vhost-delete() {
    # Todo: Delete from /etc/hosts
    if [[ "$1" ]]; then
        domain="$1";

        if [[ -d "/var/www/html/${domain}" ]]; then
	        # Disable the vhost.
	        sudo a2dissite "${domain}.local";

            # Delete all files associated with this site.
            sudo rm -r /var/www/html/${domain};
            sudo rm "/etc/apache2/sites-available/${domain}.local.conf";

            # Clean the /etc/hosts
            sudo sed -i "/${domain}/d" /etc/hosts;

            # Restart Apache.
            sudo service apache2 restart;
            echo "The ${domain}.local vhost was deleted successfully.";
            echo "Apache was restarted. All set.";
        else
            echo "No such vhost found.";
        fi
    else
        echo "Usage: vhost-delete <hostName>"
    fi
}

function bitbucket-clone-dev-sites() {
    domains=(
        tsinikopoulos
        drupaland
        riggingservices
    );

    domains_length=${#domains[@]};

    for (( i = 0; i < ${domains_length}; i++ )); do
        domain=${domains[$i]};
        vhost-create "$domain";
        sudo rm -rf "/var/www/html/vhosts/${domain}/public_html";
        sudo git clone "git@bitbucket.org:drz4007/${domain}.git" "/var/www/html/vhosts/${domain}/public_html";
        sudo chown -R www-data:www-data "/var/www/html/vhosts/${domain}/public_html";
    done
}

function LAMP-hard-reset()
{
	# Purge the previous installation.


    sudo service apache2 stop;
    sudo service mysql stop;

    sudo apt-get purge -y mysql-server mariadb-server apache2 php5;

    sudo apt --fix-broken;
    sudo apt-get -y purge apache2*;
	sudo apt-get -y purge mariadb*;
    sudo apt-get -y purge php*;
	sudo apt-get -y purge phpmyadmin;
    sudo rm -r /etc/apache2/;
	sudo rm -r /etc/phpmyadmin;
	sudo rm -r /etc/php/;
	sudo rm -r /var/lib/php/;
	sudo apt-get -y autoremove;

	# Install.
    echo "Installing...";
    sudo apt install -y mariadb-server mariadb-client;
    sudo apt-get install -y php7.0 php7.0-mysql php7.0-xdebug;
    sudo apt-get install -y apache2 apache2-mod-php7.0;
    sudo apt-get install -y phpmyadmin;
    sudo aptitude -y install php7.0-xdebug;
    sudo a2enmod rewrite;
    sudo service apache2 restart;
    sudo apt --fix-broken install;
    dpkg-reconfigure phpmyadmin;
    mysql -u root -e "use mysql;update user set password=PASSWORD('root') where User='root';GRANT ALL PRIVILEGES ON *.* TO root@localhost IDENTIFIED BY 'root';FLUSH PRIVILEGES;";
}

function web-images() {
    # Uses ImageMagick.
    # Resize to 1200px width and remove metadata (-strip flag).
    for image in *; do convert $image -resize 1200 -strip $image; done;
}

# ffmpef stuff
function ffmpeg-subtitles-add() 
{
    if [[ "$1" && "$2" ]]; then
        inputFile="${1}";
        subtitlesFile="${2}";
        ffmpeg -i ${inputFile} -i ${subtitlesFile} -c copy -c:s mov_text outfile-with-subs.mp4;
    else
        echo "Usage: ffmpeg-subtitles-add <inputFile> <subtitlesFile>";
    fi
}

function ffmpeg-audio-extract() 
{
    # See: http://stackoverflow.com/questions/9913032/ffmpeg-to-extract-audio-from-video
    if [[ "$1" && "$2" ]]; then
        inputFile="${1}";
        outputFile="${2}";
        ffmpeg -i ${inputFile} -vn -acodec copy ${outputFile};
    else
        echo "Usage: ffmpeg-audio-extract <inputFile> <outputFile>";
    fi
}

function ffmpeg-audio-replace() 
{
    # See: http://stackoverflow.com/questions/9913032/ffmpeg-to-extract-audio-from-video
    if [[ "$1" && "$2" && "$3" ]]; then
        videoFile="${1}";
        audioFile="${2}";
        outputFile="${3}";
        ffmpeg -i ${videoFile} -i ${audioFile} -c:v copy -map 0:v:0 -map 1:a:0 ${outputFile};
    else
        echo "Usage: ffmpeg-audio-replace <videoFile> <audioFile> <outputFile>";
    fi
}

function ffmpeg-video-resize() {
    # https://trac.ffmpeg.org/wiki/Scaling%20(resizing)%20with%20ffmpeg
    if [[ "$1" && "$2" && "$3" ]]; then
        inputFile="${1}";
        scaleSize="${2}";
        outputFile="${3}";
        ffmpeg -i ${inputFile} -vf scale=${scaleSize}:-1 ${outputFile};
    else
        echo "Usage: ffmpeg-video-resize <inputFile> <scaleSize> <outputFile>";
    fi
}

function ffmpeg-video-resize-for-youtube() {
    # https://trac.ffmpeg.org/wiki/Scaling%20(resizing)%20with%20ffmpeg
    if [[ "$1" && "$2" ]]; then
        inputFile="${1}";
        outputFile="${2}";
        ffmpeg -i ${inputFile} -vf scale=854:480 ${outputFile};
    else
        echo "Usage: ffmpeg-video-resize-for-youtube <inputFile> <outputFile>";
    fi
}

function ffmpeg-concat-files() 
{
    # See: http://stackoverflow.com/questions/7333232/concatenate-two-mp4-files-using-ffmpeg
    # The "-safe 0" disables the safe mode due to "unsafe files" error.
    if [[ "$1" && "$2" ]]; then
        filesList="${1}";
        outputFile="${2}";
        ffmpeg -f concat -safe 0 -i ${filesList} -codec copy ${outputFile};
    else
        echo "";
        echo "Usage: ffmpeg-concat-files <filesList.txt> <outputFile>";
        echo "";
        echo "The filesList.txt must have the following format:";
        echo "file 'file1'";
        echo "file 'file2'";
        echo "file 'file3'";
        echo "";
    fi
}

# youtube-dl wrapper
function youtube-dl-best-quality() {
	if [[ "${1}" ]]; then
		youtube-dl -f bestvideo+bestaudio "${1}";
	else
		echo "Usage: youtube-dl-best-quality <URL>";
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

function firefox-install-latest()
{
    wget -O FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US";
    
    if [ ! -d "/opt/firefox" ]; then
        sudo mkdir /opt/firefox;
    else    
        sudo rm -r /opt/firefox/*;
    fi
    
    tar xjf FirefoxSetup.tar.bz2 -C /opt/firefox/;

    if [ ! -f "/usr/lib/firefox-esr/firefox-esr_orig" ]; then
        mv /usr/lib/firefox-esr/firefox-esr /usr/lib/firefox-esr/firefox-esr_orig;
    else
        sudo rm /usr/lib/firefox-esr/firefox-esr;
    fi

    sudo ln -s /opt/firefox/firefox/firefox /usr/lib/firefox-esr/firefox-esr;
    rm -r ./FirefoxSetup.tar.bz2;
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
    if [[ "$1" ]]; then
	touch ./motogpFiles.txt;
    counter=1;
    while read line; do
        if [[ "$line" == "http"*  ]]; then
            curl -o ${counter}.mp4 "$line";
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

function get-release-info()
{
    reset;
    lsb_release -a 2>/dev/null | grep Description;
    mysql --version | awk '{print $5}' | sed 's/,//g';
}

function get-database-server-info()
{
    mysql --version | awk '{print $5}' | sed 's/,//g';
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
