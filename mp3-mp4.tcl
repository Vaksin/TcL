#######################################################
#																																	#
#									Mp3 and Mp4 Downloader												#
#												Version 1.3																#
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
# 1.0																														  #
# -Enable or Disable the script.			(For Owner)										   #
# -Clear all file in folder.						(For Owner)											#
# -Check mp3 or mp4 file in folder.	 (For Owner)							        		#
# 1.1																															#
# -Error message now with full reply.																	#
# -Fixed some bugs.																								#
# 1.2																															#
# -Added block and unblock commands for owner.											#
# -Fixed bug.																											#
# 1.3																														 #
# -Modified commands. Now you can use <botnick command>					#
#  Example: "mp3 on" or 'mp3 block nick"														  #
#  (Please see bot help. Type .help in channel.)												#
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

###############################################################################
#
#      DON'T CHANGE ANYTHING BELOW
#
###############################################################################
bind pub - .mp3 mptiga
bind pub - .mp4 mpempat
bind pub - clear delete_file
bind pub - .help help
bind pub - "$botnick" pub:onoff

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
	global path linkdl author
	if {![string match *[decrypt 64 "eXjyh.jVjlb.EoJZq.XxCnP0"]* [string tolower $author]] || ![string match *[decrypt 64 "lJw/D/4EEJV1"]* [string tolower $author]]} {
		puthelp "PRIVMSG $chan :ERROR!!!"
		return 0
	}
	putquick "PRIVMSG $chan :Mohon tunggu..."
   catch [list exec vaksin --get-title "ytsearch1:$text"] judul
   catch [list exec vaksin --get-duration "ytsearch1:$text"] durasi
   regsub -all " " $judul "_" judulbaru
   catch [list exec vaksin "ytsearch1:$text" --no-playlist --youtube-skip-dash-manifest -f mp4 --output "$path/public_html/$judulbaru.%(ext)s"] runcmdd
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
   puthelp "PRIVMSG $chan :Link Download: $linkdl$judulbaru.mp4 \[Size: \002$besar\002\] \[Durasi: \002$durasi menit\002\] \00304®\003 Presented by\002 $author \002"
   puthelp "PRIVMSG $chan :Anda punya waktu 5 menit untuk download"
   timer 5 [list apus $chan $judulbaru]
   exec rm -f $path/eggdrop/a.txt
}

proc pub_getlinkk {nick host hand chan text } {
	global path linkdl author
	if {![string match *[decrypt 64 "eXjyh.jVjlb.EoJZq.XxCnP0"]* [string tolower $author]] || ![string match *[decrypt 64 "lJw/D/4EEJV1"]* [string tolower $author]]} {
		puthelp "PRIVMSG $chan :ERROR!!!"
		return 0
	}
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
   puthelp "PRIVMSG $chan :Link Download: $linkdl$judulbaru.mp4 \[Size: \002$besar\002\] \[Durasi: \002$durasi menit\002\] \00304®\003 Presented by\002 $author \002"
   puthelp "PRIVMSG $chan :Anda punya waktu 5 menit untuk download"
   timer 5 [list apus $chan $judulbaru]
   exec rm -f $path/eggdrop/a.txt
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
	global path linkdl author
	if {![string match *[decrypt 64 "eXjyh.jVjlb.EoJZq.XxCnP0"]* [string tolower $author]] || ![string match *[decrypt 64 "lJw/D/4EEJV1"]* [string tolower $author]]} {
		puthelp "PRIVMSG $chan :ERROR!!!"
		return 0
	}
	putquick "PRIVMSG $chan :Mohon tunggu..."
	set judul [lrange $text 0 end]
   catch [list exec vaksin --get-duration "ytsearch1:$text"] durasi
   regsub -all " " $judul "_" judulbaru
   catch [list exec vaksin "ytsearch1:$text" --no-part --no-playlist --youtube-skip-dash-manifest -q -x --audio-format mp3 --audio-quality 0 --output "$path/public_html/$judulbaru.%(ext)s"] runcmd
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
   puthelp "PRIVMSG $chan :Link Download: $linkdl$judulbaru.mp3 \[Size: \002$besar\002\] \[Durasi: \002$durasi menit\002\] \00304®\003 Presented by\002 $author \002"
   puthelp "PRIVMSG $chan :Anda punya waktu 5 menit untuk download"
   timer 5 [list hapus $chan $judulbaru]
   exec rm -f $path/eggdrop/a.txt
}
proc pub_getylink {nick host hand chan text } {
	global path linkdl author
	if {![string match *[decrypt 64 "eXjyh.jVjlb.EoJZq.XxCnP0"]* [string tolower $author]] || ![string match *[decrypt 64 "lJw/D/4EEJV1"]* [string tolower $author]]} {
		puthelp "PRIVMSG $chan :ERROR!!!"
		return 0
	}
	putquick "PRIVMSG $chan :Mohon tunggu..."
   catch [list exec vaksin --get-title "$text"] judul
   catch [list exec vaksin --get-duration "$text"] durasi
   regsub -all " " $judul "_" judulbaru
   catch [list exec vaksin --no-playlist --youtube-skip-dash-manifest -x --audio-format mp3 --audio-quality 0 --output "$path/public_html/$judulbaru.%(ext)s" $text] runcmd
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
   puthelp "PRIVMSG $chan :Link Download: $linkdl$judulbaru.mp3 \[Size: \002$besar\002\] \[Durasi: \002$durasi menit\002\] \00304®\003 Presented by\002 $author \002"
   puthelp "PRIVMSG $chan :Anda punya waktu 5 menit untuk download"
   timer 5 [list hapus $chan $judulbaru]
   exec rm -f $path/eggdrop/a.txt
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
	puthelp "PRIVMSG $nick :Perintah untuk Owner:"
	puthelp "PRIVMSG $nick :\002clear\002 | Apus file di folder."
	puthelp "PRIVMSG $nick :\002<botnick> file\002 | Cek file di folder."
	puthelp "PRIVMSG $nick :\002<botnick> on\002 | Mengaktifkan bot."
	puthelp "PRIVMSG $nick :\002<botnick> off\002 | Menonaktifkan bot."
	puthelp "PRIVMSG $nick :\002<botnick> blok <nick>\002 | Blok user."
	puthelp "PRIVMSG $nick :\002<botnick> unblok <nick>\002 | Unblok user."
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
proc pub:onoff {nick uhost hand chan arg} {
	global path
	if {![matchattr $nick n]} {
		putquick "NOTICE $nick :Access Denied!!!"
		return 0
	}
	switch [lindex $arg 0] {
		"on" {
			if {[channel get $chan mp3]} {
				puthelp "NOTICE $nick :Already Opened"
				return 0
			}
			channel set $chan +mp3
			putquick "PRIVMSG $chan :- ENABLE -"
			putquick "PRIVMSG $chan :Silahkan download lagu dan video kesukaan anda. Ketik \002.help\002 (Mp3 and Mp4 Downloader Coded by Vaksin)"
		}
		"off" {
			if {![channel get $chan mp3]} {
				puthelp "NOTICE $nick :Already Closed"
				return 0
			}
			channel set $chan -mp3
			putquick "PRIVMSG $chan :- DISABLE -"
		}
		"blok" {
			set tnick [lindex $arg 1]
			if {[matchattr $tnick n]} {
				puthelp "NOTICE $nick :$tnick is my owner. -ABORTED-"
				return 0
			}
			set hostmask [getchanhost $tnick $chan]
			set hostmask "*!*@[lindex [split $hostmask @] 1]"
			if {[isignore $hostmask]} {
				puthlp "NOTICE $nick :$tnick is alreay ignored."
				return 0
			}
			newignore $hostmask $hand "*" 0
			puthelp "NOTICE $nick :Ignoring $tnick"
		}
		"unblok" {
			set tnick [lindex $arg 1]
			set hostmask [getchanhost $tnick $chan]
			set hostmask "*!*@[lindex [split $hostmask @] 1]"
			if {![isignore $hostmask]} {
				puthlp "NOTICE $nick :$tnick is not on ignore list."
				return 0
			}
			killignore $hostmask
			puthelp "NOTICE $nick :Unignoring $tnick"
			saveuser
		}
		"file" {
			set isi [glob -nocomplain [file join $path/public_html/ *]]
			if {[llength $isi] != 0} {
				puthelp "PRIVMSG $chan :Ada [llength $isi] files"
			} else {
				puthelp "PRIVMSG $chan :Folder kosong."
			}
		}
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
set author [decrypt 64 "5qIUj.M1Ufm.RV0zE.rG4xn/K2b4z.w4QJK0 "]