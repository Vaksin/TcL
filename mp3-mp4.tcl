#######################################################
#																																	#
#									Mp3 and Mp4 Downloader												#
#												Version 1.4																#
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
# -Added block and unblock commands for owner.		                              	#
# -Fixed bug.																											#
# 1.3																														 #
# -Modified commands. Now you can use <botnick command>					#
#  Example: "mp3 on" or 'mp3 off"													            	  #
# 1.4																														 #
# -Move Block and unblock commands to private msg. Now nobady          #
#  knows who you are blocking.       																	#
#																															  #
#  (Please see bot help. Type .help in channel.)												#
#																																#
# #######																											#
# CONTACT																											#
# #######																											#
#  If you have any suggestions, comments, questions or report bugs,		#
#  you can find me on IRC @ForumCerdas Network										#
#																																#
#  /server irc.forumcerdas.net:6667   Nick: Vaksin										  #
#																																#
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
#      DON'T CHANGE ANYTHING BELOW EVEN YOU KNOW TCL.
#
###############################################################################

bind pub - .mp3 mptiga
bind pub - .mp4 mpempat
bind pubm - "* on" pub_on
bind pubm - "* off" pub_off
bind pubm - "* file" pub_file
bind pubm - "* clear" delete_file
bind msg - block msg_blok
bind msg - unblock msg_unblok
bind pubm - "* blocklist" daftar_ignore
bind pubm - "* help" daftar_help

proc mpempat { nick host hand chan text } {
	global tube
	if {![channel get $chan mp3]} { return 0 }
	if {[lindex $text 0] == ""} {
        puthelp "NOTICE $nick :Type \002.help\002 for commands list."
        return 0
    }
    if {[info exists tube(protection)]} {
        set rest [expr [clock seconds] - $tube(protection)]
        if {$rest < $tube(rest)} {
            puthelp "PRIVMSG $chan :Wait [expr $tube(rest) - $rest] second(s)."
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
		puthelp "PRIVMSG $chan :ERROR!!! The Author has been changed"
		return 0
	}
	putquick "PRIVMSG $chan :Please wait..."
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
   puthelp "PRIVMSG $chan :Download Link: $linkdl$judulbaru.mp4 \[Size: \002$besar\002\] \[Durasi: \002$durasi menit\002\] \00304®\003 Presented by\002 $author \002"
   puthelp "PRIVMSG $chan :You have 5 minutes for download"
   timer 5 [list apus $chan $judulbaru]
   exec rm -f $path/eggdrop/a.txt
}

proc pub_getlinkk {nick host hand chan text } {
	global path linkdl author
	if {![string match *[decrypt 64 "eXjyh.jVjlb.EoJZq.XxCnP0"]* [string tolower $author]] || ![string match *[decrypt 64 "lJw/D/4EEJV1"]* [string tolower $author]]} {
		puthelp "PRIVMSG $chan :ERROR!!! The Author has been changed"
		return 0
	}
	putquick "PRIVMSG $chan :Please wait..."
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
   puthelp "PRIVMSG $chan :Download Link: $linkdl$judulbaru.mp4 \[Size: \002$besar\002\] \[Durasi: \002$durasi menit\002\] \00304®\003 Presented by\002 $author \002"
   puthelp "PRIVMSG $chan :You have 5 minutes for download"
   timer 5 [list apus $chan $judulbaru]
   exec rm -f $path/eggdrop/a.txt
}

proc mptiga { nick host hand chan text } {
	global tube
	if {![channel get $chan mp3]} { return 0 }
	if {[lindex $text 0] == ""} {
        puthelp "NOTICE $nick :Type \002.help\002 for commands list."
        return 0
    }
    if {[info exists tube(protection)]} {
        set rest [expr [clock seconds] - $tube(protection)]
        if {$rest < $tube(rest)} {
            puthelp "PRIVMSG $chan :Wait [expr $tube(rest) - $rest] second(s)."
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
		puthelp "PRIVMSG $chan :ERROR!!! The Author has been changed"
		return 0
	}
	putquick "PRIVMSG $chan :Please wait..."
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
   puthelp "PRIVMSG $chan :Download Link: $linkdl$judulbaru.mp3 \[Size: \002$besar\002\] \[Durasi: \002$durasi menit\002\] \00304®\003 Presented by\002 $author \002"
   puthelp "PRIVMSG $chan :You have 5 minutes for download"
   timer 5 [list hapus $chan $judulbaru]
   exec rm -f $path/eggdrop/a.txt
}
proc pub_getylink {nick host hand chan text } {
	global path linkdl author
	if {![string match *[decrypt 64 "eXjyh.jVjlb.EoJZq.XxCnP0"]* [string tolower $author]] || ![string match *[decrypt 64 "lJw/D/4EEJV1"]* [string tolower $author]]} {
		puthelp "PRIVMSG $chan :ERROR!!! The Author has been changed"
		return 0
	}
	putquick "PRIVMSG $chan :Please wait..."
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
   puthelp "PRIVMSG $chan :Download Link: $linkdl$judulbaru.mp3 \[Size: \002$besar\002\] \[Durasi: \002$durasi menit\002\] \00304®\003 Presented by\002 $author \002"
   puthelp "PRIVMSG $chan :You have 5 minutes for download"
   timer 5 [list hapus $chan $judulbaru]
   exec rm -f $path/eggdrop/a.txt
}
proc daftar_help {nick host hand chan text} {
	global botnick
	if {[lindex $text 0] != $botnick} { return 0 }
	if {[channel get $chan mp3]} {
	puthelp "PRIVMSG $nick :Mp3 Commands:"
	puthelp "PRIVMSG $nick :\002.mp3 <title + singer>\002 | Example: .mp3 stoney - lobo"
	puthelp "PRIVMSG $nick :\002.mp3 <link>\002 | Example: .mp3 https://www.youtube.com/watch?v=2y-aB3VAaB8"
	puthelp "PRIVMSG $nick :Mp4 Commands:"
	puthelp "PRIVMSG $nick :\002.mp4 <title>\002 | Example: .mp4 cinderella"
	puthelp "PRIVMSG $nick :\002.mp4 <link>\002 | Example: .mp3 https://www.youtube.com/watch?v=2y-aB3VAaB8"
	puthelp "PRIVMSG $nick :-"
	puthelp "PRIVMSG $nick :Owner Commands:"
	puthelp "PRIVMSG $nick :\002<botnick> on\002 | Activate the bot."
	puthelp "PRIVMSG $nick :\002<botnick> off\002 | Deactivate the bot."
	puthelp "PRIVMSG $nick :\002<botnick> clear\002 | Delete file in folder."
	puthelp "PRIVMSG $nick :\002<botnick> file\002 | Check file in folder."
	puthelp "PRIVMSG $nick :\002<botnick> blocklist\002 | Ignore list."
	puthelp "PRIVMSG $nick :Private Message Commands:"
	puthelp "PRIVMSG $nick :\002block <nick/hostname>\002 | Block user."
	puthelp "PRIVMSG $nick :\002unblock <hostname>\002 | Unblock user."
 }
}
proc delete_file {nick host hand chan text} {
	global botnick
	if {[lindex $text 0] != $botnick} { return 0 }
	if {[matchattr $nick n]} {
		catch [list exec ~/eggdrop/a.sh] vakz
		if {[string match *kosong* [string tolower $vakz]]} {
			puthelp "PRIVMSG $chan :Folder is empty."
		} else {
			puthelp "PRIVMSG $chan :All files has been deleted."
		}
	} else {
		puthelp "NOTICE $nick :Access Denied"
	}
}
proc msg_blok {nick host hand rest} {
	global botnick
	if {![matchattr $nick n]} { puthlp "NOTICE $nick :Access Denied!!!" ; return 0 }
	if {![string match *!* [string tolower $rest]] && ![string match *@* [string tolower $rest]]} {
		msg:userhost $nick $host $hand $rest
		return 0
	}
	set rest [lindex $rest 0]
	if {[isignore $rest]} { puthlp "NOTICE $nick :$rest has been ignored." ; return 0 }
	if {$rest == "*!*@*"} { puthlp "NOTICE $nick :Ilegal Hostmask." ; return 0 }
	set usenick [finduser $rest]
	if {$usenick != "*" && [matchattr $usenick f]} { puthlp "NOTICE $nick :FAILED!!!. $rest is in friend list" ; return 0 }
	if {$rest != $nick} { newignore $rest $nick "*" 0 ; puthlp "NOTICE $nick :Ignoring $rest" }
}
proc msg:userhost {nick host hand rest} {
	global botnick
	bind RAW - 311 user:host
	bind RAW - 402 user:nosuch
	set target [lindex $rest 0]
	set ::nickreq $nick
	set ::whoistarget $target
	putquick "whois $target $target"
}
proc user:host {from key args} {
	set nick [lindex [split $args] 1]
	set ident [lindex [split $args] 2]
	set host [lindex [split $args] 3]
	set hostname "$nick!$ident@$host"
	set nick $::nickreq
	if {[isignore $hostname]} { puthlp "NOTICE $nick :$hostname has been ignored." ; return 0 }
	newignore $hostname $nick "*" 0
	puthlp "NOTICE $nick :Ignoring $hostname"
	unbind RAW - 311 user:host
}

proc user:nosuch { from key args } {
	set target $::whoistarget
	set nick $::nickreq
	putquick "NOTICE $nick :$target not online. Use: \002block <hostname>\002"
	unbind RAW - 402 user:nosuch
} 
proc msg_unblok {nick host hand rest} {
	global botnick
	if {![matchattr $nick n]} { puthlp "NOTICE $nick :Access Denied!!!" ; return 0 }
	set hostmask [lindex $rest 0]
	set nick $::nickreq
	if {![isignore $hostmask]} { puthlp "NOTICE $nick :$hostmask already ignored." ; return 0 }
	if {[isignore $hostmask]} { killignore $hostmask ; puthlp "NOTICE $nick :Unignoring \002\[\002${hostmask}\002\]\002" ; saveuser }
}
proc daftar_ignore {nick host hand chan text} {
	global botnick
	if {![matchattr $nick n]} { puthlp "NOTICE $nick :Access Denied!!!" ; return 0 }
	if {[lindex $text 0] != $botnick} { return 0 }
	if {![matchattr $nick n]} {
		putquick "NOTICE $nick :Access Denied!!!"
		return 0
	}
	if {[ignorelist]==""} {
		puthelp "NOTICE $nick :Ignore list is empty."
		return 0
	}
	foreach x [ignorelist] {
		puthelp "NOTICE $nick :Ignore List"
		puthelp "NOTICE $nick :$x"
	}
	puthelp "NOTICE $nick :Finish"
}
proc apus {chan judulbaru} {
	global path
	if {[file exists $path/public_html/$judulbaru.mp4] == 1} {
		exec rm -f $path/public_html/$judulbaru.mp4
		puthelp "PRIVMSG $chan :File\002 $judulbaru.mp4 \002deleted."
	}
}
proc hapus {chan judulbaru} {
	global path
	if {[file exists $path/public_html/$judulbaru.mp3] == 1} {
		exec rm -f $path/public_html/$judulbaru.mp3
		puthelp "PRIVMSG $chan :File\002 $judulbaru.mp3 \002has been deleted."
	}
}
proc pub_on {nick uhost hand chan arg} {
	global botnick
	if {[lindex $arg 0] != $botnick} { return 0 }
	if {![matchattr $nick n]} {
		putquick "NOTICE $nick :Access Denied!!!"
		return 0
	}
	if {[lindex $arg 0] != $botnick} { return 0 }
	if {[channel get $chan mp3]} {
		puthelp "NOTICE $nick :Already Opened"
		return 0
	}
	channel set $chan +mp3
	putquick "PRIVMSG $chan :- ENABLE -"
	putquick "PRIVMSG $chan :Feel free to download your favorite song and video. Type \002.help\002 for commands. (Mp3 and Mp4 Downloader Coded by Vaksin)"
}
proc pub_off {nick uhost hand chan arg} {
	global botnick
	if {[lindex $arg 0] != $botnick} { return 0 }
	if {![matchattr $nick n]} {
		putquick "NOTICE $nick :Access Denied!!!"
		return 0
	}
	if {[lindex $arg 0] != $botnick} { return 0 }
	if {![channel get $chan mp3]} {
		puthelp "NOTICE $nick :Already Closed"
		return 0
	}
	channel set $chan -mp3
	putquick "PRIVMSG $chan :- DISABLE -"
}
proc pub_file {nick uhost hand chan arg} {
	global botnick path
	if {[lindex $arg 0] != $botnick} { return 0 }
	if {![matchattr $nick n]} {
		putquick "NOTICE $nick :Access Denied!!!"
		return 0
	}
	set isi [glob -nocomplain [file join $path/public_html/ *]]
	if {[llength $isi] != 0} {
		puthelp "PRIVMSG $chan :There is [llength $isi] file(s)"
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
set author [decrypt 64 "5qIUj.M1Ufm.RV0zE.rG4xn/K2b4z.w4QJK0"]