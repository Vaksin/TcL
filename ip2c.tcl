################################################################################################
#
#                                                                       
#    //    ) )                              //   ) )                    
#   //    / /  ___      ___    __  ___ ( ) //___/ / //           ___    
#  //    / / //   ) ) ((   ) )  / /   / / / ____ / // //   / / ((   ) ) 
# //    / / //   / /   \ \     / /   / / //       // //   / /   \ \     
#//____/ / ((___/ / //   ) )  / /   / / //       // ((___( ( //   ) )   
#
#  TCL script realised & modified by #philchat @ DostiPlus.com TEAM
#  www.dostiplus.com - shells, radio, webhosting, domains, CS servers & more !
#  mail to admin@dostiplus.com for more infos & help using this TCL.
#
################################################################################################
##############################
# whoisinfo.tcl v0.1
##############################

##############################
# SETTINGS
##############################
setudef flag ipinfo
# version
set whoisinfo(version) "0.1"

# trigger
set whoisinfo(trigger) ".ip"

# whois port
set whoisinfo(port) 43

# ripe server
set whoisinfo(ripe) "whois.ripe.net"

# arin server
set whoisinfo(arin) "whois.arin.net"

# apnic server
set whoisinfo(apnic) "whois.apnic.net"

# lacnic server
set whoisinfo(lacnic) "whois.lacnic.net"

# afrinic server
set whoisinfo(afrinic) "whois.afrinic.net"

##############################
# BINDS
##############################

bind pub - $whoisinfo(trigger) pub_whoisinfo

##############################
# CODE
##############################

proc whoisinfo_setarray {} {
	global query

	set query(netname) "(none)"
	set query(country) "(none)"
	set query(orgname) "(none)"
	set query(address) "(none)"
	set query(phone) "(none)"
	set query(fax) "(none)"
	set query(person) "(none)"
	set query(email) "(none)"
	set query(orgid) "(none)"
	set query(range) "(none)"
}

proc whoisinfo_display { chan } {
	global query

	putlog "Firstline: $query(firstline)"

	puthelp "PRIVMSG $chan :\[4Range\]: $query(range)"
	puthelp "PRIVMSG $chan :\[4Netname\]: $query(netname)"
	puthelp "PRIVMSG $chan :\[4Organisation\]: $query(orgname)"
	puthelp "PRIVMSG $chan :\[4Address\]: $query(address)"
	puthelp "PRIVMSG $chan :\[4Phone\]: $query(phone)"
	puthelp "PRIVMSG $chan :\[4Fax\]: $query(fax)"
	puthelp "PRIVMSG $chan :\[4Person\]: $query(person)"
	puthelp "PRIVMSG $chan :\[4Email\]: $query(email)"
	puthelp "PRIVMSG $chan :\[4Country\]: $query(country)"
}

proc pub_whoisinfo {nick uhost handle chan search} {
	 if {![channel get $chan ipinfo]} { return 0 }
	global whoisinfo
	global query
	set ::chantarget $chan

	whoisinfo_setarray 

	if {[whoisinfo_whois $whoisinfo(arin) $search]==1} {
		if {[string compare [string toupper $query(orgid)] "RIPE"]==0} {
			if {[whoisinfo_whois $whoisinfo(ripe) $search]==1} {
				whoisinfo_display $chan
			}
		 } elseif {[string compare [string toupper $query(orgid)] "APNIC"]==0} {
			if {[whoisinfo_whois $whoisinfo(apnic) $search]==1} {
				whoisinfo_display $chan
			}
		 } elseif {[string compare [string toupper $query(orgid)] "LACNIC"]==0} {
			if {[whoisinfo_whois $whoisinfo(lacnic) $search]==1} {
				whoisinfo_display $chan
				}
		 } elseif {[string compare [string toupper $query(orgid)] "AFRINIC"]==0} {
			if {[whoisinfo_whois $whoisinfo(afrinic) $search]==1} {
				whoisinfo_display $chan
				}
		 } else {
			whoisinfo_display $chan
		}
	} else {
		if { [info exist query(firstline)] } {
			puthelp "PRIVMSG $chan :\[\002Whois\002\] Firstline: $query(firstline)"
		} else {
			puthelp "PRIVMSG $chan :\[\002Whois\002\] Error?"
		}
	}
}

proc whoisinfo_whois {server search} {
	global whoisinfo
	global query
	global ::chantarget
	set chan $::chantarget
	set desccount 0
	set firstline 0
	set reply 0
		
	putlog "Whois: $server:$whoisinfo(port) -> $search"

	if {[catch {set sock [socket -async $server $whoisinfo(port)]} sockerr]} {
      	puthelp "PRIVMSG $chan :\[\002Whois\002\] Error: $sockerr. Try again later."
      	close $sock
		return 0
    	}
	
	puts $sock $search
	flush $sock

	while {[gets $sock whoisline]>=0} {

		putlog "Whois: $whoisline"

		if {[string index $whoisline 0]!="#" && [string index $whoisline 0]!="%" && $firstline==0} {
			if {[string trim $whoisline]!=""} {
				set query(firstline) [string trim $whoisline]
				set firstline 1
			}
		}

		if {[regexp -nocase {netname:(.*)} $whoisline all item]} {
			set query(netname) [string trim $item]
			set reply 1
		} elseif {[regexp -nocase {owner-c:(.*)} $whoisline all item]} {
			set query(netname) [string trim $item]
			set reply 1 
		} elseif {[regexp -nocase {country:(.*)} $whoisline all item]} {
			set query(country) [string trim $item]
			set reply 1
		} elseif {[regexp -nocase {descr:(.*)} $whoisline all item] && $desccount==0} {
			set query(orgname) [string trim $item]
			set desccount 1
			set reply 1
		} elseif {[regexp -nocase {address:(.*)} $whoisline all item]} {
			set query(address) [string trim $item]
			set reply 1
		} elseif {[regexp -nocase {orgname:(.*)} $whoisline all item]} {
			set query(orgname) [string trim $item]
			set reply 1
		} elseif {[regexp -nocase {phone:(.*)} $whoisline all item]} {
			set query(phone) [string trim $item]
			set reply 1
		} elseif {[regexp -nocase {fax-no:(.*)} $whoisline all item]} {
			set query(fax) [string trim $item]
			set reply 1
		} elseif {[regexp -nocase {person:(.*)} $whoisline all item]} {
			set query(person) [string trim $item]
			set reply 1
		} elseif {[regexp -nocase {e-mail:(.*)} $whoisline all item]} {
			set query(email) [string trim $item]
			set reply 1
		} elseif {[regexp -nocase {owner:(.*)} $whoisline all item]} {
			set query(orgname) [string trim $item]
			set reply 1
		} elseif {[regexp -nocase {orgid:(.*)} $whoisline all item]} {
			set query(orgid) [string trim $item]
			set reply 1
		} elseif {[regexp -nocase {inetnum:(.*)} $whoisline all item]} {
			set query(range) [string trim $item]
			set reply 1
		} elseif {[regexp -nocase {netrange:(.*)} $whoisline all item]} {
			set query(range) [string trim $item]
			set reply 1
		}
	}

	close $sock
	
	return $reply
}

putlog "whoisinfo.tcl v$whoisinfo(version) by Aman Dostiplus Staff loaded."