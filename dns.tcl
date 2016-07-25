##########################################
#
#                                 dns.tcl 
#                              by Vaksin
#                         Created @ 2014
#
# Show the ipv4 and ipv6 result in one command.
#
setudef flag dns
#########################################
bind pub - .dns pub:dns

proc pub:dns {nick uhost hand chan arguments} {
 if {![channel get $chan dns]} { return 0 }
 if {$arguments == ""} { return 0 }
 set cmd "nslookup"
 set orig [lindex $arguments 0]
 dnslookup $orig dns:rep $chan $orig
 if {[string match "*:*.*" $orig]} {
  puthelp "PRIVMSG $chan :Invalid ipv6 "
  return
 } elseif {[string match "*.*:*" $orig]} {
  puthelp "PRIVMSG $chan :Invalid ipv6 "
  return
 }
 catch {exec $cmd -type=any $orig} input
 set result ""
 set fnd 0
 foreach line [split $input "\n"] {
  if {[string match "*ip6.\[int|arpa\]*name*=*" $line] || [string match "*IPv6 address*=*" $line]} {
   set result [string trim [lindex [split $line "="] 1]]
   break
  } elseif {[string match "*has AAAA*" $line]} {
   set result [lindex [split $line] [expr [llength [split $line]] - 1]]
   break
  }
 }
 if {$result == ""} {
  puthelp "privmsg $chan :(04Ipv6): Available"
  return
 }
 puthelp "privmsg $chan :(04Ipv6): 12Resolved with $result "
 return
}

proc dns:rep {ip host status chan orig} {
 if {[string match "*:*:*" $ip]} {
   putquick "privmsg $chan :(04Ipv4): Available"
 } elseif {!$status} {
   putquick "privmsg $chan :(04Ipv4): Available"
 } elseif {[regexp -nocase -- $ip $orig]} {
   putquick "privmsg $chan :(04Ipv4): 12Resolved with $host "
 } else {
   putquick "privmsg $chan :(04Ipv4): 12Resolved with $ip "
 }
}

