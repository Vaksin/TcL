################################################
#																																	#
#									Mp3 and Mp4 Downloader												#
#												Version 1.0																#
#																																	#
# Author: Vaksin																										#
# Copyright © 2016 All Rights Reserved.																#
################################################
#																																	#
# ############																									#
# REQUIREMENTS																									#
# ############																									#
#  "youtube-dl" and "ffmpeg" package installed.													#
#																																	#
# #######																												#
# FEATURE																												#
# #######																												#
# -Download music (mp3) and video (mp4)														#
# -Enable or Disable the script																				#
# -Check mp3 or mp4 file in folder																		#
# -Clear all file in folder.																							#
#																																	#
# #######																												#
# CONTACT																												#
# #######																												#
#  If you have any suggestions, comments, questions or report bugs,			#
#  you can find me on IRC @ForumCerdas Network											#
#																																	#
#  /server irc.forumcerdas.net:6667   Nick: Vaksin											#
#																																	#
######################################################
setudef flag mp3

###############################################################################
### Settings ###
###############################################################################

# This is antiflood trigger, set how long you want (time in second)
set tube(rest) 50

# This is link for download the mp3 or mp4 file.
set linkdl "http://your.link/~user/"

# This is your public_html folder patch
set path "/home/vaksin/public_html"

###############################################################################
### End of Settings ###
###############################################################################

bind pub - .mp3 mptiga
bind pub - .mp4 mpempat
bind pub - clear delete_file 
bind pub - .help help
bind pub - open pub:open
bind pub - close pub:close

proc mpempat { nick host hand chan text } {
	global tube
	if {![channel get $chan mp3]} { return 0 }
	if {[lindex $text 0] == ""} {
        puthelp "NOTICE $nick :Type \002.help\002 for see the commands."
        return 0
    }
    if {[info exists tube(protection)]} {
        set rest [expr [clock seconds] - $tube(protection)]
        if {$rest < $tube(rest)} {
            puthelp "NOTICE $nick :Please wait for [expr $tube(rest) - $rest] seconds."
            return 0
        }
        catch { unset rest }
    }
    set tube(protection) [clock seconds]
    if {[string match "*http*" [lindex $text 0]]} {
        pub_getlinkk $nick $host $hand $chan $text
    } else {
        pub_gett $nick $host $hand $chan $text
    }
}
proc pub_gett {nick host hand chan text } {
	global path linkdl
	putquick "PRIVMSG $chan :Please wait..."
   catch [list exec youtube-dl --get-title "ytsearch1:$text"] judul
   catch [list exec youtube-dl --get-duration "ytsearch1:$text"] durasi
   regsub -all " " $judul "_" judulbaru
   catch [list exec youtube-dl "ytsearch1:$text"  --no-playlist --youtube-skip-dash-manifest -f mp4 --output "$path/$judulbaru.%(ext)s"] runcmdd
   if {[string match *error* [string tolower $runcmdd]]} {
       putserv "PRIVMSG $chan :ERROR. Couldn't download this file."
       return 0
   }
   set files [glob "$path/$judulbaru.mp4"]
   set ukuran [file size "$files"]
   set besar [fixform $ukuran]
   puthelp "PRIVMSG $chan :Download Link: $linkdl$judulbaru.mp4 \[Size: \002$besar\002\] \[Duration: \002$durasi menit\002\]"
   puthelp "PRIVMSG $chan :You have 10 minutes for download"
   timer 10 [list apus $chan $judulbaru]
   return 0
}
proc pub_getlinkk {nick host hand chan text } {
	global path linkdl
	putquick "PRIVMSG $chan :Please wait..."
   catch [list exec youtube-dl --get-title "$text"] judul
   catch [list exec youtube-dl --get-duration "$text"] durasi
   regsub -all " " $judul "_" judulbaru
   catch [list exec youtube-dl --no-playlist --youtube-skip-dash-manifest -f mp4 --output "$path/$judulbaru.%(ext)s" $text] runcmdd
   if {[string match *error* [string tolower $runcmdd]]} {
       putserv "PRIVMSG $chan :ERROR. Couldn't download this file."
       return 0
   }
   set files [glob "$path/$judulbaru.mp4"]
   set ukuran [file size "$files"]
   set besar [fixform $ukuran]
   puthelp "PRIVMSG $chan :Download Link: $linkdl$judulbaru.mp4 \[Size: \002$besar\002\] \[Duration: \002$durasi menit\002\]"
   puthelp "PRIVMSG $chan :You have 10 minutes for download"
   timer 10 [list apus $chan $judulbaru]
   return 0
}

proc mptiga { nick host hand chan text } {
	global tube
	if {![channel get $chan mp3]} { return 0 }
	if {[lindex $text 0] == ""} {
        puthelp "NOTICE $nick :Type \002.help\002 to see the commands."
        return 0
    }
    if {[info exists tube(protection)]} {
        set rest [expr [clock seconds] - $tube(protection)]
        if {$rest < $tube(rest)} {
            puthelp "PRIVMSG $chan :Please wait for [expr $tube(rest) - $rest] seconds."
            return 0
        }
        catch { unset rest }
    }
    set tube(protection) [clock seconds]
    if {[string match "*http*" [lindex $text 0]]} {
        pub_getlink $nick $host $hand $chan $text
    } else {
        pub_get $nick $host $hand $chan $text
    }
}
proc pub_get {nick host hand chan text } {
	global path linkdl
	putquick "PRIVMSG $chan :Please wait..."
	set judul [lrange $text 0 end]
   catch [list exec youtube-dl --get-duration "ytsearch1:$text"] durasi
   regsub -all " " $judul "_" judulbaru
   catch [list exec youtube-dl "ytsearch1:$text" -x --audio-format mp3 --audio-quality 0 --output "$path/$judulbaru.%(ext)s"] runcmd
   if {[string match *error* [string tolower $runcmd]]} {
       putserv "PRIVMSG $chan :ERROR. Couldn't download this file."
       return 0
   }
   set files [glob "$path/$judulbaru.mp3"]
   set ukuran [file size "$files"]
   set besar [fixform $ukuran]
   puthelp "PRIVMSG $chan :Download Link: $linkdl$judulbaru.mp3 \[Size: \002$besar\002\] \[Duration: \002$durasi menit\002\]"
   puthelp "PRIVMSG $chan :You have 10 minutes for download"
   timer 10 [list hapus $chan $judulbaru]
   return 0
}
proc pub_getlink {nick host hand chan text } {
	global path linkdl
	putquick "PRIVMSG $chan :Please wait..."
   catch [list exec youtube-dl --get-title "$text"] judul
   catch [list exec youtube-dl --get-duration "$text"] durasi
   regsub -all " " $judul "_" judulbaru
   catch [list exec youtube-dl -x --audio-format mp3 --audio-quality 0 --output "$path/$judulbaru.%(ext)s" $text] runcmd
   if {[string match *error* [string tolower $runcmd]]} {
       putserv "PRIVMSG $chan :ERROR. Couldn't download this file."
       return 0
   }
   set files [glob "$path/$judulbaru.mp3"]
   set ukuran [file size "$files"]
   set besar [fixform $ukuran]
   puthelp "PRIVMSG $chan :Download Link: $linkdl$judulbaru.mp3 \[Size: \002$besar\002\] \[Duration: \002$durasi menit\002\]"
   puthelp "PRIVMSG $chan :You have 10 minutes for download"
   timer 10 [list hapus $chan $judulbaru]
   return 0
}

proc help {nick host hand chan args} {
	if {[channel get $chan mp3]} {
	puthelp "PRIVMSG $nick :Mp3 Commands:"
	puthelp "PRIVMSG $nick :\002.mp3 <title + singer>\002 | Exp: .mp3 stoney - lobo\002"
	puthelp "PRIVMSG $nick :\002.mp3 <link>\002 | Exp: .mp3 https://www.youtube.com/watch?v=2y-aB3VAaB8"
	puthelp "PRIVMSG $nick :Mp4 Commands"
	puthelp "PRIVMSG.$nick :\002.mp4 <title>\002 | Exp: .mp4 cinderella\002"
	puthelp "PRIVMSG $nick :\002.mp4 <link>\002 | Exp: .mp4 https://www.youtube.com/watch?v=2y-aB3VAaB8"
	puthelp "PRIVMSG $nick :-"
	puthelp "PRIVMSG $nick :Commands for OP and Owner:"
	puthelp "PRIVMSG $nick :\002open\002 | Enable the downloader."
	puthelp "PRIVMSG $nick :\002close\002 | Disable the downloader."
	puthelp "PRIVMSG $nick :\002clear\002 | Delete mp3 and mp4 file in server."
 }
}

proc delete_file {nick host hand chan text} {
	global botnick path
	if {[isop $nick $chan]==1 || [matchattr $nick n]} {
		catch [list exec ~/eggdrop/vaksin.sh] vakz
		if {[string match *empty* [string tolower $vakz]]} {
			puthelp "PRIVMSG $chan :Folder is empty."
		} else {
			puthelp "PRIVMSG $chan :All files has been deleted."
		}
	}
}

proc apus {chan judulbaru} {
	global path
	if {[file exists $path/$judulbaru.mp4] == 1} {
		exec rm -f $path/$judulbaru.mp4
		puthelp "PRIVMSG $chan :File $judulbaru.mp4 has been deleted."
	}
}
proc hapus {chan judulbaru} {
	global path
	if {[file exists $path/$judulbaru.mp3] == 1} {
		exec rm -f $path/$judulbaru.mp3
		puthelp "PRIVMSG $chan :File $judulbaru.mp3 has been deleted."
	}
}

proc pub:open {nick uhost hand chan arg} {
	if {[isop $nick $chan]==1 || [matchattr $nick n]} {
		if {[channel get $chan mp3]} {
			puthelp "NOTICE $nick :Already Opened"
			return 0
		}
		channel set $chan +mp3
		putquick "PRIVMSG $chan :- ENABLE -"
		putquick "PRIVMSG $chan :Download your favorite song. Please type \002.help\002"
	}
}
proc pub:close {nick uhost hand chan arg} {
	if {[isop $nick $chan]==1 || [matchattr $nick n]} {
		if {![channel get $chan mp3]} {
			puthelp "NOTICE $nick :Already Closed"
			return 0
		}
		channel set $chan -mp3
		putquick "PRIVMSG $chan :- DISABLE -"
	}
}

bind pub n "cek" cekfolder
proc cekfolder {nick uhost hand chan arg} {
	global path
	set isi [glob -nocomplain [file join $path *]]
	if {[llength $isi] != 0} {
		puthelp "PRIVMSG $chan :There is [llength $isi] files in folder"
	} else {
		puthelp "PRIVMSG $chan :Folder is empty."
	}
}

proc fixform n {
    if {wide($n) < 1000} {return $n}
    foreach unit {KB MB GB TB P E} {
        set n [expr {$n/1024.}]
        if {$n < 1000} {
            set n [string range $n 0 3]
            regexp {(.+)\.$} $n -> n
            set size "$n $unit"
            return $size
        }
    }
    return Inf
 }

putlog "Mp3 and Mp4 Downloader Loaded ® Presented by Vaksin."
