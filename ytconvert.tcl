#######################################################
#
#									Mp3 and Mp4 Downloader
#												Version 1.5
#
# Author: Vaksin
# Copyright © 2016 All Rights Reserved.
#
#######################################################

# ############
# REQUIREMENTS
# ############
# 1. youtube-dl (https://ytdl-org.github.io/youtube-dl/index.html)
# 2. ffmpeg + ffprob package (https://ffmpeg.org/download.html)
# 3. python (https://www.python.org/downloads/)

# ##########
# CHANGELOG
# ##########
# 1.0
# -First release.
# 1.1
# -Error message now with full reply.
# -Fixed some bugs.
# 1.2
# -Added code for block streaming.
# -Fixed bugs.
# 1.3
# -Recoded some code.
# -Added clear file(s) command.
# -Added to allow/block for download playlist (Default is allowed).
# -Fixed bugs.
# 1.4
# -Added option for remove special characters. (Now all special characters removed)..
# -Added mp3-mp4 download size limit (Default is mp3 = 20m, mp4 = 50m).
# -Added permission for download playlist.
#
# 1.5
# -Added code for download from smule.com

# ##############
# BASIC COMMANDS
# ##############
# To active or deactivate your bot, use this command: <botnick> on/off
# E.g: "mp3 on" or "mp3 off"
# (Type "<botnick> help" in channel for command list).

# ######
# USAGE
# ######
# .chanset #channel +mp3

# ########
# CONTACT
# ########
#  If you have any suggestions, comments, questions or report bugs,
#  you can find me on IRC @ForumCerdas Network.
#
#  /server irc.forumcerdas.net:6667 or /server irc.dal.net:6667
# Channel: #mp3 (ForumCerdas)
# Nick: Vaksin

#######
# Credit:
#######
# rhe (for server)
# Tabrak_lari (for smule tutor)
# KaK (for smule title idea)
######################################################

######################################################
### Settings ###
######################################################

# This is link for download the mp3 or mp4 file.
set linkdl "http://your.site/~user/"

# Set Your Youtube API Key
set key "YOUR API KEY"

# Mp3 and Mp4 Size Limit for download. (Set it blank for free size)
# Example: set audiosize ""
if {![info exist audiosize]} { set audiosize "20m" }
if {![info exist mpempatsize]} { set mpempatsize "50m" }

# Allow Playlist download or not.
# 0 = Allowed, 1 = Not allowed.
if {![info exist allowplaylist]} { set allowplaylist "1" }

###############################################################################
### End of Settings ###
###############################################################################

###############################################################################
#
#      DON'T CHANGE ANYTHING BELOW EVEN YOU KNOW TCL.
#
###############################################################################
setudef flag mp3

package require http
package require tls
::tls::init -tls1 true -ssl2 false -ssl3 false
::http::register https 443 ::tls::socket
::http::config -useragent "Mozilla/5.0 (X11; Linux x86_64; rv:59.0) Gecko/20100101 Firefox/59.0"

bind pub - .mp3 mptiga
bind pub - .mp4 mpempat
bind pub - .smule pub_smule
bind pub - .cari searchlagu
bind pub - .settings mp3_settings
bind pub n .ytver liat_versi
bind pub n .size ganti_size
bind pub n +playlist playlist:on
bind pub n -playlist playlist:off
bind pub n .clear delete_file
bind pubm - "* on" pub:on
bind pubm - "* off" pub:off
bind pubm - "* help" daftar_help

proc pub:on { nick host hand chan text } {
	global botnick
	if {[lindex $text 0] != $botnick} { return 0 }
	if {![matchattr $nick n]} {
		puthelp "PRIVMSG $chan :Owner only."
		return 0
	}
	if {[channel get $chan mp3]} {
		puthelp "PRIVMSG $chan :Already activated."
		return 0
	}
	channel set $chan +mp3
	puthelp "PRIVMSG $chan :\002ACTIVATED\002"
}
proc pub:off { nick host hand chan text } {
	global botnick
	if {[lindex $text 0] != $botnick} { return 0 }
	if {![matchattr $nick n]} {
		puthelp "PRIVMSG $chan :Owner only."
		return 0
	}
	if {![channel get $chan mp3]} {
		puthelp "PRIVMSG $chan :Already deactivated."
		return 0
	}
	channel set $chan -mp3
	puthelp "PRIVMSG $chan :\002DEACTIVATED\002"
}

## Mp3 ##
proc mptiga { nick host hand chan text } {
	global linkdl audiosize allowplaylist
	if {![channel get $chan mp3]} { return 0 }
	if {[lindex $text 0] == ""} { puthelp "PRIVMSG $chan :Type \002mp3 help\002 for command list." ; return 0 }
	if {[string length $text] < 3} { puthelp "PRIVMSG $chan :Maximum 3 characters for Download." ; return 0 }
	if {[string match "*smule.com*" [string tolower $text]] && ![string match "*.m4a*" [string tolower $text]] && ![string match "*.mp4*" [string tolower $text]]} { puthelp "PRIVMSG $chan :Type: \002.smule\002 for how to download from smule." ; return 0 }
	if {$allowplaylist == 1} { if {[string match "*playlist?list*" [string tolower $text]]} { puthelp "PRIVMSG $chan :Download playlist is not allowed." ; return 0 } }
	if {![string match "*http*" [string tolower $text]]} {
		catch {exec youtube-dl --skip-download --no-warnings --get-id --get-duration --restrict-filenames --get-filename -o "%(title)s" "ytsearch1:$text"} mptigareplaytxt
		foreach {id namafile durasi} [split $mptigareplaytxt "\n"] {
			if {[string match -nocase "*ERROR:*" $id]} { puthelp "PRIVMSG $chan :$id" ; return 0 }
			if {[string match -nocase "*ERROR:*" $namafile] || [string match -nocase "*WARNING:*" $namafile]} { puthelp "PRIVMSG $chan :$namafile" ; return 0 }
			if {[string match -nocase "*ERROR:*" $durasi]} { puthelp "PRIVMSG $chan :$durasi" ; return 0 }
			if {$durasi == "0"} { puthelp "PRIVMSG $chan :Download streaming is not allowed." ; return 0 }
			set judul [string map {{_} { }} $namafile]
			set yturl "https://youtu.be/$id"
			if {[string match "WARNING:*" $durasi] || $durasi == ""} {
				set durasi "unknown"
			} elseif {![string match "*:*" $durasi] && ![string match "*WARNING*" $durasi] && $durasi != ""} {
				set durasi "$durasi second"
			} elseif {[string match "*:*:*" $durasi]} {
				set durasi "$durasi hours"
			} else {
				set durasi "$durasi minutes"
			}
		}
		putquick "PRIVMSG $chan :Converting \002\u0022$judul\u0022\002 please wait..."
		if {[file exists ~/public_html/$namafile.mp3]} {
			set besar [fixform [file size "~/public_html/$namafile.mp3"]]
			putquick "PRIVMSG $chan :Download Link: $linkdl$namafile.mp3 \[Size: \002$besar\002\] \[Duration: \002$durasi\002\] - (\002\u0022\0034FINAL VERSION\003\u0022\002 \0033Will be released soon\003.)"
			return 0
		}
		if {$audiosize != ""} {
			if {![matchattr $nick n]} {
				catch {exec youtube-dl "$yturl" --http-chunk-size 10M --max-filesize $audiosize --ignore-config --no-progress --no-part --no-cache-dir --no-resize-buffer --abort-on-error --no-mtime --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -x --audio-format "mp3" -o "~/public_html/$namafile.%(ext)s"} mptigatext
			} else {
				catch {exec youtube-dl "$yturl" --http-chunk-size 10M --ignore-config --no-progress --no-part --no-cache-dir --no-resize-buffer --abort-on-error --no-mtime --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -x --audio-format "mp3" -o "~/public_html/$namafile.%(ext)s"} mptigatext
			}
		}
		foreach line [split $mptigatext "\n"] {
			if {[string match "ERROR:*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: $line" ; return 0 }
			if {[string match "*File is larger than max-filesize*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: File is larger than\002 $audiosize\002. (Only owner can Download big file)" ; return 0 }
			if {[string match "*.mp3"  $line]} {
				set besar [fixform [file size "~/public_html/$namafile.mp3"]]
				putquick "PRIVMSG $chan :Download Link: $linkdl$namafile.mp3 \[Size: \002$besar\002\] \[Duration: \002$durasi\002\] - (\002\u0022\0034FINAL VERSION\003\u0022\002 \0033Will be released soon\003.)"
				timer 30 [list apusmp3 $namafile]
				return 0
			}
		}
	} else {
		# Download by link
		if {[string match "*smule.com*" [lindex $text 0]]} {
			if {[lindex $text 1] == ""} {
				puthelp "PRIVMSG $chan :For download from smule you must give the title. Syntax: \002.mp3 <link> <title>\002"
				return 0
			} else {
				set judul [lrange $text 1 end]
				set text [lindex $text 0]
				set durasi "Unknown"
			}
			putquick "PRIVMSG $chan :Converting \002\u0022$judul\u0022\002 please wait..."
			set namafile [string map {{ } {_}} $judul]
			if {[file exists ~/public_html/$namafile.mp3]} {
				set besar [fixform [file size "~/public_html/$namafile.mp3"]]
				putquick "PRIVMSG $chan :Download Link: $linkdl$namafile.mp3 \[Size: \002$besar\002\] \[Duration: \002$durasi\002\] - (\002\u0022\0034FINAL VERSION\003\u0022\002 \0033Will be released soon\003.)"
				return 0
			}
			if {$audiosize != ""} {
				if {![matchattr $nick n]} {
					catch {exec youtube-dl "$text" --http-chunk-size 10M --max-filesize $audiosize --ignore-config --no-progress --no-part --no-cache-dir --no-resize-buffer --abort-on-error --no-mtime --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -x --audio-format "mp3" -o "~/public_html/$namafile.%(ext)s"} mptigalink
				} else {
					catch {exec youtube-dl "$text" --http-chunk-size 10M --ignore-config --no-progress --no-part --no-cache-dir --no-resize-buffer --abort-on-error --no-mtime --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -x --audio-format "mp3" -o "~/public_html/$namafile.%(ext)s"} mptigalink
				}
			}
			foreach line [split $mptigalink "\n"] {
				if {[string match "ERROR:*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: $line" ; return 0 }
				if {[string match "*File is larger than max-filesize*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: File is larger than\002 $audiosize\002. (Only owner can Download big file)" ; return 0 }
				if {[string match "*.mp3"  $line]} {
					set besar [fixform [file size ~/public_html/$namafile.mp3]]
					putquick "PRIVMSG $chan :Download Link: $linkdl$namafile.mp3 \[Size: \002$besar\002\] \[Duration: \002Unknown\002\] - (\002\u0022\0034FINAL VERSION\003\u0022\002 \0033Will be released soon\003.)"
					timer 30 [list apusmp3 $namafile]
					return 0
				}
			}
		} else {
			if {[string match "*smule.com*" [string tolower $text]]} { return 0 }
			foreach v $text { if {[string match "http*" [string tolower $v]]} { set text $v } }
			catch {exec youtube-dl --skip-download --no-warnings --get-duration --restrict-filenames --get-filename -o "%(title)s" $text} mptigareplaylink
			foreach {namafile durasi} [split $mptigareplaylink "\n"] {
				if {[string match -nocase "*ERROR:*" $namafile] || [string match -nocase "*WARNING:*" $namafile]} { puthelp "PRIVMSG $chan :$namafile" ; return 0 }
				if {[string match -nocase "*ERROR:*" $durasi]} { puthelp "PRIVMSG $chan :$durasi" ; return 0 }
				if {$durasi == "0"} { puthelp "PRIVMSG $chan :Download streaming is not allowed." ; return 0 }
				set judul [string map {{_} { }} $namafile]
				if {[string match "WARNING:*" $durasi] || $durasi == ""} {
					set durasi "unknown"
				} elseif {![string match "*:*" $durasi] && ![string match "*WARNING*" $durasi] && $durasi != ""} {
					set durasi "$durasi second"
				} elseif {[string match "*:*:*" $durasi]} {
					set durasi "$durasi hours"
				} else {
					set durasi "$durasi minutes"
				}
			}
			putquick "PRIVMSG $chan :Converting \002\u0022$judul\u0022\002 please wait..."
			if {[file exists ~/public_html/$namafile.mp3]} {
				set besar [fixform [file size "~/public_html/$namafile.mp3"]]
				putquick "PRIVMSG $chan :Download Link: $linkdl$namafile.mp3 \[Size: \002$besar\002\] \[Duration: \002$durasi\002\] - (\002\u0022\0034FINAL VERSION\003\u0022\002 \0033Will be released soon\003.)"
				return 0
			}
			if {$audiosize != ""} {
				if {![matchattr $nick n]} {
					catch {exec youtube-dl "$text" --http-chunk-size 10M --max-filesize $audiosize --ignore-config --no-progress --no-part --no-cache-dir --no-resize-buffer --abort-on-error --no-mtime --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -x --audio-format "mp3" -o "~/public_html/$namafile.%(ext)s"} mptigalink
				} else {
					catch {exec youtube-dl "$text" --http-chunk-size 10M --ignore-config --no-progress --no-part --no-cache-dir --no-resize-buffer --abort-on-error --no-mtime --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -x --audio-format "mp3" -o "~/public_html/$namafile.%(ext)s"} mptigalink
				}
			}
			foreach line [split $mptigalink "\n"] {
				if {[string match "ERROR:*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: $line" ; return 0 }
				if {[string match "*File is larger than max-filesize*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: File is larger than\002 $audiosize\002. (Only owner can Download big file)" ; return 0 }
				if {[string match "*.mp3"  $line]} {
					set besar [fixform [file size "~/public_html/$namafile.mp3"]]
					putquick "PRIVMSG $chan :Download Link: $linkdl$namafile.mp3 \[Size: \002$besar\002\] \[Duration: \002$durasi\002\] - (\002\u0022\0034FINAL VERSION\003\u0022\002 \0033Will be released soon\003.)"
					timer 30 [list apusmp3 $namafile]
				}
			}
		}
	}
}

## Mp4 ##
proc mpempat { nick host hand chan text } {
	global linkdl mpempatsize allowplaylist
	if {![channel get $chan mp3]} { return 0 }
	if {[lindex $text 0] == ""} { puthelp "PRIVMSG $chan :Type \002mp3 help\002 for command list." ; return 0 }
	if {[string length $text] < 3} { puthelp "PRIVMSG $chan :Maximum 3 characters for Download." ; return 0 }
	if {[string match "*smule.com*" [string tolower $text]] && ![string match "*.m4a*" [string tolower $text]] && ![string match "*.mp4*" [string tolower $text]]} { puthelp "PRIVMSG $chan :Type: \002.smule\002 for how to download from smule." ; return 0 }
	if {$allowplaylist == 1} { if {[string match "*playlist?list*" [string tolower $text]]} { puthelp "PRIVMSG $chan :Download playlist is not allowed." ; return 0 } }
	if {![string match "*http*" [string tolower $text]]} {
		catch {exec youtube-dl --skip-download --no-warnings --get-id --get-duration --restrict-filenames --get-filename -o "%(title)s" "ytsearch1:$text"} mpempatreplaytxt
		foreach {id namafile durasi} [split $mpempatreplaytxt "\n"] {
			if {[string match -nocase "*ERROR:*" $id]} { puthelp "PRIVMSG $chan :$id" ; return 0 }
			if {[string match -nocase "*ERROR:*" $namafile] || [string match -nocase "*WARNING:*" $namafile]} { puthelp "PRIVMSG $chan :$namafile" ; return 0 }
			if {[string match -nocase "*ERROR:*" $durasi]} { puthelp "PRIVMSG $chan :$durasi" ; return 0 }
			if {$durasi == "0"} { puthelp "PRIVMSG $chan :Download streaming is not allowed." ; return 0 }
			set judul [string map {{_} { }} $namafile]
			set yturl "https://youtu.be/$id"
			if {[string match "WARNING:*" $durasi] || $durasi == ""} {
				set durasi "unknown"
			} elseif {![string match "*:*" $durasi] && ![string match "*WARNING*" $durasi] && $durasi != ""} {
				set durasi "$durasi second"
			} elseif {[string match "*:*:*" $durasi]} {
				set durasi "$durasi hours"
			} else {
				set durasi "$durasi minutes"
			}
		}
		putquick "PRIVMSG $chan :Converting \002\u0022$judul\u0022\002 please wait..."
		if {[file exists ~/public_html/$namafile.mp4]} {
			set besar [fixform [file size "~/public_html/$namafile.mp4"]]
			putquick "PRIVMSG $chan :Download Link: $linkdl$namafile.mp4 \[Size: \002$besar\002\] \[Duration: \002$durasi\002\] - (\002\u0022\0034FINAL VERSION\003\u0022\002 \0033Will be released soon\003.)"
			return 0
		}
		if {$mpempatsize != ""} {
			if {![matchattr $nick n]} {
				catch {exec youtube-dl "$yturl" --http-chunk-size 10M --max-filesize $mpempatsize --ignore-config --no-progress --no-part --no-cache-dir --no-resize-buffer --no-mtime --abort-on-error --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -f mp4 -o "~/public_html/$namafile.%(ext)s"} mpempattext
			} else {
				catch {exec youtube-dl "$yturl" --http-chunk-size 10M --restrict-filenames --ignore-config --no-progress --no-part --no-cache-dir --no-resize-buffer --no-mtime --abort-on-error --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -f mp4 -o "~/public_html/$namafile.%(ext)s"} mpempattext
			}
		}
		foreach line [split $mpempattext "\n"] {
			if {[string match "ERROR:*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: $line" ; return 0 }
			if {[string match "*File is larger than max-filesize*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: File is larger than\002 $audiosize\002. (Only owner can Download big file)" ; return 0 }
			if {[string match "*.mp4"  $line]} {
				set besar [fixform [file size "~/public_html/$namafile.mp4"]]
				putquick "PRIVMSG $chan :Download Link: $linkdl$namafile.mp4 \[Size: \002$besar\002\] \[Duration: \002$durasi\002\] - (\002\u0022\0034FINAL VERSION\003\u0022\002 \0033Will be released soon\003.)"
				timer 60 [list apusmp4 $namafile]
				return 0
			}
		}
	} else {
		# Download by link
		if {[string match "*smule.com*" [lindex $text 0]]} {
			if {[lindex $text 1] == ""} {
				puthelp "PRIVMSG $chan :For download from smule you must give the title. Syntax: \002.mp3 <link> <title>\002"
				return 0
			} else {
				set judul [lrange $text 1 end]
				set text [lindex $text 0]
				set durasi "Unknown"
			}
			putquick "PRIVMSG $chan :Converting \002\u0022$judul\u0022\002 please wait..."
			set namafile [string map {{ } {_}} $judul]
			if {[file exists ~/public_html/$namafile.mp4]} {
				set besar [fixform [file size "~/public_html/$namafile.mp4"]]
				putquick "PRIVMSG $chan :Download Link: $linkdl$namafile.mp4 \[Size: \002$besar\002\] \[Duration: \002$durasi\002\] - (\002\u0022\0034FINAL VERSION\003\u0022\002 \0033Will be released soon\003.)"
				return 0
			}
			if {$mpempatsize != ""} {
				if {![matchattr $nick n]} {
					catch {exec youtube-dl "$text" --http-chunk-size 10M --max-filesize $mpempatsize --restrict-filenames --ignore-config --no-progress --no-part --no-cache-dir --no-resize-buffer --no-mtime --abort-on-error --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -f mp4 -o "~/public_html/$namafile.%(ext)s"} mpempatlink
				} else {
					catch {exec youtube-dl "$text" --http-chunk-size 10M --restrict-filenames --ignore-config --no-progress --no-part --no-cache-dir --no-resize-buffer --no-mtime --abort-on-error --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -f mp4 -o "~/public_html/$namafile.%(ext)s"} mpempatlink
				}
			}
			foreach line [split $mpempatlink "\n"] {
				if {[string match "ERROR:*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: $line" ; return 0 }
				if {[string match "*File is larger than max-filesize*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: File is larger than\002 $audiosize\002. (Only owner can Download big file)" ; return 0 }
				if {[string match "*.mp4"  $line]} {
					set besar [fixform [file size "~/public_html/$namafile.m4a"]]
					putquick "PRIVMSG $chan :Download Link: $linkdl$namafile.mp4 \[Size: \002$besar\002\] \[Duration: \002Unknown\002\] - (\002\u0022\0034FINAL VERSION\003\u0022\002 \0033Will be released soon\003.)"
					timer 60 [list apusmp4 $namafile]
					return 0
				}
			}
		} else {
			if {[string match "*smule.com*" [string tolower $text]]} { return 0 }
			foreach v $text { if {[string match "http*" [string tolower $v]]} { set text $v } }
			catch {exec youtube-dl --skip-download --no-warnings --get-duration --restrict-filenames --get-filename -o "%(title)s" $text} mpempatreplaylink
			foreach {namafile durasi} [split $mpempatreplaylink \n] {
				if {[string match -nocase "*ERROR:*" $namafile] || [string match -nocase "*WARNING:*" $namafile]} { puthelp "PRIVMSG $chan :$namafile" ; return 0 }
				if {[string match -nocase "*ERROR:*" $durasi]} { puthelp "PRIVMSG $chan :$durasi" ; return 0 }
				if {$durasi == "0"} { puthelp "PRIVMSG $chan :Download streaming is not allowed." ; return 0 }
				set judul [string map {{_} { }} $namafile]
				if {[string match "WARNING:*" $durasi] || $durasi == ""} {
					set durasi "unknown"
				} elseif {![string match "*:*" $durasi] && ![string match "*WARNING*" $durasi] && $durasi != ""} {
					set durasi "$durasi second"
				} elseif {[string match "*:*:*" $durasi]} {
					set durasi "$durasi hours"
				} else {
					set durasi "$durasi minutes"
				}
			}
			putquick "PRIVMSG $chan :Converting \002\u0022$judul\u0022\002 please wait..."
			if {[file exists ~/public_html/$namafile.mp4]} {
				set besar [fixform [file size "~/public_html/$namafile.mp4"]]
				putquick "PRIVMSG $chan :Download Link: $linkdl$namafile.mp4 \[Size: \002$besar\002\] \[Duration: \002$durasi\002\] - (\002\u0022\0034FINAL VERSION\003\u0022\002 \0033Will be released soon\003.)"
				return 0
			}
			if {$mpempatsize != ""} {
				if {![matchattr $nick n]} {
					catch {exec youtube-dl "$text" --http-chunk-size 10M --max-filesize $mpempatsize --restrict-filenames --ignore-config --no-progress --no-part --no-cache-dir --no-resize-buffer --no-mtime --abort-on-error --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -f mp4 -o "~/public_html/$namafile.%(ext)s"} mpempatlink
				} else {
					catch {exec youtube-dl "$text" --http-chunk-size 10M --restrict-filenames --ignore-config --no-progress --no-part --no-cache-dir --no-resize-buffer --no-mtime --abort-on-error --no-color --no-mark-watched --no-call-home --no-warnings --youtube-skip-dash-manifest -w -f mp4 -o "~/public_html/$namafile.%(ext)s"} mpempatlink
				}
			}
			foreach line [split $mpempatlink "\n"] {
				if {[string match "ERROR:*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: $line" ; return 0 }
				if {[string match "*File is larger than max-filesize*" $line]} { puthelp "PRIVMSG $chan :Convert unsuccessful. Reason: File is larger than\002 $audiosize\002. (Only owner can Download big file)" ; return 0 }
				if {[string match "*.mp4"  $line]} {
					set besar [fixform [file size "~/public_html/$namafile.mp4"]]
					putquick "PRIVMSG $chan :Download Link: $linkdl$namafile.mp4 \[Size: \002$besar\002\] \[Duration: \002$durasi\002\] - (\002\u0022\0034FINAL VERSION\003\u0022\002 \0033Will be released soon\003.)"
					timer 60 [list apusmp4 $namafile]
				}
			}
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
		puthelp "PRIVMSG $nick :-"
		puthelp "PRIVMSG $nick :\002.smule\002 | How to download from smule.com"
		puthelp "PRIVMSG $nick :- END -"
	} else {
		puthelp "PRIVMSG $nick :Mp3 Commands:"
		puthelp "PRIVMSG $nick :\002.mp3 <title + singer>\002 | Example: .mp3 stoney - lobo"
		puthelp "PRIVMSG $nick :\002.mp3 <link>\002 | Example: .mp3 https://www.youtube.com/watch?v=2y-aB3VAaB8"
		puthelp "PRIVMSG $nick :Mp4 Commands:"
		puthelp "PRIVMSG $nick :\002.mp4 <title>\002 | Example: .mp4 cinderella"
		puthelp "PRIVMSG $nick :\002.mp4 <link>\002 | Example: .mp4 https://www.youtube.com/watch?v=2y-aB3VAaB8"
		puthelp "PRIVMSG $nick :-"
		puthelp "PRIVMSG $nick :\002.smule\002 | How to download from smule.com"
		puthelp "PRIVMSG $nick :\002.ytver\002 | Check youtube-dl version."
		puthelp "PRIVMSG $nick :\002.size mp3/mp4 <size>\002 | Mp3/mp4 size limit for download. Example: .size mp3 20m"
		puthelp "PRIVMSG $nick :\002+playlist\002 | Allow download playlist."
		puthelp "PRIVMSG $nick :\002-playlist\002 | Block download playlist."
		puthelp "PRIVMSG $nick :\002.clear\002 | Delete file."
		puthelp "PRIVMSG $nick :\002.settings\002 | Show setting."
		puthelp "PRIVMSG $nick :- END -"
	}
}

## Delete File ##
proc delete_file {nick host hand chan text} {
	set cekisi [glob -nocomplain [file join ~/public_html/ *]]
	if {[llength $cekisi] != 0} {
		eval file delete -force [glob ~/public_html/*]
		puthelp "PRIVMSG $chan :All files has been deleted."
	} else {
		puthelp "PRIVMSG $chan :Folder is empty."
	}
}

## Auto Delete File ##
proc apusmp3 {namafile} { if {[file exists ~/public_html/$namafile.mp3]} { file delete [glob ~/public_html/$namafile.mp3] } }
proc apusmp4 {namafile} { if {[file exists ~/public_html/$namafile.mp4]} { file delete [glob ~/public_html/$namafile.mp4] } }

## Playlist ##
proc playlist:on {nick host hand chan text} { global allowplaylist ; set allowplaylist 1 ; puthelp "PRIVMSG $chan :Playlist can't be downloaded now." }
proc playlist:off {nick host hand chan text} { global allowplaylist ; set allowplaylist 0 ; puthelp "PRIVMSG $chan :Allow to download Playlist." }

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

proc ganti_size {nick host hand chan text} {
	global audiosize mpempatsize
	if {[lindex $text 0] == ""} { puthelp "PRIVMSG $chan :Syntax:\002.size <mp3/mp4> <size>"; puthelp "PRIVMSG $chan :Syntax:\002.size <off>" ; return 0 }
	if {[lindex $text 0] == "mp3"} { 
		set size [lindex $text 1]
		set audiosize $size
		puthelp "PRIVMSG $chan :Mp3 download size changed."
	} elseif {[lindex $text 0] == "mp4"} {
		set size [lindex $text 1]
		set mpempatsize $size
		puthelp "PRIVMSG $chan :Mp4 download size changed."
	} elseif {[lindex $text 0] == "off"} {
		set audiosize ""
		set mpempatsize ""
		puthelp "PRIVMSG $chan :Download size now is \002FREE\002."
	}
}
proc mp3_settings {nick host hand chan text} {
	global audiosize mpempatsize allowplaylist
	puthelp "PRIVMSG $chan :Mp3 and M4a maximal size limit is \002$audiosize\002"
	puthelp "PRIVMSG $chan :Mp4 maximal size limit is \002$mpempatsize\002"
	if {$allowplaylist == 0} { puthelp "PRIVMSG $chan :Download Playlist is \002Allowed\002" ; return }
	if {$allowplaylist == 1} { puthelp "PRIVMSG $chan :Download Playlist is \002Not allowed\002" ; return }
}

proc liat_versi {nick host hand chan text} {
	set versiakhir ""
	set myversi [exec youtube-dl --version]
	set dlurl "https://ytdl-org.github.io/youtube-dl/download.html"
	set tok [::http::geturl $dlurl]
	set data [::http::data $tok]
	http::cleanup $tok
	
	regexp -nocase {<h2>(.*?)>} $data versiakhir
	
	regsub -all "<h2>" $versiakhir "" versiakhir
	regsub -all "<a href=" $versiakhir "" versiakhir
	regsub -all ">" $versiakhir "" versiakhir
	regsub -all {"} $versiakhir {} versiakhir
	regsub -all "https://yt-dl.org/downloads/" $versiakhir "" versiakhir
	regsub -all "/youtube-dl" $versiakhir "" versiakhir
	
	if {[regexp -all -line $myversi $versiakhir]} {
		puthelp "PRIVMSG $chan :YOUTUBE-DL version is: \002$myversi\002 (Latest version)"
		return 0
	} else {
		puthelp "PRIVMSG $chan :YOUTUBE-DL version is: \002$myversi\002 (There is a new version \002$versiakhir\002 updating...)"
		catch {exec youtube-dl -U} updated
		foreach updt [split $updated "\n"] {
			if {[string match "*installed youtube-dl with a package*" [string tolower $updt]]} {
				catch {exec pip install --upgrade youtube-dl} updatedd
				set lastversi [exec youtube-dl --version]
				if {[regexp -all -line $lastversi $versiakhir]} {
					puthelp "PRIVMSG $chan :Done. (Updated to.\002$lastversi\002)"
				} else {
					puthelp "PRIVMSG $chan :$updatedd"
				}
			} elseif {[string match $versiakhir $updt]} {
				puthelp "PRIVMSG $chan :Done. (Updated to.\002$versiakhir\002)"
			} else {
				puthelp "PRIVMSG $chan :$updt"
			}
		}
	}
}

proc pub_smule {nick host hand chan text} {
	if {![channel get $chan mp3]} { return 0 }
	puthelp "PRIVMSG $chan :How to download from smule.com without application:"
	puthelp "PRIVMSG $chan :-"
	puthelp "PRIVMSG $chan :1. Change \002smule.com\002 to \002smuledownloader.download\002"
	puthelp "PRIVMSG $chan :E.g: https://www.smule.com/p/1320261507_1604426764 ---> https://www.smuledownloader.download/p/1320261507_1604426764"
	puthelp "PRIVMSG $chan :2. Put \002view-source:\002 in front of the link you have changed before."
	puthelp "PRIVMSG $chan :E.g: https://www.smuledownloader.download/p/1320261507_1604426764 ---> view-source:https://www.smuledownloader.download/p/1320261507_1604426764"
	puthelp "PRIVMSG $chan :3. Open it using Chrome or Firefox."
	puthelp "PRIVMSG $chan :4. Search \002<div id=audiolink><p>\002 and then copy the link (Ended with .m4a) for download."
	puthelp "PRIVMSG $chan :5. Syntax: \002.mp3 <link> <title>\002"
	puthelp "PRIVMSG $chan :E.g: .mp3 https://c-ash.smule.com/sf/y58/sing/performance/rendered/01/0a/7ddfcc95-c135-4146-bb84-f6b48433b748.m4a Sorry Not Sorry"
	puthelp "PRIVMSG $chan :-"
}
