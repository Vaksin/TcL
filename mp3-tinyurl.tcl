##############################################################
## iJooMP3.tcl                                              ## 
## Created For Fun                                          ##
##                                                          ##
##                             Jakarta, 16-11-16            ##
##                                  iJoo.oRg                ##
##                                                          ##
## Dependencies :                                           ##
##  youtube-dl  (https://rg3.github.io/youtube-dl/)         ##
##  FFMPEG      (https://ffmpeg.org/)                       ##
##                                                          ##
## Usage :                                                  ##
##  .chanset #channel +ijootcl                              ##
##                                                          ##
## Live Action :                                            ##
##  /server irc.forumcerdas.net #dReaMer                    ##
##############################################################

set ijootcl_setting(flag) ""
set ijootcl_setting(web) "http://127.0.0.1/download/"
set ijootcl_setting(path) "/usr/share/nginx/html/download/"
set ijootcl_setting(auto_del) "1"
set ijootcl_setting(time) "15"
set ijootcl_setting(cmd_mp3) "@mp3"
set ijootcl_setting(delete) [exec pwd]/chk_del

bind pub $ijootcl_setting(flag) $ijootcl_setting(cmd_mp3) ijootcl_mp3
bind time - "* * * * *" auto_hapus
setudef flag ijootcl
package require json
package require http

if {![file exists $ijootcl_setting(delete)]} {
	putlog "Creating Chk Delete Files"
        append out "#\!/usr/bin/env bash\n"
        append out "\n"
	append out "find \$1 -maxdepth 1 -cmin \+\$2 -name \*.mp3 -exec rm -rf \{\} \\;\n"
        set fd [open "$ijootcl_setting(delete)" w]
        puts $fd $out
        unset out
        close $fd
        exec chmod 755 $ijootcl_setting(delete)
}

proc ijootcl_mp3 {nick uhost handle chan text } {
        global ijootcl_setting data_var
        set hostlink [lrange $text 0 end]
        foreach i [channel info $chan] {
                if {([string match "+ijootcl" $i])} {
                        if {$hostlink == ""} {
				putquick "PRIVMSG $chan :Syntax: \002@mp3\002 <singer> - <sing title> or <Youtube llnk>"
                       	} elseif {[string match "*youtube.com*" $hostlink] || [string match "*youtu.be*" $hostlink]} {
				putquick "PRIVMSG $chan :Prosessing MP3 request by $nick "
				set ijoo_judul [exec youtube-dl $hostlink -e]
				set ijoo_id [exec youtube-dl $hostlink --get-id]
				set ijoo_dur [exec youtube-dl $hostlink --get-duration]
				set linkmp3 [tinyurl "$ijootcl_setting(web)$ijoo_id.mp3"]
                                set ijoo_ytdl [exec youtube-dl $hostlink --extract-audio --audio-format mp3 -o "$ijootcl_setting(path)%(id)s.%(ext)s"]
					foreach line [split $ijoo_ytdl "\r\n"] {
        		                       if {[string match "*eleting original file*" $line]} {
                         	               puthelp "PRIVMSG $chan :\002\037\[\002\037MP3\002\037\]\002\037 $ijoo_judul (\002 $ijoo_dur \002) - \002Download:\002 $linkmp3 "
					       puthelp "PRIVMSG $chan :\002\037\[\002\037MP3\002\037\]\002\037 Files Auto Delete Every\002 $ijootcl_setting(time) Minutes\002 | \002c\002Re\002a\002T\002e\002d \002B\002y i\002J\002oo \037<admin@ijoo.org>\037"
                                	}
				}							
			} else {
				putquick "PRIVMSG $chan :Prosessing MP3 request by $nick "
				set ijoo_data [exec youtube-dl scsearch:"$hostlink" -j]
				set ijoo_info [::json::json2dict $ijoo_data]
				set ijoo_judul [lrange [dict get $ijoo_info title] 0 end]
				set durasi [lindex [lindex $ijoo_info 17] 0]
				set ijoo_link [lrange [dict get $ijoo_info url] 0 end]
				set ijoo_dur [clock format $durasi -gmt 1 -format %H:%M:%S]
				set ijoo_url [tinyurl $ijoo_link]
				puthelp "PRIVMSG $chan :\002\037\[\002\037MP3\002\037\]\002\037 $ijoo_judul (\002 $ijoo_dur \002) - \002Download:\002 $ijoo_url "
				puthelp "PRIVMSG $chan :\002\037\[\002\037MP3\002\037\]\002\037 \002c\002Re\002a\002T\002e\002d \002B\002y i\002J\002oo \037<admin@ijoo.org>\037"
			}
		}
	}
}

proc tinyurl {url} {
	if {[string length $url] <= 26} { return $url; } 
	set tinyurl "http://tinyurl.com/api-create.php";
	set query [::http::formatQuery "url" $url]; 
	set token [::http::geturl "$tinyurl?$query" -timeout 5000]; 
	set url [::http::data $token]; 
	::http::cleanup $token; 
	return $url; 
}

proc auto_hapus { nick uhost hand chan arg } {
	global ijootcl_setting
	if {$ijootcl_setting(auto_del) == "1" } { 
		set del_ok [exec /bin/bash $ijootcl_setting(delete) $ijootcl_setting(path) $ijootcl_setting(time)]
		putlog "File Clearing every $ijootcl_setting(time) minutes"
	}
}

putlog "iJooMP3 tCL By iJoo.oRg is Loaded!!"
