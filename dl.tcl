#######################################################
#																																	#
#									Mp3 and Mp4 Downloader												#
#												Version 1.2																#
#																																	#
# Author: Vaksin																										#
# Copyright © 2016 All Rights Reserved.																#
#######################################################
#																																	#
# ############																									#
# REQUIREMENTS																									#
# ############																									#
#  "youtube-dl" and "ffmpeg" package installed.												#
#																																#
# ##########																										#
# CHANGELOG																										#
###########																										#
# 1.0																															#
# -Enable or Disable the script.			(For Owner)										#
# -Clear all file in folder.						(For Owner)											#
# -Check mp3 or mp4 file in folder.	(For Op or Owner)									#
# 1.1																															#
# -Error message now with full reply.																	#
# -Fixed some bugs.																								#
# 1.2																															#
# -Added block and unblock commands for owner.											#
#  Examples: block donald		(Prevent donald for download)						#
#					 unblock donald	(Remove block)												#
# -Fixed bug.																											#
#																																#
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
set path "/home/vaksin"

###############################################################################
### End of Settings ###
###############################################################################

bind pub - .mp3 mptiga
bind pub - .mp4 mpempat
bind pub - clear delete_file
bind pub - check cekfolder
bind pub - .help help
bind pub - open pub:open
bind pub - close pub:close
bind pub - block blokk
bind pub - unblock unblokk

proc blokk { nick host hand chan text } {
	if {[matchattr $nick n]} {
		set tnick [lindex $text 0]
		set hostmask [getchanhost $tnick $chan]
		set hostmask "*!*@[lindex [split $hostmask @] 1]"
		if {[isignore $hostmask]} {
			puthlp "NOTICE $nick :$tnick is alreay set on ignore."
			return 0
		}
	newignore $hostmask $hand "*" 0
	puthelp "NOTICE $nick :Ignoring $tnick"
	} else {
		putquick "NOTICE $nick :Access Denied!!!"
	}
}

proc unblokk { nick host hand chan text } {
	if {[matchattr $nick n]} {
	set tnick [lindex $text 0]
	set hostmask [getchanhost $tnick $chan]
	set hostmask "*!*@[lindex [split $hostmask @] 1]"
	if {![isignore $hostmask]} {
		puthlp "NOTICE $nick :$tnick is not on ignore list."
		return 0
	}
	killignore $hostmask
	puthelp "NOTICE $nick :Unignoring $tnick"
	saveuser
	} else {
		putquick "NOTICE $nick :Access Denied!!!"
	}
}

proc mpempat { nick host hand chan text } {
	global tube
	if {![channel get $chan mp3]} { return 0 }
	if {[lindex $text 0] == ""} {
        puthelp "NOTICE $nick :Ketik \002.help\002 untuk melihat perintah."
        return 0
    }
    if {[info exists tube(protection)]} {
        set rest [expr [clock seconds] - $tube(protection)]
        if {$rest < $tube(rest)} {
            puthelp "PRIVMSG $chan :Tunggu [expr $tube(rest) - $rest] detik lagi."
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
	putquick "PRIVMSG $chan :Mohon tunggu..."
   catch [list exec vaksin --get-title "ytsearch1:$text"] judul
   catch [list exec vaksin --get-duration "ytsearch1:$text"] durasi
   regsub -all " " $judul "_" judulbaru
   catch [list exec vaksin "ytsearch1:$text"  --no-playlist --youtube-skip-dash-manifest -f mp4 --output "$path/public_html/$judulbaru.%(ext)s"] runcmdd
   set f [open "a.txt" a+]
   puts $f $runcmdd
   close $f
   set fp [open "a.txt" r]
   while { [gets $fp line] >= 0 } {
       if {[string match *ERROR:* $line]} {
           puthelp "PRIVMSG $chan :$line"
           exec rm -f $path/eggdrop/a.txt
           return 0
       }
    }
    close $fp
    set ukuran [file size "$path/public_html/$judulbaru.mp4"]
    set besar [fixform $ukuran]
   puthelp "PRIVMSG $chan :Link Download: $linkdl$judulbaru.mp4 \[Size: \002$besar\002\] \[Durasi: \002$durasi menit\002\] \00304®\003 Presented by \002Vaksin\002 \026( NEW UPDATE latest version 1.2: https://github.com/Vaksin/TcL )\026"
   puthelp "PRIVMSG $chan :Anda punya waktu 5 menit untuk download"
   timer 5 [list apus $chan $judulbaru]
   return 0
}

proc pub_getlinkk {nick host hand chan text } {
	global path linkdl
	putquick "PRIVMSG $chan :Mohon tunggu..."
   catch [list exec vaksin --get-title "$text"] judul
   catch [list exec vaksin --get-duration "$text"] durasi
   regsub -all " " $judul "_" judulbaru
   catch [list exec vaksin --no-playlist --youtube-skip-dash-manifest -f mp4 --output "$path/public_html/$judulbaru.%(ext)s" $text] runcmdd
   set f [open "a.txt" a+]
   puts $f $runcmdd
   close $f
   set fp [open "a.txt" r]
   while { [gets $fp line] >= 0 } {
       if {[string match *ERROR:* $line]} {
           puthelp "PRIVMSG $chan :$line"
           exec rm -f $path/eggdrop/a.txt
           return 0
       }
    }
    close $fp
    set ukuran [file size "$path/public_html/$judulbaru.mp4"]
    set besar [fixform $ukuran]
   puthelp "PRIVMSG $chan :Link Download: $linkdl$judulbaru.mp4 \[Size: \002$besar\002\] \[Durasi: \002$durasi menit\002\] \00304®\003 Presented by \002Vaksin\002 \026( NEW UPDATE latest version 1.2: https://github.com/Vaksin/TcL )\026"
   puthelp "PRIVMSG $chan :Anda punya waktu 5 menit untuk download"
   timer 5 [list apus $chan $judulbaru]
   return 0
}

proc mptiga { nick host hand chan text } {
	global tube
	if {![channel get $chan mp3]} { return 0 }
	if {[lindex $text 0] == ""} {
        puthelp "NOTICE $nick :Ketik \002.help\002 untuk melihat perintah."
        return 0
    }
    if {[info exists tube(protection)]} {
        set rest [expr [clock seconds] - $tube(protection)]
        if {$rest < $tube(rest)} {
            puthelp "PRIVMSG $chan :Tunggu [expr $tube(rest) - $rest] detik lagi."
            return 0
        }
        catch { unset rest }
    }
    set tube(protection) [clock seconds]
    if {[string match "*http*" [lindex $text 0]]} {
        pub_getylink $nick $host $hand $chan $text
    } else {
        pub_get $nick $host $hand $chan $text
    }
}
proc pub_get {nick host hand chan text } {
	global path linkdl
	putquick "PRIVMSG $chan :Mohon tunggu..."
	set judul [lrange $text 0 end]
   catch [list exec vaksin --get-duration "ytsearch1:$text"] durasi
   regsub -all " " $judul "_" judulbaru
   catch [list exec vaksin "ytsearch1:$text" -x --audio-format mp3 --audio-quality 0 --output "$path/public_html/$judulbaru.%(ext)s"] runcmd
   set f [open "a.txt" a+]
   puts $f $runcmd
   close $f
   set fp [open "a.txt" r]
   while { [gets $fp line] >= 0 } {
       if {[string match *ERROR:* $line]} {
           puthelp "PRIVMSG $chan :$line"
           exec rm -f $path/eggdrop/a.txt
           return 0
       }
    }
    close $fp
    set ukuran [file size "$path/public_html/$judulbaru.mp3"]
    set besar [fixform $ukuran]
   puthelp "PRIVMSG $chan :Link Download: $linkdl$judulbaru.mp3 \[Size: \002$besar\002\] \[Durasi: \002$durasi menit\002\] \00304®\003 Presented by \002Vaksin\002 \026( NEW UPDATE latest version 1.2: https://github.com/Vaksin/TcL )\026"
   puthelp "PRIVMSG $chan :Anda punya waktu 5 menit untuk download"
   timer 5 [list hapus $chan $judulbaru]
   return 0
}
proc pub_getylink {nick host hand chan text } {
	global path linkdl
	putquick "PRIVMSG $chan :Mohon tunggu..."
   catch [list exec vaksin --get-title "$text"] judul
   catch [list exec vaksin --get-duration "$text"] durasi
   regsub -all " " $judul "_" judulbaru
   catch [list exec vaksin -x --audio-format mp3 --audio-quality 0 --output "$path/public_html/$judulbaru.%(ext)s" $text] runcmd
   set f [open "a.txt" a+]
   puts $f $runcmd
   close $f
   set fp [open "a.txt" r]
   while { [gets $fp line] >= 0 } {
       if {[string match *ERROR:* $line]} {
           puthelp "PRIVMSG $chan :$line"
           exec rm -f $path/eggdrop/a.txt
           return 0
       }
    }
    close $fp
    set ukuran [file size "$path/public_html/$judulbaru.mp3"]
    set besar [fixform $ukuran]
   puthelp "PRIVMSG $chan :Link Download: $linkdl$judulbaru.mp3 \[Size: \002$besar\002\] \[Durasi: \002$durasi menit\002\] \00304®\003 Presented by \002Vaksin\002 \026( NEW UPDATE latest version 1.2: https://github.com/Vaksin/TcL )\026"
   puthelp "PRIVMSG $chan :Anda punya waktu 5 menit untuk download"
   timer 5 [list hapus $chan $judulbaru]
   return 0
}
proc help {nick host hand chan args} {
	if {[channel get $chan mp3]} {
	puthelp "PRIVMSG $nick :Perintah Mp3:"
	puthelp "PRIVMSG $nick :\002.mp3 <judul + penyanyi>\002 | Contoh: .mp3 mungkinkah stinky"
	puthelp "PRIVMSG $nick :\002.mp3 <link>\002 | Contoh: .mp3 https://www.youtube.com/watch?v=2y-aB3VAaB8"
	puthelp "PRIVMSG $nick :Perintah Mp4:"
	puthelp "PRIVMSG $nick :\002.mp4 <judul>\002 | Contoh: .mp4 cinderella"
	puthelp "PRIVMSG $nick :\002.mp4 <link>\002 | Contoh: .mp3 https://www.youtube.com/watch?v=2y-aB3VAaB8"
	puthelp "PRIVMSG $nick :-"
	puthelp "PRIVMSG $nick :Perintah untuk OP:"
	puthelp "PRIVMSG $nick :\002cek\002 | Cek file di folder."
	puthelp "PRIVMSG $nick :-"
	puthelp "PRIVMSG $nick :Perintah untuk Owner:"
	puthelp "PRIVMSG $nick :\002open\002 | Enable the downloader."
	puthelp "PRIVMSG $nick :\002close\002 | Disable the downloader."
	puthelp "PRIVMSG $nick :\002clear\002 | Delete file in server."
 }
}
proc delete_file {nick host hand chan text} {
	if {[matchattr $nick n]} {
		if {[llength $text] < 1} {
			catch [list exec ~/eggdrop/a.sh] vakz
			if {[string match *kosong* [string tolower $vakz]]} {
				puthelp "PRIVMSG $chan :Folder kosong."
			} else {
				puthelp "PRIVMSG $chan :Semua file telah di hapus."
			}
		}
	} else {
		puthelp "NOTICE $nick :Access Denied"
	}
}
proc apus {chan judulbaru} {
	global path
	if {[file exists $path/public_html/$judulbaru.mp4] == 1} {
		exec rm -f $path/public_html/$judulbaru.mp4
		puthelp "PRIVMSG $chan :File\002 $judulbaru.mp4 \002telah di hapus."
	}
}
proc hapus {chan judulbaru} {
	global path
	if {[file exists $path/public_html/$judulbaru.mp3] == 1} {
		exec rm -f $path/public_html/$judulbaru.mp3
		puthelp "PRIVMSG $chan :File\002 $judulbaru.mp3 \002telah di hapus."
	}
}
proc pub:open {nick uhost hand chan arg} {
	if {[matchattr $nick n]} {
		if {[llength $arg] < 1} {
			if {[channel get $chan mp3]} {
				puthelp "NOTICE $nick :Already Opened"
				return 0
			}
			channel set $chan +mp3
			putquick "PRIVMSG $chan :- ENABLE -"
			putquick "PRIVMSG $chan :Silahkan download lagu dan video kesukaan anda. Ketik \002.help\002 (Mp3 and Mp4 Downloader Coded by Vaksin)"
		}
	} else {
		putquick "NOTICE $nick :Access Denied!!!"
	}
}
proc pub:close {nick uhost hand chan arg} {
	if {[matchattr $nick n]} {
		if {[llength $arg] < 1} {
			if {![channel get $chan mp3]} {
				puthelp "NOTICE $nick :Already Closed"
				return 0
			}
			channel set $chan -mp3
			putquick "PRIVMSG $chan :- DISABLE -"
		}
	} else {
		putquick "NOTICE $nick :Access Denied!!!"
	}
}

proc cekfolder {nick uhost hand chan arg} {
	global path
	if {[isop $nick $chan]==1 || [matchattr $nick n]} {
		if {[llength $arg] < 1} {
			set isi [glob -nocomplain [file join $path/public_html/ *]]
			if {[llength $isi] != 0} {
				puthelp "PRIVMSG $chan :Ada [llength $isi] files"
			} else {
				puthelp "PRIVMSG $chan :Folder kosong."
			}
		}
	} else {
		putquick "NOTICE $nick :Access Denied!!!"
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
