function update_twitch_cli --description 'Update twitch-cli'
    echo "Update twitch-cli"
    if read_confirm
        set VERSION (twitch version | sed -e 's/twitch-cli\///g')
        set NEW_VERSION (curl --silent https://api.github.com/repos/twitchdev/twitch-cli/releases/latest | jq .name -r | sed -e 's/^v//g')
        set DESTINATION "/usr/local/bin/twitch"
        if test $VERSION != $NEW_VERSION
            echo "Update found!"
            set latest_archive_file "twitch-cli_${NEW_VERSION}_$(uname -s)_$(uname -m)"
            set CURRENTDIR (pwd)
            cd /tmp/ || exit
            wget "https://github.com/twitchdev/twitch-cli/releases/download/v$NEW_VERSION/$latest_archive_file.tar.gz"
            tar xvf "$latest_archive_file.tar.gz" >>/dev/null
            cd "$CURRENTDIR" || exit
            sudo cp "/tmp/$latest_archive_file/twitch" ${DESTINATION}
            rm -rf "/tmp/"$latest_archive_file"*
            sudo chmod 755 ${DESTINATION}
        else
            echo "No update required."
        end
    end
end
