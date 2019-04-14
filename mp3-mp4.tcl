#######################################################
#
#									Mp3 and Mp4 Downloader
#												Version 1.6
#
# Author: Vaksin
# Copyright ® 2016 All Rights Reserved.
#######################################################

# ############
# REQUIREMENTS
# ############
#  "youtube-dl" and "ffmpeg" package installed.

# ##########
# CHANGELOG
# ##########
# 1.0
# -First release.
# 1.1
# -Error message now with full reply.
# -Fixed some bugs.
# 1.2
# -Modified commands. Now you can use <botnick command> (Example: "mp3 help").
# -Fixed bug.
# 1.3
# -Fixed unicode characters bug. (Can't download from PC browser).
# 1.4
# -Added youtube-dl update commands.
# -Added code for block streaming.
# -Fixed bugs.
# 1.5
# -Fixed more unicode characters that can't be download from PC.
# 1.6
# -Recoded some code.
# -Added clear file(s) and cache(s) command.
# -Added supported sites list command.
# -Fixed more unicode characters that can't be download from PC.
# -Fixed bugs.
#
#  (Type "<botnick> help" in channel for command list).

# #######
# CONTACT
# #######
#  If you have any questions, suggestions, or report bugs,
#  you can find me on IRC @DALnet Network.
#
#  /server irc.dal.net:6667   Nick: vaksin
#
######################################################

######################################################
### Settings ###
######################################################

# This is link untuk mengunduh. the mp3 or mp4 file.
set linkdl "http://your.site/~user/"

# This is your public_html folder patch
set path "/home/user"

# Mp3 and Mp4 Size Limit for download. (Set it blank for free size)
# Example: set mptigasize ""
set mptigasize "20m"
set mpempatsize "50m"

# Allow Playlist download or not.
# 0 = Allowed, 1 = Not allowed.
set allowplaylist 1

# Active channel for your bot
set basech "#mp3"

###############################################################################
### End of Settings ###
###############################################################################

###############################################################################
#
#      DON'T CHANGE ANYTHING BELOW UNLESS YOU KNOW TCL.
#
###############################################################################

bind pub - .mp3 mptiga
bind pub - .mp4 mpempat
bind pubm n "* on" pub_on
bind pubm n "* off" pub_off
bind pubm n "* clear file" delete_file
bind pubm n "* clear cache" delete_cache
bind pubm n "* update" pub_update
bind pubm - "* help" daftar_help
bind pubm - "* sites list" daftar_link

## Mp3 ##
proc mptiga { nick host hand chan text } {
	global allowplaylist basech
	if {$chan != $basech} { return 0 }
	if {[lindex $text 0] == ""} { puthelp "PRIVMSG $chan :Type \002mp3 help\002 for command list." ; return 0 }
	if {[string match "*stream*" [string tolower $text]]} { puthelp "PRIVMSG $chan :Streaming is not allowed." ; return 0 }
	if {$allowplaylist == 1} {
		if {[string match "*playlist?list*" [string tolower $text]]} { puthelp "PRIVMSG $chan :Playlist is not allowed." ; return 0 }
	}
	if {![string match "*http*" [lindex $text 0]]} {
		mptigatext $nick $host $hand $chan $text
	} else {
		mptigalink $nick $host $hand $chan $text
	}
}

proc mptigatext { nick host hand chan text } {
	global path linkdl judulbaru mptigasize
	catch {exec youtube-dl -e --get-duration --get-id "ytsearch1:$text"} mptigareplaytext
	foreach {judul id durasi} [split $mptigareplaytext \n] {
		if {[string match "ERROR:*" $judul] || [string match "WARNING:*" $judul]} { puthelp "PRIVMSG $chan :Unable to complete request. Reason: $judul" ; return 0 }
		if {[string match "ERROR:*" $id] || [string match "WARNING:*" $id] || ($id == "")} { puthelp "PRIVMSG $chan :Unable to complete request. Reason: $id" ; return 0 }
		if {[string match "ERROR:*" $durasi]} { puthelp "PRIVMSG $chan :Unable to complete request. Reason: $durasi" ; return 0 }
		if {$durasi == "0"} { putquick "PRIVMSG $chan :Streaming is not allowed." ; return 0 }
		if {[string match "WARNING:*" $durasi]} {
			set durasi ""
		} elseif {![string match "*:*" $durasi] && ![string match "*WARNING*" $durasi]} {
			set durasi "$durasi second"
		} else {
			set durasi "$durasi minutes"
		}
		set ytlink "https://youtu.be/$id"
		set judulbaru [string map {" " "_" "ÂŽ" "" "ðŸŽ¶" "" "ðŸŽ§" "" "ðŸŽµ" "" "Ÿ" "" "¶" "" "?" "" "ð" "" "µ" "" {¤} {} {?} "" {`} "" {"} "" {?} "" {%} "persen" {[} "(" {]} ")" {|_} "" {/} "_" {|} "-" {/_} "-" {"_} "" {#} "" "é" "e"} $judul]
		putquick "PRIVMSG $chan :Trying to convert \002$judul\002 please wait..."
		if {$mptigasize != ""} {
				catch {exec youtube-dl --max-filesize $mptigasize --prefer-ffmpeg --no-playlist --no-mtime --ignore-config --geo-bypass --abort-on-error --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -x --audio-format mp3 --audio-quality 0 -o "$path/public_html/$judulbaru.%(ext)s" "$ytlink"} mptigaruncmd
			} else {
				catch {exec youtube-dl --prefer-ffmpeg --no-playlist --no-mtime --ignore-config --geo-bypass --abort-on-error --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -x --audio-format mp3 --audio-quality 0 -o "$path/public_html/$judulbaru.%(ext)s" "$ytlink"} mptigaruncmd
			}
		}
		foreach line [split $mptigaruncmd "\n"] { 
			if {[string match "ERROR:*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: $line" ; return 0 }
			if {[string match "*File is larger than max-filesize*" $line]} { puthelp "PRIVMSG $chan :File is too large. You can only download under \002$mptigasize\002" ; return 0 }
		}
		if {[file exists $path/public_html/$judulbaru.mp3] == 1} {
			set besar [fixform [file size "$path/public_html/$judulbaru.mp3"]]
			putquick "PRIVMSG $chan :Download Link: $linkdl$judulbaru.mp3 \[Size: \002$besar\002\] \[Duration: \002$durasi\002\] | (Will be deleted in\002 30 minutes\002)"
			timer 30 [list apusmp3 $chan $judulbaru]
		} else {
			puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: An unexpected error."
		}
	}
}

proc mptigalink { nick host hand chan text } {
	global path linkdl judulbaru mptigasize
	catch {exec youtube-dl -e --get-duration "$text"} mptigareplaylink
	foreach {judul durasi} [split $mptigareplaylink \n] {
		if {[string match "ERROR:*" $judul] || [string match "WARNING:*" $judul]} { puthelp "PRIVMSG $chan :Unable to complete request. Reason: $judul" ; return 0 }
		if {[string match "ERROR:*" $durasi]} { puthelp "PRIVMSG $chan :Unable to complete request. Reason: $durasi" ; return 0 }
		if {$durasi == "0"} { puthelp "PRIVMSG $chan :Streaming is not allowed." ; return 0 }
		if {[string match "WARNING:*" $durasi]} {
			set durasi ""
		} elseif {![string match "*:*" $durasi] && ![string match "*WARNING*" $durasi]} {
			set durasi "$durasi second"
		} else {
			set durasi "$durasi minutes"
		}
		set judulbaru [string map {" " "_" "ÂŽ" "" "ðŸŽ¶" "" "ðŸŽ§" "" "ðŸŽµ" "" "Ÿ" "" "¶" "" "?" "" "ð" "" "µ" "" {¤} {} {?} "" {`} "" {"} "" {?} "" {%} "persen" {[} "(" {]} ")" {|_} "" {/} "_" {|} "-" {/_} "-" {"_} "" {#} "" "é" "e"} $judul]
		putquick "PRIVMSG $chan :Trying to convert \002$judul\002 please wait..."
		if {$mptigasize != ""} {
			if {![matchattr $nick n]} {
				catch {exec youtube-dl --max-filesize $mptigasize --prefer-ffmpeg --no-playlist --no-mtime --ignore-config --geo-bypass --abort-on-error --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -x --audio-format mp3 --audio-quality 0 -o "$path/public_html/$judulbaru.%(ext)s" "$text"} mptigaruncmdd
			} else {
				catch {exec youtube-dl --prefer-ffmpeg --no-playlist --no-mtime --ignore-config --geo-bypass --abort-on-error --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -x --audio-format mp3 --audio-quality 0 -o "$path/public_html/$judulbaru.%(ext)s" "$text"} mptigaruncmdd
			}
		}
		foreach line [split $mptigaruncmdd "\n"] {
			if {[string match "ERROR:*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: $line" ; return 0 }
			if {[string match "*File is larger than max-filesize*" $line]} { puthelp "PRIVMSG $chan :File is too large. You can only download under \002$mptigasize\002" ; return 0 }
		}
		if {[file exists $path/public_html/$judulbaru.mp3] == 1} {
			set besar [fixform [file size "$path/public_html/$judulbaru.mp3"]]
			putquick "PRIVMSG $chan :Download Link: $linkdl$judulbaru.mp3 \[Size: \002$besar\002\] \[Duration: \002$durasi minutes\002\] | (Will be deleted in\002 30 minutes\002)"
			timer 30 [list apusmp3 $chan $judulbaru]
		} else {
			puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: An unexpected error."
		}
	}
}

## Mp4 ##
proc mpempat { nick host hand chan text } {
	global allowplaylist basech
	if {$chan != $basech} { return 0 }
	if {[lindex $text 0] == ""} { puthelp "PRIVMSG $chan :Type \002mp3 help\002 for command list." ; return 0 }
	if {[string match "*stream*" [string tolower $text]]} { puthelp "PRIVMSG $chan :Streaming is not allowed." ; return 0 }
	if {$allowplaylist == 1} {
		if {[string match "*playlist?list*" [string tolower $text]]} { puthelp "PRIVMSG $chan :Playlist is not allowed. (Only owner can Download big file)" ; return 0 }
	}
	if {![string match "*http*" [lindex $text 0]]} {
		mpempattext $nick $host $hand $chan $text
	} else {
		mpempatlink $nick $host $hand $chan $text
	}
}

proc mpempattext { nick host hand chan text } {
	global path linkdl judulbaru mpempatsize
	catch {exec youtube-dl -e --get-duration --get-id "ytsearch1:$text"} mpempatreplaytext
	foreach {judul id durasi} [split $mpempatreplaytext \n] {
		if {[string match "ERROR:*" $judul] || [string match "WARNING:*" $judul]} { puthelp "PRIVMSG $chan :Unable to complete request. Reason: $judul" ; return 0 }
		if {[string match "ERROR:*" $id] || [string match "WARNING:*" $id] || ($id == "")} { puthelp "PRIVMSG $chan :Unable to complete request. Reason: $id" ; return 0 }
		if {[string match "ERROR:*" $durasi]} { puthelp "PRIVMSG $chan :Unable to complete request. Reason: $durasi" ; return 0 }
		if {$durasi == "0"} { putquick "PRIVMSG $chan :Streaming is not allowed." ; return 0 }
		if {[string match "WARNING:*" $durasi]} {
			set durasi ""
		} elseif {![string match "*:*" $durasi] && ![string match "*WARNING*" $durasi]} {
			set durasi "$durasi second"
		} else {
			set durasi "$durasi minutes"
		}
		set judulbaru [string map {" " "_" "ÂŽ" "" "ðŸŽ¶" "" "ðŸŽ§" "" "ðŸŽµ" "" "Ÿ" "" "¶" "" "?" "" "ð" "" "µ" "" {¤} {} {?} "" {`} "" {"} "" {?} "" {%} "persen" {[} "(" {]} ")" {|_} "" {/} "_" {|} "-" {/_} "-" {"_} "" {#} "" "é" "e"} $judul]
		putquick "PRIVMSG $chan : Trying to convert \002$judul\002 please wait..."
		if {$mpempatsize != ""} {
			if {![matchattr $nick n]} {
				catch {exec youtube-dl --max-filesize $mpempatsize --prefer-ffmpeg --prefer-ffmpeg --no-playlist --no-mtime --abort-on-error --no-color --no-mark-watched --no-call-home --youtube-skip-dash-manifest -f mp4 -o "$path/public_html/$judulbaru.%(ext)s" "$text"} mpempatruncmd
			} else {
				catch {exec youtube-dl --prefer-ffmpeg --prefer-ffmpeg --no-playlist --no-mtime --abort-on-error --no-color --no-mark-watched --no-call-home --youtube-skip-dash-manifest -f mp4 -o "$path/public_html/$judulbaru.%(ext)s" "$text"} mpempatruncmd
			}
		}
		foreach line [split $mpempatruncmd "\n"] {
			if {[string match "ERROR:*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: $line" ; return 0 }
			if {[string match "*File is larger than max-filesize*" $line]} { puthelp "PRIVMSG $chan :File is too large. You can only download under \002$mpempatsize\002" ; return 0 }
		}
		if {[file exists $path/public_html/$judulbaru.mp4] == 1} {
			set besar [fixform [file size "$path/public_html/$judulbaru.mp4"]]
			putquick "PRIVMSG $chan :Download Link: $linkdl$judulbaru.mp4 \[Size: \002$besar\002\] \[Duration: \002$durasi minutes\002\] | (Will be deleted in\002 60 minutes\002)"
			timer 60 [list apusmp4 $chan $judulbaru]
		} else {
			puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: An unexpected error."
		}
	}
}

proc mpempatlink { nick host hand chan text } {
	global path linkdl judulbaru mpempatsize
	catch {exec youtube-dl -e --get-duration "$text"} mpempatreplaylink
	foreach {judul durasi} [split $mpempatreplaylink \n] {
		if {[string match "ERROR:*" $judul] || [string match "WARNING:*" $judul]} { puthelp "PRIVMSG $chan :Unable to complete request. Reason: $judul" ; return 0 }
		if {[string match "ERROR:*" $durasi]} { puthelp "PRIVMSG $chan :Unable to complete request. Reason: $durasi" ; return 0 }
		if {$durasi == "0"} { putquick "PRIVMSG $chan :Streaming is not allowed." ; return 0 }
		if {[string match "WARNING:*" $durasi]} {
			set durasi ""
		} elseif {![string match "*:*" $durasi] && ![string match "*WARNING*" $durasi]} {
			set durasi "$durasi second"
		} else {
			set durasi "$durasi minutes"
		}
		set judulbaru [string map {" " "_" "ÂŽ" "" "ðŸŽ¶" "" "ðŸŽ§" "" "ðŸŽµ" "" "Ÿ" "" "¶" "" "?" "" "ð" "" "µ" "" {¤} {} {?} "" {`} "" {"} "" {?} "" {%} "persen" {[} "(" {]} ")" {|_} "" {/} "_" {|} "-" {/_} "-" {"_} "" {#} "" "é" "e"} $judul]
		putquick "PRIVMSG $chan :Trying to convert \002$judul\002 please wait..."
		if {$mpempatsize != ""} {
			if {![matchattr $nick n]} {
				catch {exec youtube-dl --max-filesize $mpempatsize --prefer-ffmpeg --prefer-ffmpeg --no-playlist --no-mtime --abort-on-error --no-color --no-mark-watched --no-call-home --youtube-skip-dash-manifest -f mp4 -o "$path/public_html/$judulbaru.%(ext)s" "$text"} mpempatruncmdd
			} else {
				catch {exec youtube-dl --prefer-ffmpeg --prefer-ffmpeg --no-playlist --no-mtime --abort-on-error --no-color --no-mark-watched --no-call-home --youtube-skip-dash-manifest -f mp4 -o "$path/public_html/$judulbaru.%(ext)s" "$text"} mpempatruncmdd
			}
		}
		foreach line [split $mpempatruncmdd "\n"] {
			if {[string match "ERROR:*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: $line" ; return 0 }
			if {[string match "*File is larger than max-filesize*" $line]} { puthelp "PRIVMSG $chan :File is too large. You can only download under \002$mpempatsize\002" ; return 0 }
		}
		if {[file exists $path/public_html/$judulbaru.mp4] == 1} {
			set besar [fixform [file size "$path/public_html/$judulbaru.mp4"]]
			putquick "PRIVMSG $chan :Download Link: $linkdl$judulbaru.mp4 \[Size: \002$besar\002\] \[Duration: \002$durasi minutes\002\] | (Will be deleted in\002 60 minutes\002)"
			timer 60 [list apusmp4 $chan $judulbaru]
		} else {
			puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: An unexpected error."
		}
	}
}

## Help ##
proc daftar_help {nick host hand chan text} {
	global botnick
	if {[lindex $text 0] != $botnick} { return 0 }
	if {![matchattr $nick n]} {
		puthelp "PRIVMSG $nick :Mp3 Commands:"
		puthelp "PRIVMSG $nick :\002.mp3 <title + singer>\002 | Example: .mp3 stoney - lobo"
		puthelp "PRIVMSG $nick :\002.mp3 <link>\002 | Example: .mp3 https://www.youtube.com/watch?v=2y-aB3VAaB8"
		puthelp "PRIVMSG $nick :Mp4 Commands:"
		puthelp "PRIVMSG $nick :\002.mp4 <title>\002 | Example: .mp4 cinderella"
		puthelp "PRIVMSG $nick :\002.mp4 <link>\002 | Example: .mp4 https://www.youtube.com/watch?v=2y-aB3VAaB8"
		puthelp "PRIVMSG $nick :- END -"
	} else {
		puthelp "PRIVMSG $nick :Mp3 Commands:"
		puthelp "PRIVMSG $nick :\002.mp3 <title + singer>\002 | Example: .mp3 stoney - lobo"
		puthelp "PRIVMSG $nick :\002.mp3 <link>\002 | Example: .mp3 https://www.youtube.com/watch?v=2y-aB3VAaB8"
		puthelp "PRIVMSG $nick :Mp4 Commands:"
		puthelp "PRIVMSG $nick :\002.mp4 <title>\002 | Example: .mp4 cinderella"
		puthelp "PRIVMSG $nick :\002.mp4 <link>\002 | Example: .mp4 https://www.youtube.com/watch?v=2y-aB3VAaB8"
		puthelp "PRIVMSG $nick :-"
		puthelp "PRIVMSG $nick :\002<botnick> on\002 | Active the bot."
		puthelp "PRIVMSG $nick :\002<botnick> off\002 | Deactive the bot."
		puthelp "PRIVMSG $nick :\002<botnick> clear file\002 | Delete file."
		puthelp "PRIVMSG $nick :\002<botnick> clear cache\002 | Delete cache."
		puthelp "PRIVMSG $nick :\002<botnick> update\002 | Update youtube-dl version."
		puthelp "PRIVMSG $nick :\002<botnick> sites list\002 | Supported link."
		puthelp "PRIVMSG $nick :- END -"
	}
}

## Delete Cache ##
proc delete_cache {nick host hand chan text} {
	global botnick path
	if {[lindex $text 0] != $botnick} { return 0 }
	set cekcache [glob -nocomplain [file join $path/.cache/youtube-dl/youtube-sigfuncs/ *]]
	if {[llength $cekcache] != 0} {
		eval file delete -force [glob $path/.cache/youtube-dl/youtube-sigfuncs/*]
		puthelp "PRIVMSG $chan :All cache has been deleted."
	} else {
		puthelp "PRIVMSG $chan :Folder is empty."
	}
}

## Delete File ##
proc delete_file {nick host hand chan text} {
	global botnick path
	if {[lindex $text 0] != $botnick} { return 0 }
	set cekisi [glob -nocomplain [file join $path/public_html/ *]]
	if {[llength $cekisi] != 0} {
		eval file delete -force [glob $path/public_html/*]
		puthelp "PRIVMSG $chan :All files has been deleted."
	} else {
		puthelp "PRIVMSG $chan :Folder is empty."
	}
}

## Auto Delete File ##
proc apusmp4 {chan judulbaru} {
	global path
	if {[file exists $path/public_html/$judulbaru.mp4] == 1} {
		file delete [glob $path/public_html/$judulbaru.mp4]
		puthelp "PRIVMSG $chan :File\002 $judulbaru.mp4 \002deleted."
	}
}
proc apusmp3 {chan judulbaru} {
	global path
	if {[file exists $path/public_html/$judulbaru.mp3] == 1} {
		file delete [glob $path/public_html/$judulbaru.mp3]
		puthelp "PRIVMSG $chan :File\002 $judulbaru.mp3 \002deleted."
	}
}

## PUB ON/OFF ##
proc pub_on {nick uhost hand chan arg} {
	global botnick
	if {[lindex $arg 0] != $botnick} { return 0 }
	if {[channel get $chan mp3]} {
		puthelp "PRIVMSG $chan :Already activated"
		return 0
	}
	channel set $chan +mp3
	puthelp "PRIVMSG $chan :Mp3 Downloader is now \002ACTIVATED\002. Type\002 $botnick help \002for commands list."
}
proc pub_off {nick uhost hand chan arg} {
	global botnick
	if {[lindex $arg 0] != $botnick} { return 0 }
	if {![channel get $chan mp3]} {
		puthelp "PRIVMSG $chan :Already Deactivated"
		return 0
	}
	channel set $chan -mp3
	puthelp "PRIVMSG $chan :- DEACTIVE -"
}

## Update youtube-dl Version ##
proc pub_update {nick host hand chan arg} {
	global botnick
	if {[lindex $arg 0] != $botnick} { return 0 }
	catch {exec youtube-dl -U} updated
	foreach x [split $updated) "\n"] {
		if {[string match "*up-to-date*" $x]} {
			catch {exec youtube-dl --version} versi
			puthelp "PRIVMSG $chan :Your version is Up To Date (\002$versi\002)"
		} elseif {[string match -nocase "*ERROR*" $x]} {
			puthelp "PRIVMSG $chan :$x"
		} else {
			set update [lindex $x 3 end]
			puthelp "PRIVMSG $chan :New version is available, starting upgrade to $update"
			puthelp "PRIVMSG $chan :Done"
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

proc daftar_link { nick host hand chan text } {
	if {[channel get $chan mp3]} {
		puthelp "PRIVMSG $chan :List of supported sites http://bit.do/sites_list"
	}
}
