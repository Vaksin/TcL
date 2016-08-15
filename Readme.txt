Installation:
=========
*Required "youtube-dl" and "ffmpeg" package installed.
You can read here: https://rg3.github.io/youtube-dl/
-------------------
1. Edit vaksin.sh file:
Change the "/home/vaksin/public_html/" with your patch.

2. Edit dl.tcl file. Change this:
set linkdl "http://your.link/~user"
set path "/home/vaksin"

3. Upload vaksin.sh to your eggdrop folder. (/home/user/eggdrop/here)
And set permission to 755 ---> Type: chmod 755 vaksin.sh

4. Upload mp3.tcl to your scripts folder. (/home/user/eggdrop/scripts/here)

5. Edit your config file and load your bot.
DONE
