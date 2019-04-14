##############################################
#
#			Monic TCL - by Vaksin @ForumCerdas.Net
#							(Indonesian Language)
#
#	*Used by best speaking bot on ForumCerdas and DALnet.	
#
#	Type "ngoceh mon" to activate speaking (without " sign)
#	and "mingkem mon" for deactivate.
##############################################
setudef flag talk

bind pubm - "* monic mana *" carimonic
bind pubm - "* monic mana" carimonic
bind pubm - "* monic kemana *" carimonic
bind pubm - "* monic kemana" carimonic
set rancmonic {
	"Iyaaa, ada apaa... %nick, tadi monic di suruh mingkem sih sama %mnick"
	"\001ACTION ada di sini, cuma tadi %mnick suruh monic mingkem\001"
}
set ranmonicmn {
	"aku di siniiiiiii..."
	"\001ACTION hadiiirrrrrrrr...\001"
}

proc carimonic {nick uhost hand chan text} {
	global botnick rancmonic ranmonicmn
	if {[channel get $chan talk]} {
		set ranmonmns [lindex $ranmonicmn [rand [llength $ranmonicmn]]]
		regsub -all "%nick" $ranmonmns $nick ranmonmns
		puthelp "PRIVMSG $chan :$ranmonmns"
		return 0
	}
	set n [open "anick.txt" r]]
	set mnick [gets $n]
	close $n
	channel set $chan +talk
	
	set ranidups [lindex $rancmonic [rand [llength $rancmonic]]]
	regsub -all "%nick" $ranidups $nick ranidups
	regsub -all "%mnick" $ranidups $mnick ranidups
	puthelp "PRIVMSG $chan :$ranidups"
}

bind msg - "off" msg_silent
bind msg - "on" msg_talk
bind pubm - "* ngoceh *" monic_talk
bind pubm - "* mingkem *" monic_silent
set ranngoceh {
	"asiiikkkkk... boleh ngomong"
	"makacih... %nick baik deh :)"
}
set ranmingkem {
	"\001ACTION di suruh diem sama %nick :( \001"
	"%nick tega ih :("
}

proc monic_talk {nick uhost hand chan text} {
	global botnick ranngoceh
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {![matchattr $nick n]} {
			puthelp "PRIVMSG $chan :$nick siapa sih sok perintah² monic"
			return 0
		}
		if {[channel get $chan talk]} {
			puthelp "PRIVMSG $chan :\001ACTION emang udah boleh ngomong kok $nick :) \001"
			return 0
		}
		channel set $chan +talk
		set ranngocehs [lindex $ranngoceh [rand [llength $ranngoceh]]]
		regsub -all "%nick" $ranngocehs $nick ranngocehs
		puthelp "PRIVMSG $chan :$ranngocehs"
	}
}

proc monic_silent {nick uhost hand chan text} {
	global botnick ranmingkem
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {![matchattr $nick n]} {
			puthelp "PRIVMSG $chan :Emang $nick siapa suruh² monic mingkem"
			return 0
		}
		if {![channel get $chan talk]} {
			puthelp "PRIVMSG $chan :\001ACTION emang udah di suruh diem kok $nick :( \001"
			return 0
		}
		set nick $nick
		set anick [open "anick.txt" w]
		puts $anick "$nick"
		close $anick
		channel set $chan -talk
		set ranmingkems [lindex $ranmingkem [rand [llength $ranmingkem]]]
		regsub -all "%nick" $ranmingkems $nick ranmingkems
		puthelp "PRIVMSG $chan :$ranmingkems"
	}
}

proc msg_talk {nick uhost hand rest} {
	global botnick
	if {![matchattr $nick n]} { return 0 }
	set text [split $rest]
	if {[lindex $text 0] == ""} {
		putserv "PRIVMSG $nick :Syntax: on <#channel>"
		return
	}
	set tchannel [lindex $text 0]
	if {[channel get $tchannel talk]} {
		puthelp "NOTICE $nick :Already ON"
		return 0
	}
	channel set $tchannel +talk
	putserv "NOTICE $nick :Talk for $tchannel turned ON"
}

proc msg_silent {nick uhost hand rest} {
	if {![matchattr $nick n]} { return 0 }
	set text [split $rest]
	if {[lindex $text 0] == ""} {
		putserv "PRIVMSG $nick :Syntax: off <#channel>"
		return
	}
	set schannel [lindex $text 0]
	if {![channel get $schannel talk]} {
		puthelp "NOTICE $nick :Already OFF"
		return 0
	}
	channel set $schannel -talk
	putserv "NOTICE $nick :Talk for $schannel turned OFF"
}

bind nick - * pub_nick
proc pub_nick { nick uhost hand chan newnick } {
	global botnick
	if {![channel get $chan talk]} { return 0 }
	if {($newnick == $botnick)} { return 0 }
	if {($newnick == "Vaksin")} {
		puthelp "PRIVMSG $chan :wb ayank Vaksin :)"
	}
}
	
bind join - * pub:me
set ranjoinvak {
	"wb ayank Vaksin :)"
	"selamat datang ayank Vaksin :)"
}

proc pub:me { nick uhost hand chan } {
	global botnick ranjoinvak
	if {![channel get $chan talk]} { return 0 }
	if {$nick == "Vaksin"} {
		set joinvaks [lindex $ranjoinvak [rand [llength $ranjoinvak]]]
		puthelp "PRIVMSG $chan :$joinvaks"
	}
}

###################
##  monic  ##
bind pub - mon monic_speak
bind pub - monic monic_speak
bind pub - Mon monic_speak
bind pub - Monic monic_speak

set ranmonic {
	"apa"
	"Hadeh.. %nick cuma manggil² aja.. gak pernah mau traktir monic :("
	"Beh.. monic di panggil sama orang pelit"
	"\001ACTION pura² budek ahh...\001"
	"iya ada apa %nick?"
	"%nick berisik ntar monic ignore nih"
	"hadiiirrrr..."
	"%nick siapa sih.. sok akrab banget"
	"Kenapa manggil² monic... kangen ya."
}
set vrespon {
	"iya ayank Vaksin, knp?"
	"ada apa ayank?"
}

set mon(antiflood) 15

proc monic_speak {nick uhost hand chan text} {
	global botnick ranmonic vrespon mon
	if {![channel get $chan talk]} { return 0 }
	if {[info exists mon(floodprot)]} {
		set diff [expr [clock seconds] - $mon(floodprot)]
		if {$diff < $mon(antiflood)} {
			return 0
		}
		catch { unset diff }
	}
	set mon(floodprot) [clock seconds]
	if {[llength $text] < 1} {
		if {$nick == "Vaksin"} {
			set vrspons [lindex $vrespon [rand [llength $vrespon]]]
			putserv "PRIVMSG $chan :$vrspons"
			return 0
		}
		set monics [lindex $ranmonic [rand [llength $ranmonic]]]
		regsub -all "%nick" $monics $nick monics
		putserv "PRIVMSG $chan :$monics"
	}
}

## belum ##
bind pubm - "belum *" blum_speak
bind pubm - "* belum *" blum_speak
bind pubm - "* belum" blum_speak
bind pubm - "blum *" blum_speak
bind pubm - "* blum *" blum_speak
bind pubm - "* blum" blum_speak
bind pubm - "blom *" blum_speak
bind pubm - "* blom *" blum_speak
bind pubm - "* blom" blum_speak
bind pubm - "belom *" blum_speak
bind pubm - "* belom *" blum_speak
bind pubm - "* belom" blum_speak
bind pubm - "belon *" blum_speak
bind pubm - "* belon *" blum_speak
bind pubm - "* belon" blum_speak
bind pubm - "blon *" blum_speak
bind pubm - "* blon *" blum_speak
bind pubm - "* blon" blum_speak
set ranblum {
	"menurut %nick?"
	"udah dung"
}

proc blum_speak {nick host hand chan text} {
	global ranblum
	if {![channel get $chan talk]} { return 0 }
	if {[string match "*makan*" [string tolower $text]] || [string match "*mandi*" [string tolower $text]] || [string match "*nikah*" [string tolower $text]] || [string match "*ngantuk*" [string tolower $text]] || [string match "udah *" [string tolower $text]] || [string match "* udah *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set blums [lindex $ranblum [rand [llength $ranblum]]]
		regsub -all "%nick" $blums $nick blums
		putserv "PRIVMSG $chan :$blums"
	}
}

## ayank nya vaksin ##
bind pubm - "* ayank nya vaksin *" siapayankvak_speak
bind pubm - "* ayank nya vaksin" siapayankvak_speak
bind pubm - "* vaksin ayank nya *" siapayankvak_speak
set siapayankvak {
	"ya jelas monic lah"
	"monic dong"
}

proc siapayankvak_speak {nick host hand chan text} {
	global siapayankvak
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match -nocase "bot *" [string tolower $text]] || [string match -nocase "* bot *" [string tolower $text]] || [string match -nocase "* bot" [string tolower $text]]} { return 0 }
		if {[string match "siapa *" [string tolower $text]] || [string match "* siapa *" [string tolower $text]]} {
			set siapayankvaks [lindex $siapayankvak [rand [llength $siapayankvak]]]
			regsub -all "%nick" $siapayankvaks $nick siapayankvaks
			putserv "PRIVMSG $chan :$siapayankvaks"
			return 0
		}
		if {[lindex [string tolower $text] 0] != "vaksin"} {
			putserv "PRIVMSG $chan :enak aja"
		}
	}
}

## ngga boleh ##
bind pubm - "* ngga boleh *" ngga_speak
bind pubm - "* ga boleh *" ngga_speak
bind pubm - "* gak boleh *" ngga_speak
set rungga {
	"ya udah"
	"ok"
}

proc ngga_speak {nick uhost hand chan text} {
	global rungga
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon" [string tolower $text]] || [string match "* monic" [string tolower $text]]} {
		if {[string match "mau *" [string tolower $text]] || [string match "* mau *" [string tolower $text]]} { return 0 }
		set nggas [lindex $rungga [rand [llength $rungga]]]
		putserv "PRIVMSG $chan :$nggas"
	}
}

## ayank vaksin ##
bind pubm - "* ayank *" yankvak_speak
bind pubm - "* ayank" yankvak_speak
bind pubm - "* yayank *" yankvak_speak
bind pubm - "* yayank" yankvak_speak
bind pubm - "* ayang *" yankvak_speak
bind pubm - "* ayang" yankvak_speak
bind pubm - "* yayang *" yankvak_speak
bind pubm - "* yayang" yankvak_speak
bind pubm - "* sayang *" yankvak_speak
bind pubm - "* sayang" yankvak_speak
bind pubm - "* sayank *" yankvak_speak
bind pubm - "* sayank" yankvak_speak
bind pubm - "* bebeb *" yankvak_speak
bind pubm - "* bebeb" yankvak_speak
bind pubm - "* beb *" yankvak_speak
bind pubm - "* beb" yankvak_speak
bind pubm - "* beib *" yankvak_speak
bind pubm - "* beib" yankvak_speak
bind pubm - "* ayangku *" yankvak_speak
bind pubm - "* ayangku" yankvak_speak
bind pubm - "* yayangku *" yankvak_speak
bind pubm - "* yayangku" yankvak_speak
bind pubm - "* sayangku *" yankvak_speak
bind pubm - "* sayangku" yankvak_speak
bind pubm - "* bebebku *" yankvak_speak
bind pubm - "* bebebku" yankvak_speak
bind pubm - "* bebku *" yankvak_speak
bind pubm - "* bebku" yankvak_speak
bind pubm - "* beibku *" yankvak_speak
bind pubm - "* beibku" yankvak_speak
bind pubm - "* honey *" yankvak_speak
bind pubm - "* honey" yankvak_speak
set ranyankvak {
	"%nick ga usah sok cakep deh manggil² vaksin ayank"
	"eh %nick, vaksin itu ayank monic tau"
	"\001ACTION brb ngasah golok *lirik %nick*\001"
	"%nick sok PD banget sih"
	" kalo bunuh orang di penjara berapa lama ya %nick?"
	"\001ACTION dah lama ga kebiri orang loh %nick\001"
}

proc yankvak_speak {nick host hand chan text} {
	global ranyankvak
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* nya *" [string tolower $text]] || [string match "* kemana *" [string tolower $text]] || [string match "* mana *" [string tolower $text]]} { return 0 }
	if {[string match -nocase "* monic siapa" [string tolower $text]]} {
		putserv "PRIVMSG $chan :Vaksin"
		return 0
	}
	if {[string match -nocase "*vaksin*" [string tolower $text]]} {
		set yankvaks [lindex $ranyankvak [rand [llength $ranyankvak]]]
		regsub -all "%nick" $yankvaks $nick yankvaks
		putserv "PRIVMSG $chan :$yankvaks"
	}
}

bind pubm - "* bukan *" bkan_speak
bind pubm - "* bukan" bkan_speak
bind pubm - "bukan *" bkan_speak
set ranbkan {
	"bukan"
}
set ranbkan2 {
	"iya bukan"
	"%nick mau tau aja, apa mau tau banget?"
} 
proc bkan_speak {nick uhost hand chan text} {
	global ranbkan ranbkan2
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "*facebook*" [string tolower $text]] || [string match "*fb*" [string tolower $text]] || [string match "*homo*" [string tolower $text]] || [string match "*maho*" [string tolower $text]] || [string match "*lesbi*" [string tolower $text]] || [string match "*bisex*" [string tolower $text]]} { return 0 }
		if {[string match "* org *" [string tolower $text]] || [string match "* orang *" [string tolower $text]] || [string match "* pacar *" [string tolower $text]]} {
			set bkans [lindex $ranbkan [rand [llength $ranbkan]]]
			putserv "PRIVMSG $chan :$bkans"
			return 0
		} else {
			set bkans [lindex $ranbkan2 [rand [llength $ranbkan2]]]
			regsub -all "%nick" $bkans $nick bkans
			putserv "PRIVMSG $chan :$bkans"
		}
	}
}

##  tlpon  ##
bind pubm - "* telpon *" tlpon_speak
bind pubm - "* telfon *" tlpon_speak
bind pubm - "* telepon *" tlpon_speak
bind pubm - "* telefon *" tlpon_speak
bind pubm - "* tlp *" tlpon_speak
bind pubm - "* handp*" tlpon_speak
bind pubm - "* hp *" tlpon_speak
bind pubm - "* hp" tlpon_speak
set rantlpon {
	"ah %nick paling cuma misscall doang"
	"%nick mau beliin monic pulsa ya"
}

proc tlpon_speak {nick uhost hand chan text} {
	global botnick tlpon_chans rantlpon
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set tlpons [lindex $rantlpon [rand [llength $rantlpon]]]
		regsub -all "%nick" $tlpons $nick tlpons
		putserv "PRIVMSG $chan :$tlpons"
	}
}

##  bbm  ##
bind pubm - "* bbm *" bbm_speak
bind pubm - "* bbm" bbm_speak
set ranbbm {
	"punya %nick aja sini, ntar monic invite"
	"udah ga jaman"
}

proc bbm_speak {nick uhost hand chan text} {
	global botnick bbm_chans ranbbm
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set bbms [lindex $ranbbm [rand [llength $ranbbm]]]
		regsub -all "%nick" $bbms $nick bbms
		putserv "PRIVMSG $chan :$bbms"
    }
}

##  fb  ##
bind pubm - "* fb *" fb_speak
bind pubm - "* facebook *" fb_speak
set ranfb {
	"ga punya"
	"emang kenapa?"
	"punya %nick aja sini, ntar monic add"
}

proc fb_speak {nick uhost hand chan text} {
	global botnick ranfb
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "*info*" [string tolower $text]] || [string match "*bukan*" [string tolower $text]]} { return 0 }
		set fbs [lindex $ranfb [rand [llength $ranfb]]]
		regsub -all "%nick" $fbs $nick fbs
		putserv "PRIVMSG $chan :$fbs"
	}
}

##  silikon  ##
bind pubm - "* silikon *" slkon_speak
bind pubm - "* silicon *" slkon_speak
bind pubm - "* palsu *" slkon_speak
set ranslkon {
	"ih sori ya, asli dong"
	"asli taauuu..."
}

proc slkon_speak {nick uhost hand chan text} {
	global botnick ranslkon
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set slkons [lindex $ranslkon [rand [llength $ranslkon]]]
		putserv "PRIVMSG $chan :$slkons"
		putserv "PRIVMSG $chan :emangnya punya $nick suntikan"
	}
}

##  owner  ##
bind pubm - "owner *" owner_speak
bind pubm - "* owner *" owner_speak
set ranowner {
	"\001ACTION punya ayank Vaksin\001"
	"\001ACTION tunjuk² Vaksin\001"
}

proc owner_speak {nick uhost hand chan text} {
	global botnick ranowner
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]] && ![string match "* mana *" [string tolower $text]]} {
		set owners [lindex $ranowner [rand [llength $ranowner]]]
		putserv "PRIVMSG $chan :$owners"
	}
}

bind pubm - "* pnya *" prmah_speak
bind pubm - "* punya *" prmah_speak
bind pubm - "punya *" prmah_speak
set ranprmah {
	"punya dong, emang nya %nick gelandangan"
	"\001ACTION kan serumah sama ayank Vaksin\001"
}
set ranmilik {
	"\001ACTION punya ayank Vaksin\001"
	"\001ACTION tunjuk² Vaksin\001"
}
proc prmah_speak {nick uhost hand chan text} {
	global botnick ranprmah ranmilik
	if {![channel get $chan talk]} { return 0 }
	if {[string match "gw *" [string tolower $text]] || [string match "* gw *" [string tolower $text]] || [string match "gua *" [string tolower $text]] || [string match "* gua *" [string tolower $text]] || [string match "gue *" [string tolower $text]] || [string match "* gue *" [string tolower $text]] || [string match "* fb *" [string tolower $text]] || [string match "* facebook *" [string tolower $text]]} { return 0 }
	if {![string match "* ga *" [string tolower $text]] || [string match "* gak *" [string tolower $text]]} { return 0 }
	if {[string match "liat *" [string tolower $text]] || [string match "* liat *" [string tolower $text]] || [string match "lihat *" [string tolower $text]] || [string match "* lihat *" [string tolower $text]] || [string match "nenen *" [string tolower $text]] || [string match "* nenen *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "*rumah*" [string tolower $text]]} {
			set prmahs [lindex $ranprmah [rand [llength $ranprmah]]]
			regsub -all "%nick" $prmahs $nick prmahs
			putserv "PRIVMSG $chan :$prmahs"
		}
		if {[string match "*siapa*" [string tolower $text]]} {
			set miliks [lindex $ranmilik [rand [llength $ranmilik]]]
			regsub -all "%nick" $miliks $nick miliks
			putserv "PRIVMSG $chan :$miliks"
		} else {
			putserv "PRIVMSG $chan :ga punya"
		}
	}
}

## baru tau ##
bind pubm - "baru tau *" brtau_speak
bind pubm - "* baru tau *" brtau_speak
set ranbrtau {
	"hu'uh"
}

proc brtau_speak {nick uhost hand chan text} {
	global botnick ranbrtau
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set brtaus [lindex $ranbrtau [rand [llength $ranbrtau]]]
		regsub -all "%nick" $brtaus $nick brtaus
		putserv "PRIVMSG $chan :$brtaus"
		putserv "PRIVMSG $chan :ga ada yg kasih tau $botnick sih"
	}
}

##  pacaran  ##
bind pubm - "pacaran *" pcaran_speak
bind pubm - "kencan *" pcaran_speak
bind pubm - "* pacaran *" pcaran_speak
bind pubm - "* kencan *" pcaran_speak
set ranpcaran {
	"ga mau ah, %nick kere"
}

proc pcaran_speak {nick uhost hand chan text} {
	global botnick ranpcaran
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "* yuk *" [string tolower $text]] || [string match "* yok *" [string tolower $text]]} {
			set pcarans [lindex $ranpcaran [rand [llength $ranpcaran]]]
			regsub -all "%nick" $pcarans $nick pcarans
			putserv "PRIVMSG $chan :$pcarans"
		}
	}
}

##  pacar  ##
bind pubm - "pacar *" pcar_speak
bind pubm - "* pacar *" pcar_speak
bind pubm - "* pacarnya *" pcar_speak
set ranpcar {
	"%nick ngapain sih nanya²"
	"pokok nya pacar monic guanteng"
	"kasih tau ga yaaa..."
	"ada dehh... yang pasti bukan %nick"
	"\001ACTION jomblo\001"
	"%nick mau nembak monic ya"
	"pacar monic sekarang Vaksin"
}
set ranpcarorg {
	"dia mah jomblo sejati tau"
	"emang ada yang mau sama dia?"
	"orang jelek mana laku"
}

proc pcar_speak {nick uhost hand chan text} {
	global botnick ranpcar ranpcarorg
	if {![channel get $chan talk]} { return 0 }
	if {[string match -nocase "ayank vaksin *" [string tolower $text]] || [string match -nocase "* ayank vaksin *" [string tolower $text]] || [string match -nocase "* ayank vaksin" [string tolower $text]] || [string match "* bukan *" [string tolower $text]] || [string match "mau *" [string tolower $text]] || [string match "* mau *" [string tolower $text]] || [string match "ada *" [string tolower $text]] || [string match "* ada *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match -nocase "pacar *" [string tolower [lindex $text 0]]] && [lindex $text 2] == "siapa"} {
			set pcars [lindex $ranpcar [rand [llength $ranpcar]]]
			regsub -all "%nick" $pcars $nick pcars
			putserv "PRIVMSG $chan :$pcars"
			return 0
		}
		if {[string match "* aku *" [string tolower $text]] || [string match "aku *" [string tolower $text]]} {
			if {($nick == "Vaksin")} {
				putserv "PRIVMSG $chan :ya monic lah"
				return 0
			}
		}
		if {[string match -nocase "* pacar monic *" [string tolower $text]] || [string match -nocase "* pacar nya monic *" [string tolower $text]] || [string match -nocase "pacar monic *" [string tolower $text]] || [string match -nocase "pacar nya monic *" [string tolower $text]]} {
			set pcars [lindex $ranpcar [rand [llength $ranpcar]]]
			regsub -all "%nick" $pcars $nick pcars
			putserv "PRIVMSG $chan :$pcars"
			return 0
		}
		if {[string match "*punya*" [string tolower $text]] || [string match "*kamu*" [string tolower $text]] || [string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]] || [string match "elu *" [string tolower $text]] || [string match "* elu *" [string tolower $text]] || [string match "* elu" [string tolower $text]] || [string match "* mu *" [string tolower $text]] } {
			set pcars [lindex $ranpcar [rand [llength $ranpcar]]]
			regsub -all "%nick" $pcars $nick pcars
			putserv "PRIVMSG $chan :$pcars"
			return 0
		} else {
			set pcarsorg [lindex $ranpcarorg [rand [llength $ranpcarorg]]]
			regsub -all "%nick" $pcarsorg $nick pcarsorg
			putserv "PRIVMSG $chan :$pcarsorg"
		}
	}
}

##  pelitt  ##
bind pubm - "pelit *" pelitt_speak
bind pubm - "* pelit *" pelitt_speak
bind pubm - "* pelit" pelitt_speak
set ranpelitt {
  "kalo ga pelit ga kaya² tau"
  "emang %nick ngga?"
}

proc pelitt_speak {nick uhost hand chan text} {
	global botnick ranpelitt
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* tau *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set pelitts [lindex $ranpelitt [rand [llength $ranpelitt]]]
		regsub -all "%nick" $pelitts $nick pelitts
		putserv "PRIVMSG $chan :$pelitts"
	}
}

## ayank ##
bind ctcp - "ACTION" ayank_speak
set ranyank {
	"%nick ga usah sok cakep deh manggil² vaksin ayank"
	"eh %nick, vaksin itu ayank monic tau"
	"\001ACTION brb ngasah golok *lirik %nick*\001"
	"%nick sok PD banget sih"
	" kalo bunuh orang di penjara berapa lama ya %nick?"
	"\001ACTION dah lama ga kebiri orang loh %nick\001"
}

proc ayank_speak {nick uhost hand chan keyword arg} {
	global botnick ranyank
	if {![channel get $chan talk]} { return 0 }
	if {([string match -nocase "*vaksin*" [string tolower $arg]] && [string match "* ayank *" [string tolower $arg]]) || ([string match -nocase "*vaksin*" [string tolower $arg]] && [string match "* sayank *" [string tolower $arg]]) || ([string match -nocase "*vaksin*" [string tolower $arg]] && [string match "* beib *" [string tolower $arg]])} {
		set ranyanks [lindex $ranyank [rand [llength $ranyank]]]
		regsub -all "%nick" $ranyanks $nick ranyanks
		putserv "PRIVMSG $chan :$ranyanks"
	}
}

##  slp  ##
bind ctcp - "ACTION" slp_speak
set ranslp {
	"%nick mau cari gara² sama monic ya?"
	"%nick ntar monic bales timpuk pake ingus nih"
}

proc slp_speak {nick uhost hand chan keyword arg} {
	global botnick ranslp
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $arg]] || [string match "* mon" [string tolower $arg]] || [string match "* monic *" [string tolower $arg]] || [string match "* monic" [string tolower $arg]] || [string match "mon *" [string tolower $arg]] || [string match "monic *" [string tolower $arg]]} {
		if {[string tolower [lindex $arg 0]] == "slaps"} {
			set slps [lindex $ranslp [rand [llength $ranslp]]]
			regsub -all "%nick" $slps $nick slps
			putserv "PRIVMSG $chan :$slps"
		}
	}
}

##  atoel  ##
bind ctcp - "ACTION" atoel_speak
set ranatoel {
	"\001ACTION toel² %nick pake golok\001"
	"%nick ga usah genit deh"
}

proc atoel_speak {nick uhost hand chan keyword arg} {
	global botnick ranatoel
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $arg]] || [string match "* mon" [string tolower $arg]] || [string match "* monic *" [string tolower $arg]] || [string match "* monic" [string tolower $arg]] || [string match "mon *" [string tolower $arg]] || [string match "monic *" [string tolower $arg]]} {
		if {[string tolower [lindex $arg 0]] == "toel" || [string tolower [lindex $arg 0]] == "toel2" || [string tolower [lindex $arg 0]] == "toel²"} {
			set atoels [lindex $ranatoel [rand [llength $ranatoel]]]
			regsub -all "%nick" $atoels $nick atoels
			putserv "PRIVMSG $chan :$atoels"
		}
	}
}

##  aback  ##
bind ctcp - "ACTION" aback_speak
set ranaback {
	"wasit"
	"kiper"
	"hakim garis"
	"striker"
}

proc aback_speak {nick uhost hand chan keyword arg} {
	global botnick ranaback
	if {![channel get $chan talk]} { return 0 }
	if {([string tolower [lindex $arg 0]] == "back")} {
		set abacks [lindex $ranaback [rand [llength $ranaback]]]
		putserv "PRIVMSG $chan :\001ACTION $abacks\001"
	}
}

##  ajarinsp  ##
bind pubm - "*ajarin*" ajarinsp_speak
set ranajarinsp {
	"tuh ayank Vaksin"
	"\001ACTION belajar sendiri\001"
}

proc ajarinsp_speak {nick uhost hand chan text} {
	global botnick ranajarinsp
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]] && ![string match "* mau *" [string tolower $text]]} {
		set ajarinsps [lindex $ranajarinsp [rand [llength $ranajarinsp]]]
		putserv "PRIVMSG $chan :$ajarinsps"
	}
}

##  alesan  ##
bind pubm - "alasan *" alesan_speak
bind pubm - "alesan *" alesan_speak
bind pubm - "* alasan *" alesan_speak
bind pubm - "* alesan *" alesan_speak
bind pubm - "* alasan" alesan_speak
bind pubm - "* alesan" alesan_speak
set ranalesan {
	"suer deh"
	"bener kok"
}

proc alesan_speak {nick uhost hand chan text} {
	global botnick ranalesan
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set alesans [lindex $ranalesan [rand [llength $ranalesan]]]
		putserv "PRIVMSG $chan :$alesans"
	}
}

##  garagara  ##
bind pubm - "* gara² *" gara_speak
bind pubm - "* gara2 *" gara_speak

set rangara {
	"eh ngapain monic di bawa² sih"
	"%nick ga usah bawa² monic deh"
}

proc gara_speak {nick uhost hand chan text} {
	global botnick rangara
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "* bisa *" [string tolower $text]]} { return 0 }
		set garas [lindex $rangara [rand [llength $rangara]]]
		regsub -all "%nick" $garas $nick garas
		putserv "PRIVMSG $chan :$garas"
	}
}

##  kayak  ##
bind pubm - "kyk *" kyak_speak
bind pubm - "kayak *" kyak_speak
bind pubm - "seperti *" kyak_speak
bind pubm - "* kyk *" kyak_speak
bind pubm - "* kayak *" kyak_speak
bind pubm - "* seperti *" kyak_speak

set rankyak {
	"eh ngapain monic di bawa² sih"
	"%nick ga usah bawa² monic deh"
}

proc kyak_speak {nick uhost hand chan text} {
	global botnick rankyak
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "* monyet *" [string tolower $text]] || [string match "* monyet" [string tolower $text]] || [string match "* monet *" [string tolower $text]] || [string match "* monet" [string tolower $text]]} { return 0 }
		set kyaks [lindex $rankyak [rand [llength $rankyak]]]
		regsub -all "%nick" $kyaks $nick kyaks
		putserv "PRIVMSG $chan :$kyaks"
	}
}

##  malas  ##
bind pubm - "males *" malas_speak
bind pubm - "malas *" malas_speak
bind pubm - "* males *" malas_speak
bind pubm - "* malas *" malas_speak
bind pubm - "* males" malas_speak
bind pubm - "* malas" malas_speak
set ranmalas {
	"ngga baik tau jadi orang malas"
	"kata mama monic ga boleh males"
}

proc malas_speak {nick uhost hand chan text} {
	global botnick malas_chans ranmalas
	if {![channel get $chan talk]} { return 0 }
	if {[string match "*kenapa*" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set malass [lindex $ranmalas [rand [llength $ranmalas]]]
		putserv "PRIVMSG $chan :$malass"
	}
}

##  bra  ##
bind pubm - "bh *" bra_speak
bind pubm - "bra *" bra_speak
bind pubm - "* bh *" bra_speak
bind pubm - "* bra *" bra_speak

set ranbra {
	"36B"
	"ukur aja sendiri"
	"punya dia rata"
	"BrB, monic ambil meteran dulu ya"
}
set ranubra {
	"49B"
	"sini %nick ukur sendiri aja"
}
proc bra_speak {nick uhost hand chan text} {
	global botnick ranbra ranubra
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "mon *" [string tolower $text]]} {
		if {[string match "beli *" [string tolower $text]] || [string match "* beli *" [string tolower $text]] || [string match "tau *" [string tolower $text]] || [string match "* tau *" [string tolower $text]]} { return 0 }
		if {[string match "* elu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]]} {
			set ubras [lindex $ranubra [rand [llength $ranubra]]]
			regsub -all "%nick" $ubras $nick ubras
			putserv "PRIVMSG $chan :$ubras"
			return 0
		}
		if {(![string match "*monic*" [string tolower $text]]) || (![string match -nocase "*vaksin*" [string tolower $text]]) || (![string match "tau *" [string tolower $text]]) || (![string match "* tau *" [string tolower $text]])} {
			set bras [lindex $ranbra [rand [llength $ranbra]]]
			putserv "PRIVMSG $chan :$bras"
		}
	}
}

##  brung  ##
bind pubm - "* ukuran burung *" brung_speak
bind pubm - "ukuran burung *" brung_speak
bind pubm - "anu *" brung_speak
bind pubm - "* anu *" brung_speak

set ranbrung {
	"cuma 1 cm"
	"ukur aja sendiri"
	"punya dia kecil"
	"BrB, monic ambil meteran dulu ya"
}

proc brung_speak {nick uhost hand chan text} {
	global botnick ranbrung
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "mon *" [string tolower $text]]} {
		if {[string match "* elu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "* liat *" [string tolower $text]] || [string match "* lihat *" [string tolower $text]] || [string match "liat *" [string tolower $text]] || [string match "lihat *" [string tolower $text]] || [string match "tau *" [string tolower $text]] || [string match "* tau *" [string tolower $text]]} { return 0 }
		if {[string match "* berapa *" [string tolower $text]] || [string match "* brp *" [string tolower $text]]} {
			if {![string match "*monic*" [string tolower $text]] || ![string match "* anu" [string tolower $text]] || ![string match -nocase "*vaksin*" [string tolower $text]]} {
				set brungs [lindex $ranbrung [rand [llength $ranbrung]]]
				putserv "PRIVMSG $chan :$brungs"
			}
		}
	}
}

## bauu ##
bind pubm - "bau *" bauu_speak
bind pubm - "* bau *" bauu_speak
bind pubm - "* bau" bauu_speak
set runbauu {
	"%nick tuh yg bau kambing"
	"%nick cium diri sendiri kaleee...."
	"\001ACTION wangi tauu!!\001"
}

proc bauu_speak {nick uhost hand chan text} {
	global botnick runbauu
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set bauus [lindex $runbauu [rand [llength $runbauu]]]
		regsub -all "%nick" $bauus $nick bauus
		putserv "PRIVMSG $chan :$bauus"
	}
}

##  pernah  ##
bind pubm - "pernah *" pernah_speak
bind pubm - "* pernah *" pernah_speak
set ranpernah {
  "pernah dong.."
  "udah pernah"
  "%nick mau tau aja"
  "sering malah"
}

proc pernah_speak {nick uhost hand chan text} {
	global botnick ranpernah
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "* sekolah *" [string tolower $text]] || [string match -nocase "gw *" [string tolower $text]] || [string match -nocase "gua *" [string tolower $text]] || [string match -nocase "gue *" [string tolower $text]]} { return 0 }
		set pernahs [lindex $ranpernah [rand [llength $ranpernah]]]
		regsub -all "%nick" $pernahs $nick pernahs
		putserv "PRIVMSG $chan :$pernahs"
	}
}

## hajarchan ##
bind pubm - "* hajar *" hajarchan_speak
bind pubm - "* hajar" hajarchan_speak
set ranhajarchan {
	"%nick ga usah jadi provokator ya"
	"\001ACTION cinta damai tau\001"
}
set rangwhajar {
	"%nick berani nya sama cewek huh.."
}

proc hajarchan_speak {nick uhost hand chan text} {
	global botnick ranhajarchan rangwhajar
	if {![channel get $chan talk]} { return 0 }
	if {[matchattr $nick Z] && [botisop $chan]} { return 0 }
	if {[string match "mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]]} {
		if {[string match "mau *" [string tolower $text]] || [string match "* mau *" [string tolower $text]]} { return 0 }
		if {[string match "gw *" [string tolower $text]] || [string match "gua *" [string tolower $text]] || [string match "gue *" [string tolower $text]]} {
			set gwhajarchans [lindex $rangwhajar [rand [llength $rangwhajar]]]
			regsub -all "%nick" $gwhajarchans $nick gwhajarchans
			putserv "PRIVMSG $chan :$gwhajarchans"
			return 0
		}
		set hajarchans [lindex $ranhajarchan [rand [llength $ranhajarchan]]]
		regsub -all "%nick" $hajarchans $nick hajarchans
		putserv "PRIVMSG $chan :$hajarchans"
	}
}

##  dudull  ##
bind pubm - "* dudul *" dudull_speak
bind pubm - "* dudut *" dudull_speak
bind pubm - "* dodol *" dudull_speak
bind pubm - "* dudul" dudull_speak
bind pubm - "* dudut" dudull_speak
bind pubm - "* dodol" dudull_speak
set randudull {
	"enak aja"
	"\001ACTION cuek.com\001"
}

proc dudull_speak {nick uhost hand chan text} {
	global botnick randudull
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match -nocase "bot *" [string tolower $text]] || [string match -nocase "* bot *" [string tolower $text]] || [string match -nocase "* bot" [string tolower $text]]} { return 0 }
		set dudulls [lindex $randudull [rand [llength $randudull]]]
		putserv "PRIVMSG $chan :$dudulls"
	}
}

## kobel ##
bind pubm - "*ngobel*" kobel_speak
bind pubm - "*ngobok*" kobel_speak

proc kobel_speak {nick uhost hand chan text} {
	global botnick
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "*kobel*" [string tolower $text]] || [string match "*ngobel*" [string tolower $text]]} {
			putserv "PRIVMSG $chan :$nick kobel pantat kucing aja sana"
			return 0
		}
		if {[string match "*ngobok*" [string tolower $text]]} {
			putserv "PRIVMSG $chan :$nick ngobok pantat kucing aja sana"
			return 0
		}
	}
}

## galak ##
bind pubm - "* galak *" galak_speak
bind pubm - "* galak" galak_speak
set rangalak {
	"ga kok"
	"ah itu cuma perasaan %nick aja"
}

proc galak_speak {nick uhost hand chan text} {
	global botnick rangalak
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set galaks [lindex $rangalak [rand [llength $rangalak]]]
		regsub -all "%nick" $galaks $nick galaks
		putserv "PRIVMSG $chan :$galaks"
	}
}

##  mati  ##
bind pubm - "* mati *" mati_speak
bind pubm - "* mati" mati_speak
set ranmati {
	"kenapa ga %nick aja duluan"
}
set ranudahmati {
	"hu'uh"
	"iya"
}

proc mati_speak {nick uhost hand chan text} {
	global botnick ranmati ranudahmati
	if {![channel get $chan talk]} { return 0 }
	if {[string match -nocase "masa *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]] || [string match "elu *" [string tolower $text]] || [string match "* elu *" [string tolower $text]] || [string match "* elu" [string tolower $text]] || [string match "lo *" [string tolower $text]] || [string match "* lo *" [string tolower $text]] || [string match "* lo" [string tolower $text]] || [string match "kamu *" [string tolower $text]] || [string match "* kamu *" [string tolower $text]] || [string match "* kamu" [string tolower $text]] || [string match "kmu *" [string tolower $text]] || [string match "* kmu *" [string tolower $text]] || [string match "* kmu" [string tolower $text]]} {
			set matis [lindex $ranmati [rand [llength $ranmati]]]
			regsub -all "%nick" $matis $nick matis
			putserv "PRIVMSG $chan :$matis"
		}
		if {[string match "* udah *" [string tolower $text]] || [string match "pada *" [string tolower $text]] || [string match "* pada *" [string tolower $text]]} {
			if {[string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]] || [string match "elu *" [string tolower $text]] || [string match "* elu *" [string tolower $text]] || [string match "* elu" [string tolower $text]] || [string match "lo *" [string tolower $text]] || [string match "* lo *" [string tolower $text]] || [string match "* lo" [string tolower $text]] || [string match "kamu *" [string tolower $text]] || [string match "* kamu *" [string tolower $text]] || [string match "* kamu" [string tolower $text]]} { return 0 }
			set udahmatis [lindex $ranudahmati [rand [llength $ranudahmati]]]
			putserv "PRIVMSG $chan :$udahmatis"
		}
	}
}

##  umur  ##
bind pubm - "* umur *" umur_speak

set ranumur {
	"15 thn bln ini"
	"\001ACTION lupa\001"
	"17 thn setengah"
	"mang napa %nick nanyain umur monic"
}

proc umur_speak {nick uhost hand chan text} {
	global botnick ranumur
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set umurs [lindex $ranumur [rand [llength $ranumur]]]
		regsub -all "%nick" $umurs $nick umurs
		putserv "PRIVMSG $chan :$umurs"
	}
}

##  cium  ##
bind ctcp - "ACTION" sun_speak
set ransun {
	"ih, %nick blm gosok gigi"
	"\001ACTION blm gosok gigi lho\001"
	"%nick bau jigong"
}

proc sun_speak {nick uhost hand chan keyword arg} {
	global botnick ransun
	if {![channel get $chan talk]} { return 0 }
	if {[string match "monic *" [string tolower $arg]] || [string match "* monic *" [string tolower $arg]] || [string match "* monic" [string tolower $arg]]} {
		if {[string tolower [lindex $arg 0]] == "cium" || [string tolower [lindex $arg 0]] == "kiss" || [string tolower [lindex $arg 0]] == "sun"} {
			set suns [lindex $ransun [rand [llength $ransun]]]
			regsub -all "%nick" $suns $nick suns
			putserv "PRIVMSG $chan :$suns"
		}
	}
}

## added by DANIEL ##
##  tabok  ##
bind ctcp - "ACTION" tabok_speak
set rantabok {
        "gampar %nick pake sendal jepit"
        "mutilasi %nick"
        "tonjok %nick sampai modar"
        "bacok %nick"
        "sikut %nick sampai pingsan"
        "cekek %nick sampe modar"
        "kentutin %nick sampe muntah-muntah"
}

proc tabok_speak {nick uhost hand chan keyword arg} {
        global botnick rantabok
        if {![channel get $chan talk]} { return 0 }
        if {[string match "monic *" [string tolower $arg]] || [string match "* monic *" [string tolower $arg]] || [string match "* monic" [string tolower $arg]]} {
                if {[string tolower [lindex $arg 0]] == "tabok"} {
                        set taboks [lindex $rantabok [rand [llength $rantabok]]]
                        regsub -all "%nick" $taboks $nick taboks
                        putserv "PRIVMSG $chan :\001ACTION $taboks\001"
                        return 0
                }
        }
}

##  cekek  ##
bind ctcp - "ACTION" cekek_speak
set rancekek {
        "gampar %nick pake sendal jepit"
        "mutilasi %nick"
        "tonjok %nick sampai modar"
        "bacok %nick"
        "sikut %nick sampai pingsan"
        "cekek %nick sampe modar"
        "kentutin %nick sampe muntah-muntah"
        "tendang %nick sampe semaput"
}

proc cekek_speak {nick uhost hand chan keyword arg} {
	global botnick rancekek
	if {![channel get $chan talk]} { return 0 }
	if {[string match "monic *" [string tolower $arg]] || [string match "* monic *" [string tolower $arg]] || [string match "* monic" [string tolower $arg]]} {
		if {[string tolower [lindex $arg 0]] == "cekek"} {
			set cekeks [lindex $rancekek [rand [llength $rancekek]]]
			regsub -all "%nick" $cekeks $nick cekeks
			putserv "PRIVMSG $chan :\001ACTION $cekeks\001"
			return 0
		}
	}
}

##  tendang  ##
bind ctcp - "ACTION" tendang_speak
set rantendang {
        "gampar %nick pake sendal jepit"
        "mutilasi %nick"
        "tonjok %nick sampai modar"
        "bacok %nick"
        "sikut %nick sampai pingsan"
        "cekek %nick sampe modar"
        "kentutin %nick sampe muntah-muntah"
        "tendang %nick sampe semaput"
}

proc tendang_speak {nick uhost hand chan keyword arg} {
        global botnick rantendang
        if {![channel get $chan talk]} { return 0 }
        if {[string match "monic *" [string tolower $arg]] || [string match "* monic *" [string tolower $arg]] || [string match "* monic" [string tolower $arg]]} {
                if {[string tolower [lindex $arg 0]] == "tendang"} {
                        set tendangs [lindex $rantendang [rand [llength $rantendang]]]
                        regsub -all "%nick" $tendangs $nick tendangs
                        putserv "PRIVMSG $chan :\001ACTION $tendangs\001"
                        return 0
                }
        }
}


##  hajar  ##
bind ctcp - "ACTION" hajarr_speak
set ranhajar {
	"gampar %nick pake sendal jepit"
	"tonjok %nick sampai modar"
	"bacok %nick"
	"sikut %nick sampai pingsan"
	"cekek %nick sampe modar"
	"kentutin %nick sampe muntah-muntah"
	"tendang %nick sampe semaput"
	"tendang %nick sampe semaput"
}

proc hajarr_speak {nick uhost hand chan keyword arg} {
	global botnick ranhajar
	if {![channel get $chan talk]} { return 0 }
	if {[string match "monic *" [string tolower $arg]] || [string match "* monic *" [string tolower $arg]] || [string match "* monic" [string tolower $arg]]} {
		if {[string tolower [lindex $arg 0]] == "hajar"} {
			set hajars [lindex $ranhajar [rand [llength $ranhajar]]]
			regsub -all "%nick" $hajars $nick hajars
			putserv "PRIVMSG $chan :\001ACTION $hajars\001"
			return 0
		}
	}
}
###############################

##  tarik  ##
bind pubm - "* tarik *" tarik_speak
set rantarik {
	"\001ACTION pasrah\001"
	"cuek mode ON"
	"\001ACTION mau di bawa ke mana %nick ?\001"
	"emangnya %nick kuat ya, monic tu semok tau"
}

proc tarik_speak {nick uhost hand chan text} {
	global botnick rantarik
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set tariks [lindex $rantarik [rand [llength $rantarik]]]
		regsub -all "%nick" $tariks $nick tariks
		putserv "PRIVMSG $chan :$tariks"
	}
}

##  genit  ##
bind pubm - "* ganjen *" gmon_speak
bind pubm - "* ganjen" gmon_speak
bind pubm - "* genit *" gmon_speak
bind pubm - "* genit" gmon_speak
bind pubm - "* centil *" gmon_speak
bind pubm - "* centil" gmon_speak
set rangmon {
	"xixixiii..."
	"nggak kok"
}

proc gmon_speak {nick uhost hand chan text} {
	global botnick rangmon
	if {![channel get $chan talk]} { return 0 }
	if {([string match "*monic*" [string tolower $text]]) || ([string match "mon *" [string tolower $text]] && [string match "* lu *" [string tolower $text]]) || ([string match "mon *" [string tolower $text]] && [string match "* lu" [string tolower $text]]) || ([string match "* mon *" [string tolower $text]] && [string match "lu *" [string tolower $text]]) || ([string match "* mon *" [string tolower $text]] && [string match "* lu *" [string tolower $text]]) || ([string match "* mon *" [string tolower $text]] && [string match "* lu" [string tolower $text]]) || ([string match "mon *" [string tolower $text]] && [string match "* kamu *" [string tolower $text]]) || ([string match "mon *" [string tolower $text]] && [string match "* kamu *" [string tolower $text]]) || ([string match "mon *" [string tolower $text]] && [string match "* kamu" [string tolower $text]]) || ([string match "kamu *" [string tolower $text]] && [string match "* mon *" [string tolower $text]]) || ([string match "kamu *" [string tolower $text]] && [string match "* mon" [string tolower $text]])} {
		set gmons [lindex $rangmon [rand [llength $rangmon]]]
		putserv "PRIVMSG $chan :$gmons"
	}
}

##  malu  ##
bind pubm - "* malu *" malu_speak
bind pubm - "* malu" malu_speak
set ranmalu {
	"emang nya %nick malu²in"
	"nggak kok"
}

proc malu_speak {nick uhost hand chan text} {
	global botnick ranmalu
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set malus [lindex $ranmalu [rand [llength $ranmalu]]]
		regsub -all "%nick" $malus $nick malus
		putserv "PRIVMSG $chan :$malus"
	}
}

##  gendut  ##
bind pubm - "* gendut *" gndut_speak
bind pubm - "* gemuk *" gndut_speak
bind pubm - "* gendut" gndut_speak
bind pubm - "* gemuk" gndut_speak
set rangndut {
	"%nick sok tau ih"
	"\001ACTION semok tau\001"
}

proc gndut_speak {nick uhost hand chan text} {
	global botnick rangndut
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set gnduts [lindex $rangndut [rand [llength $rangndut]]]
		regsub -all "%nick" $gnduts $nick gnduts
		putserv "PRIVMSG $chan :$gnduts"
	}
}

##  cwok  ##
bind pubm - "* cowok *" cwok_speak
bind pubm - "* cowo *" cwok_speak
set rancwok {
	"cowek"
	"dia mah ga jelas"
}

proc cwok_speak {nick uhost hand chan text} {
	global botnick rancwok
	if {![channel get $chan talk]} { return 0 }
	if {[string match "mon *" [string tolower $text]] || [string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [lindex $text 0] == "monic"} {
		if {[string match "* apa *" [string tolower $text]]} { return 0 }
		if {[string match -nocase "*vaksin*" [string tolower $text]]} { putserv "PRIVMSG $chan :asli cowok" ; return 0 }
		if {[string match "*monic*" [string tolower $text]] || [string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]] || [string match "elu *" [string tolower $text]] || [string match "* elu *" [string tolower $text]] || [string match "* elu" [string tolower $text]] || [string match "kamu *" [string tolower $text]] || [string match "* kamu *" [string tolower $text]]} { putserv "PRIVMSG $chan :asli cewek dung" ; return 0 }
		set cwoks [lindex $rancwok [rand [llength $rancwok]]]
		putserv "PRIVMSG $chan :$cwoks"
	}
}

##  cwek  ##
bind pubm - "* cewek *" cwek_speak
bind pubm - "* cewe *" cwek_speak
bind pubm - "* perempuan *" cwek_speak
set rancwek {
	"cewok"
	"dia mah ga jelas"
}

proc cwek_speak {nick uhost hand chan text} {
	global botnick rancwek
	if {![channel get $chan talk]} { return 0 }
	if {[string match "mon *" [string tolower $text]] || [string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [lindex $text 0] == "monic"} {
		if {[string match "* apa *" [string tolower $text]]} { return 0 }
		if {[string match -nocase "*vaksin*" [string tolower $text]]} { putserv "PRIVMSG $chan :asli cowok" ; return 0 }
		if {[string match "*monic*" [string tolower $text]] || [string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]] || [string match "elu *" [string tolower $text]] || [string match "* elu *" [string tolower $text]] || [string match "* elu" [string tolower $text]] || [string match "kamu *" [string tolower $text]] || [string match "* kamu *" [string tolower $text]]} { putserv "PRIVMSG $chan :asli cewek dung" ; return 0 }
		set cweks [lindex $rancwek [rand [llength $rancwek]]]
		putserv "PRIVMSG $chan :$cweks"
	}
}

##  cwek cwok ##
bind pubm - "* cewek *" cowek_speak
bind pubm - "* cewe *" cowek_speak
set rancowek {
	"status ya masih dipikirkan"
	"ga jelas"
}

proc cowek_speak {nick uhost hand chan text} {
	global botnick rancowek
	if {![channel get $chan talk]} { return 0 }
	if {[string match "mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]]} {
		if {[string match "* apa *" [string tolower $text]]} {
			if {[string match -nocase "*vaksin*" [string tolower $text]]} { putserv "PRIVMSG $chan :asli cowok" ; return 0 }
			if {[string match "*monic*" [string tolower $text]] || [string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]] || [string match "elu *" [string tolower $text]] || [string match "* elu *" [string tolower $text]] || [string match "* elu" [string tolower $text]] || [string match "kamu *" [string tolower $text]] || [string match "* kamu *" [string tolower $text]]} { putserv "PRIVMSG $chan :asli cewek dung" ; return 0 }
			set coweks [lindex $rancowek [rand [llength $rancowek]]]
			putserv "PRIVMSG $chan :$coweks"
		}
	}
}

##  goda  ##
bind pubm - "* godain *" goda_speak
bind pubm - "* gangguin *" goda_speak
set rangoda {
	"ih %nick mulai genit deh"
	"emang situ ok ya mau godain monic ?"
	"%nick ga usah iseng deh"
	"\001ACTION off aahhh...\001"
}

proc goda_speak {nick uhost hand chan text} {
	global botnick rangoda
	if {![channel get $chan talk]} { return 0 }
	if {[string match "siapa *" [string tolower $text]] || [string match "* siapa *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set godas [lindex $rangoda [rand [llength $rangoda]]]
		regsub -all "%nick" $godas $nick godas
		putserv "PRIVMSG $chan :$godas"
	}
}

##  pilih  ##
bind pubm - "* pilih *" pilih_speak
bind pubm - "* milih *" pilih_speak
bind pubm - "pilih *" pilih_speak
bind pubm - "milih *" pilih_speak
set ranpilih1 {
	"%word2 apa %word1 yaaa..."
	"\001ACTION pilih %word1 dong\001"
	"%word1 apa %word2 yaaa..."
	"\001ACTION pilih %word2 dong\001"
}
set ranpilih {
	"aduh monic bingung nih"
	"hmmm..."
}

proc pilih_speak {nick uhost hand chan text} {
	global botnick ranpilih ranpilih1
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[lindex $text 0] == "pilih" || [lindex $text 0] == "milih"} {
			if {[lindex $text 1] == "mana"} { puthelp "PRIVMSG $chan :hmmm... yang mana ya" ; return 0 }
			set word1 [lindex $text 1]
			set word2 [lindex $text 3]
			set pilih1s [lindex $ranpilih1 [rand [llength $ranpilih1]]]
			regsub -all "%word1" $pilih1s $word1 pilih1s
			regsub -all "%word2" $pilih1s $word2 pilih1s
			putserv "PRIVMSG $chan :$pilih1s"
			return 0
		}
		set pilihs [lindex $ranpilih [rand [llength $ranpilih]]]
		putserv "PRIVMSG $chan :$pilihs"
	}
}

##  dia  ##
bind pubm - "* aja ya *" dia_speak
bind pubm - "* aja ya" dia_speak
bind pubm - "* saja ya *" dia_speak
bind pubm - "* saja ya" dia_speak
set randia {
	"\001ACTION mending jadi perawan tua\001"
	"moh, %word1 jelek"
	"\001ACTION mendingan jomblo daripada sama %word1\001"
	"ogah ah, %word1 muka mesum"
}
set randiavak {
	"\001ACTION mau banget\001"
	"iya boleh"
	"kalau sama Vaksin monic mau"
}

proc dia_speak {nick uhost hand chan text} {
	global botnick randia randiavak
	if {![channel get $chan talk]} { return 0 }
	if {[string match "mon *" [string tolower $text]] || [string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "*jujur*" [string tolower $text]]} { return 0 }
		if {[string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match " lu*" [string tolower $text]] || [string match "kamu *" [string tolower $text]] || [string match "* kamu *" [string tolower $text]] || [string match " kamu*" [string tolower $text]] || [lindex $text 0] == "monic"} {
			if {[string match -nocase "*vaksin*" [string tolower $text]]} {
				set diavaks [lindex $randiavak [rand [llength $randiavak]]]
				putserv "PRIVMSG $chan :$diavaks"
				return 0
			}
			if {[lindex $text 0] == "sama" || [lindex $text 0] == "Sama"} {
				set word1 [lindex $text 1]
				set dias1 [lindex $randia [rand [llength $randia]]]
				regsub -all "%word1" $dias1 $word1 dias1
				putserv "PRIVMSG $chan :$dias1"
				return 0
			}
			if {[lindex $text 1] == "sama" || [lindex $text 1] == "Sama"} {
				set word1 [lindex $text 2]
				set dias1 [lindex $randia [rand [llength $randia]]]
				regsub -all "%word1" $dias1 $word1 dias1
				putserv "PRIVMSG $chan :$dias1"
				return 0
			}
			if {[lindex $text 2] == "sama" || [lindex $text 2] == "Sama"} {
				set word1 [lindex $text 3]
				set dias1 [lindex $randia [rand [llength $randia]]]
				regsub -all "%word1" $dias1 $word1 dias1
				putserv "PRIVMSG $chan :$dias1"
				return 0
			}
		}
	}
}

##  apa  ##
bind pubm - "* apa *" speak_apa
set ranapa {
	"duh monic binun tauu..."
	"%apa2"
	"hmmm... yg mana ya"
	"%apa1 aja deh"
}

proc speak_apa {nick uhost hand chan text} {
	global ranapa
	if {![channel get $chan talk]} { return 0 }
	if {[string match "*maho*" [string tolower $text]] || [string match "*homo*" [string tolower $text]] || [string match "*lesbi*" [string tolower $text]]} { return 0 }
	if {[string match -nocase "* lagi *" [string tolower $text]] || [string match -nocase "* lgi *" [string tolower $text]] || [string match -nocase "lagi *" [string tolower $text]] || [string match -nocase "lgi *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {([lindex $text 0] == "monic" && [lindex $text 1] == "apa") || ([lindex $text 0] == "Monic" && [lindex $text 1] == "apa") || ([lindex $text 0] == "mon" && [lindex $text 1] == "apa") || [string match "hari *" [string tolower $text]] || [string match "* hari *" [string tolower $text]] || [string match "* udah *" [string tolower $text]] || [string match "* belum *" [string tolower $text]] || [string match "*pilih*" [string tolower $text]] || [string match "*makan*" [string tolower $text]] || [string match "*kabar*" [string tolower $text]] || [string match "*masak*" [string tolower $text]]} { return 0 }
		if {[lindex $text 1] == "apa"} {
			set apa1 [lindex $text 0]
			set apa2 [lindex $text 2]
			set apas [lindex $ranapa [rand [llength $ranapa]]]
			regsub -all "%apa1" $apas $apa1 apas
			regsub -all "%apa2" $apas $apa2 apas
			putserv "PRIVMSG $chan :$apas"
		}
	}
}

##  dgoda  ##
bind pubm - "digodain *" dgoda_speak
bind pubm - "* digodain *" dgoda_speak
set randgoda {
	"begini lah resiko klo cantik"
	"maklum monic kan artis ForDas xixixi..."
}

proc dgoda_speak {nick uhost hand chan text} {
	global botnick randgoda
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set dgodas [lindex $randgoda [rand [llength $randgoda]]]
		putserv "PRIVMSG $chan :$dgodas"
	}
}

##  dgangguin  ##
bind pubm - "digangguin *" dganggu_speak
bind pubm - "* digangguin *" dganggu_speak

proc dganggu_speak {nick uhost hand chan text} {
	global botnick randganggu
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		putserv "PRIVMSG $chan :tau nih pada ja'at sama monic :("
	}
}

##  nikah  ##
bind pubm - "* nikah *" nikah_speak
bind pubm - "* kawin *" nikah_speak
bind pubm - "* merried *" nikah_speak
set rannikah {
	"\001ACTION lagi nunggu di lamar ayank Vaksin tau\001"
	"kalo mas kawin nya permata sama berlian monic mau deh" 
	"emang %nick belum laku ya?" 
	"%nick nikah aja sama kebo" 
	"\001ACTION udah ada yang lamar\001"
}

proc nikah_speak {nick uhost hand chan text} {
	global botnick rannikah
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set nikahs [lindex $rannikah [rand [llength $rannikah]]]
		regsub -all "%nick" $nikahs $nick nikahs
		putserv "PRIVMSG $chan :$nikahs"
	}
}

##  bott  ##
bind pubm - "bot *" bott_speak
bind pubm - "* bot *" bott_speak
bind pubm - "* bot" bott_speak
set ranbott {
	"enak aja monic dibilang bot"
	"\001ACTION user tau..\001"
	"\001ACTION cewe asli dong\001"
}

proc bott_speak {nick uhost hand chan text} {
	global bottnick ranbott
	if {![channel get $chan talk]} { return 0 }
	if {[string match "siapa *" [string tolower $text]] || [string match "* siapa *" [string tolower $text]] || [string match "*cewe*" [string tolower $text]] || [string match "*cowo*" [string tolower $text]] || [string match "* apa *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "* kemana *" [string tolower $text]]} { return 0 }
		set botts [lindex $ranbott [rand [llength $ranbott]]]
		putserv "PRIVMSG $chan :$botts"
	}
}

##  cmburu  ##
bind pubm - "* cemburu *" cmburu_speak
bind pubm - "* cemburu" cmburu_speak
set rancmburu {
	"ngapain juga monic cemburu sama orang jelek"
	"ga la yaauuu..."
	"orang jelek kok dicemburuin -_-"
}

proc cmburu_speak {nick uhost hand chan text} {
	global botnick rancmburu
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set cmburus [lindex $rancmburu [rand [llength $rancmburu]]]
		putserv "PRIVMSG $chan :$cmburus"
	}
}

##  tuli  ##
bind pubm - "* tuli *" tuli_speak
bind pubm - "* tuli" tuli_speak
set rantuli {
	"%nick budek"
}

proc tuli_speak {nick uhost hand chan text} {
	global botnick rantuli
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set tulis [lindex $rantuli [rand [llength $rantuli]]]
		regsub -all "%nick" $tulis $nick tulis
		putserv "PRIVMSG $chan :$tulis"
	}
}

##  bdek  ##
bind pubm - "* budek *" bdek_speak
bind pubm - "* budek" bdek_speak
set ranbdek {
	"%nick tuli"
}

proc bdek_speak {nick uhost hand chan text} {
	global botnick ranbdek
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set bdeks [lindex $ranbdek [rand [llength $ranbdek]]]
		regsub -all "%nick" $bdeks $nick bdeks
		putserv "PRIVMSG $chan :$bdeks"
	}
}

##  pnter  ##
bind pubm - "pinter *" pnter_speak
bind pubm - "* pinter *" pnter_speak
bind pubm - "* pinter" pnter_speak
bind pubm - "pintar *" pnter_speak
bind pubm - "* pintar *" pnter_speak
bind pubm - "* pintar" pnter_speak
set ranpnter {
	"\001ACTION emang pinter tau..\001"
	"%nick baru tau ya?"
	"iya dong monic kan anak sekolahan tau!!"
	"\001ACTION kan gebetannya master2, wajarlah kalo monic pinter :3\001"
}
set ranusrpinter {
	"dia mah o'on"
	"paling bego se IRC"
}
set runvakpinter {
	"pinter dong"
	"dia mah pinter"
}

proc pnter_speak {nick uhost hand chan text} {
	global botnick ranpnter ranusrpinter runvakpinter
	if {![channel get $chan talk]} { return 0 }
	if {[string match -nocase "*monic*" [string tolower $text]] || [string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "mon *" [string tolower $text]]} {
		if {[lindex $text 0] == "$botnick" || [lindex $text 0] == "Monic" || [string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]] || [string match "lo *" [string tolower $text]] || [string match "* lo *" [string tolower $text]] || [string match " lo*" [string tolower $text]] || [string match "elo *" [string tolower $text]] || [string match "* elo *" [string tolower $text]] || [string match "* elo*" [string tolower $text]] || [string match "elu *" [string tolower $text]] || [string match "* elu *" [string tolower $text]] || [string match "* elu" [string tolower $text]] || [string match "kamu *" [string tolower $text]] || [string match "* kamu *" [string tolower $text]] || [string match "* kamu" [string tolower $text]]} {
			set pnters [lindex $ranpnter [rand [llength $ranpnter]]]
			regsub -all "%nick" $pnters $nick pnters
			putserv "PRIVMSG $chan :$pnters"
		}
		if {[string match -nocase "*vaksin*" [string tolower $text]]} {
			set vpinter [lindex $runvakpinter [rand [llength $runvakpinter]]]
			putserv "PRIVMSG $chan :$vpinter"
			return 0
		} else {
			set upinter [lindex $ranusrpinter [rand [llength $ranusrpinter]]]
			putserv "PRIVMSG $chan :$upinter"
		}
	}
}

##  bgo  ##
bind pubm - "* oon *" bgo_speak
bind pubm - "* bego *" bgo_speak
bind pubm - "* tolol *" bgo_speak
bind pubm - "* goblok *" bgo_speak
bind pubm - "* oon" bgo_speak
bind pubm - "* bego" bgo_speak
bind pubm - "* tolol" bgo_speak
bind pubm - "* goblok" bgo_speak
set ranbgo {
	"yang pasti monic lebih pinter dari %nick"
	"%nick yang o'on"
	"\001ACTION lebih pinter dari albert enstein tau\001"
	"Sori ya monic tuh anak sekolahan tau!!"
	"enak aja, monic pinter tau"
	"\001ACTION ranking 1 lho, pintelan juga monic daripada %nick\001"
}
set ranbegov {
	"dia mah pinter, ga kayak %nick o'on"
	"pinter kok"
}
set usrbego {
	"hu'uh"
	"emang"
}

proc bgo_speak {nick uhost hand chan text} {
	global botnick ranbgo ranbegov usrbego
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match -nocase "bot *" [string tolower $text]] || [string match -nocase "* bot *" [string tolower $text]] || [string match -nocase "* bot" [string tolower $text]]} { return 0 }
		if {$nick == "Vaksin"} {
			if {[string match "*gua*" [string tolower $text]] || [string match "*gue*" [string tolower $text]] || [string match "* gw *" [string tolower $text]] || [string match "* aku *" [string tolower $text]] || [string match "gua*" [string tolower $text]] || [string match "gue*" [string tolower $text]] || [string match "gw *" [string tolower $text]] || [string match "aku *" [string tolower $text]]} {
				putserv "PRIVMSG $chan :pinter kok"
				return 0
			}
		}
		if {[string match "* monic bego *" [string tolower $text]] || [string match "monic bego *" [string tolower $text]] || [string match "* monic bego" [string tolower $text]] || [string match "* monic oon *" [string tolower $text]] || [string match "monic oon *" [string tolower $text]] || [string match "* monic oon" [string tolower $text]] || [string match "* monic tolol *" [string tolower $text]] || [string match "monic tolol *" [string tolower $text]] || [string match "* monic tolol" [string tolower $text]] || [string match "* monic goblok *" [string tolower $text]] || [string match "monic goblok *" [string tolower $text]] || [string match "* monic goblok" [string tolower $text]] || [string match "* kamu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]] || [string match "elu *" [string tolower $text]] || [string match "* elu *" [string tolower $text]] || [string match "* elu" [string tolower $text]] || [string match "* monic bego *" [string tolower $text]]} {
			set begos [lindex $ranbgo [rand [llength $ranbgo]]]
			regsub -all "%nick" $begos $nick begos
			putserv "PRIVMSG $chan :$begos"
			return 0
		}
		if {[string match "*vaksin*" [string tolower $text]]} {
			set vbegos [lindex $ranbegov [rand [llength $ranbegov]]]
			regsub -all "%nick" $vbegos $nick vbegos
			putserv "PRIVMSG $chan :$vbegos"
			return 0
		}
		set usrbegos [lindex $usrbego [rand [llength $usrbego]]]
		putserv "PRIVMSG $chan :$usrbegos"
	}
}

##  sori  ##
bind pubm - "* sori *" sori_speak
bind pubm - "* sory *" sori_speak
bind pubm - "* maaf *" sori_speak
bind pubm - "* maap *" sori_speak
bind pubm - "* sori" sori_speak
bind pubm - "* sory" sori_speak
bind pubm - "* maaf" sori_speak
bind pubm - "* maap" sori_speak
set ransori {
	"%nick jangan gitu lagi ya"
	"iya iya"
	"\001ACTION tanya ayank vaksin dulu ya, boleh maafin %nick apa gak\001"
}

proc sori_speak {nick uhost hand chan text} {
	global botnick ransori
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set soris [lindex $ransori [rand [llength $ransori]]]
		regsub -all "%nick" $soris $nick soris
		putserv "PRIVMSG $chan :$soris"
	}
}

bind pubm - "* beli di mana *" beli_speak
bind pubm - "* beli di mana" beli_speak
set ranbeli {
	"%nick tanya sama rumput yang bergoyang gih"
	"ga mau kasih tau ahhh..."
}

proc beli_speak {nick uhost hand chan text} {
	global botnick ranbeli
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set belis [lindex $ranbeli [rand [llength $ranbeli]]]
		regsub -all "%nick" $belis $nick belis
		putserv "PRIVMSG $chan :$belis"
	}
}

## nyebelin ##
bind pubm - "* nyebelin *" nyebelin_speak
bind pubm - "* nyebelin" nyebelin_speak
bind pubm - "* ngeselin *" nyebelin_speak
bind pubm - "* ngeselin" nyebelin_speak

set rannyebelin {
	"%nick baru tau ya"
	"\001ACTION nyenegin tau..\001"
	"ah perasaan %nick aja"
	"\001ACTION baik hati dan menyenangkan kok\001"
}

proc nyebelin_speak {nick uhost hand chan text} {
	global botnick rannyebelin
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set nyebelins [lindex $rannyebelin [rand [llength $rannyebelin]]]
		regsub -all "%nick" $nyebelins $nick nyebelins
		putserv "PRIVMSG $chan :$nyebelins"
	}
}

##  kill  ##
bind pubm - "* kill *" kill_speak
bind pubm - "* bunuh *" kill_speak
set rankill {
	"jangan dung :("
	"%nick udah ga sayang sama monic lagi yaa :("
	"tapi %nick ntar jangan kangen sama monic ya"
	"jangan kill monic pleasseeeee..."
}

proc kill_speak {nick uhost hand chan text} {
	global botnick rankill
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set kills [lindex $rankill [rand [llength $rankill]]]
		regsub -all "%nick" $kills $nick kills
		putserv "PRIVMSG $chan :$kills"
	}
}

##  hai  ##
bind pub - hay hai_speak
bind pub - hai hai_speak
bind pub - halo hai_speak
bind pub - hallo hai_speak
bind pub - hi hai_speak
set ranhai {
	"Hai juga..!!"
	"Hallo %nick"
	"%nick nyapa siapa sih... nyapa monic ya :)"
}

proc hai_speak {nick uhost hand chan text} {
	global botnick ranhai
	if {![channel get $chan talk]} { return 0 }
	set hais [lindex $ranhai [rand [llength $ranhai]]]
	regsub -all "%nick" $hais $nick hais
	putserv "PRIVMSG $chan :$hais"
}

##  bt  ##
bind pubm - "* bt *" bt_speak
bind pubm - "* bete *" bt_speak
bind pubm - "bt *" bt_speak
bind pubm - "bete *" bt_speak
set ranbt {
	"%nick baru diputusin ya."
	"\001ACTION juga bt, dari tadi belom ada yg pv\001"
	"\001ACTION juga lagi bt banget nich, ga ada yang traktir\001"
	"%nick sini curhat sama monic kalo bt"
}

proc bt_speak {nick uhost hand chan text} {
	global botnick ranbt
	if {![channel get $chan talk]} { return 0 }
	if {[string match -nocase "siapa *" [string tolower $text]] || [string match "* siapa *" [string tolower $text]]} { return 0 }
	set bts [lindex $ranbt [rand [llength $ranbt]]]
	regsub -all "%nick" $bts $nick bts
	putserv "PRIVMSG $chan :$bts"
}

##  kbar  ##
bind pubm - "* apa kabar *" kbar_speak
bind pubm - "* apa kabar" kbar_speak
set rankbar {
	"sehat dong"
	"\001ACTION sehat, %nick gimana kabar nya?\001"
	"\001ACTION baik² aja\001"
}

proc kbar_speak {nick uhost hand chan text} {
	global botnick rankbar
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set kbars [lindex $rankbar [rand [llength $rankbar]]]
		regsub -all "%nick" $kbars $nick kbars
		putserv "PRIVMSG $chan :$kbars"
	}
}

##  bisa  ##
bind pubm - "* bisa *" bisa_speak
set ranbisa {
	"ga bisa"
	"\001ACTION pura² budek aahhh...\001"
}

proc bisa_speak {nick uhost hand chan text} {
	global botnick ranbisa
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "* ngitung *" [string tolower $text]] || [string match "* hitung *" [string tolower $text]] || [string match "* gara*" [string tolower $text]]} { return 0 }
		set bisas [lindex $ranbisa [rand [llength $ranbisa]]]
		putserv "PRIVMSG $chan :$bisas"
	}
}

##  slingkuh  ##
bind pubm - "* selingkuh *" slingkuh_speak
bind pubm - "* selingkuh" slingkuh_speak
set ranslingkuh {
	"biarin"
	"egp"
	"bodo amat"
}

proc slingkuh_speak {nick uhost hand chan text} {
	global botnick ranslingkuh
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "*boleh*" [string tolower $text]]} { return 0 }
		set slingkuhs [lindex $ranslingkuh [rand [llength $ranslingkuh]]]
		putserv "PRIVMSG $chan :$slingkuhs"
	}
}

##  ada  ##
bind pubm - "ada *" ada_speak
bind pubm - "* ada *" ada_speak

set runusrada {
	"bodo amat"
	"egp"
	"trus monic harus bilang WOW gitu?"
	"ga urus"
}

proc ada_speak {nick uhost hand chan text} {
	global botnick runusrada
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "* tuh *" [string tolower $text]] || [string match "* tuh" [string tolower $text]]} {
			if {[string match -nocase "* vaksin *" [string tolower $text]]} {
				putserv "PRIVMSG $chan :udah tau"
			} else {
				set usrada [lindex $runusrada [rand [llength $runusrada]]]
				putserv "PRIVMSG $chan :$usrada"
			}
		}
	}
}

##  bodo amat  ##
bind pubm - "bodo amat *" bodoamat_speak
bind pubm - "* bodo amat *" bodoamat_speak
bind pubm - "masa bodo *" bodoamat_speak
bind pubm - "masa bodo *" bodoamat_speak

proc bodoamat_speak {nick uhost hand chan text} {
	global botnick ranbodoamat
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		putserv "PRIVMSG $chan :sama"
	}
}

##  egp  ##
bind pubm - "* egp *" egp_speak
set ranegp {
	"\001ACTION egp juga\001"
	"egp tuh apa sih?"
}

proc egp_speak {nick uhost hand chan text} {
	global botnick ranegp
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set egps [lindex $ranegp [rand [llength $ranegp]]]
		putserv "PRIVMSG $chan :$egps"
	}
}

##  mkan2  ##
bind pubm - "makan apa *" jmkan_speak
bind pubm - "* makan apa *" jmkan_speak
bind pubm - "* makan apa" jmkan_speak
bind pubm - "maem apa *" jmkan_speak
bind pubm - "* maem apa *" jmkan_speak
bind pubm - "* maem apa" jmkan_speak
set jmakan {
	"\001ACTION makan hati\001"
	"hmmm... apa ya"
	"%nick mau minta ya?"
}

proc jmkan_speak {nick uhost hand chan text} {
	global botnick jmakan
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set jmkans [lindex $jmakan [rand [llength $jmakan]]]
		regsub -all "%nick" $jmkans $nick jmkans
		putserv "PRIVMSG $chan :$jmkans"
	}
}

##  mkan  ##
bind pubm - "* makan *" mkan_speak
bind pubm - "* maem *" mkan_speak
bind pubm - "makan *" mkan_speak
bind pubm - "maem *" mkan_speak
set ranmkan {
	"\001ACTION blm makan :(\001"
	"%nick mo traktir monic ya :)"
	"%nick beli'in monic makanan dong"
	"traktir monic donk"
	"\001ACTION udah makan\001"
}

proc mkan_speak {nick uhost hand chan text} {
	global botnick ranmkan
	if {![channel get $chan talk]} { return 0 }
	if {[string match "apa *" [string tolower $text]] || [string match "* apa *" [string tolower $text]] || [string match "* apa" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set mkans [lindex $ranmkan [rand [llength $ranmkan]]]
		regsub -all "%nick" $mkans $nick mkans
		putserv "PRIVMSG $chan :$mkans"
	}
}

##  gak boleh  ##
bind pubm - "ga boleh *" bleh_speak
bind pubm - "gak boleh *" bleh_speak
bind pubm - "* ga boleh *" bleh_speak
bind pubm - "* gak boleh *" bleh_speak
proc bleh_speak {nick uhost hand chan text} {
	global botnick
	if {![channel get $chan talk]} { return 0 }
	if {([string match "*nakal*" [string tolower $text]] || [string match "*sombong*" [string tolower $text]])} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		putserv "PRIVMSG $chan :iya"
	}
}
	
##  boleh gak  ##
bind pubm - "boleh ga*" bleh_speak
bind pubm - "boleh gak*" bleh_speak
bind pubm - "* boleh ga *" bleh_speak
bind pubm - "* boleh gak *" bleh_speak
set ranbleh {
	"ga boleh"
	"boleh ga yaaa..."
	"hmm..."
}

proc bleh_speak {nick uhost hand chan text} {
	global botnick ranbleh
	if {![channel get $chan talk]} { return 0 }
	if {([string match "*nakal*" [string tolower $text]] || [string match "*sombong*" [string tolower $text]])} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set blehs [lindex $ranbleh [rand [llength $ranbleh]]]
		putserv "PRIVMSG $chan :$blehs"
	}
}

##  mauu  ##
bind pubm - "* mau *" mauu_speak
bind pubm - "mau *" mauu_speak
set ranmauu {
	"mau.. mauu..."
	"ga, makasih %nick"
	"terserah %nick aja"
	"hmm..."
}

proc mauu_speak {nick uhost hand chan text} {
	global botnick ranmauu
	if {![channel get $chan talk]} { return 0 }
	if {[string match "*kill*" [string tolower $text]] || [string match "*bunuh*" [string tolower $text]] || [string match "*merried*" [string tolower $text]] || [string match "ml *" [string tolower $text]] || [string match "* ml *" [string tolower $text]] || [string match "* ml" [string tolower $text]] || [string match "*mesum*" [string tolower $text]] || [string match "*nikah*" [string tolower $text]] || [string match "*kill*" [string tolower $text]] || [string match "*nenen*" [string tolower $text]] || [string match "*mandi*" [string tolower $text]] || [string match "*jangan*" [string tolower $text]] || [string match "*kobel*" [string tolower $text]] || [string match "*k0bel*" [string tolower $text]] || [string match "*k0b3l*" [string tolower $text]] || [string match "*kob3l*" [string tolower $text]] || [string match "*obok*" [string tolower $text]] || [string match "*0b0k*" [string tolower $text]] || [string match "*ob0k*" [string tolower $text]] || [string match "*0bok*" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]] && ![string match "*boleh*" [string tolower $text]]} {
		if {[string match "*ga ada*" [string tolower $text]]} {
			putserv "PRIVMSG $chan :gak"
			return 0
		}
		if {[string match "* ga *" [string tolower $text]] || [string match "* ga" [string tolower $text]] || [string match "* gak *" [string tolower $text]] || [string match "* gak" [string tolower $text]] || [string match -nocase "emang *" [string tolower $text]] || [string match -nocase "mang *" [string tolower $text]] || [string match "* sama *" [string tolower $text]]} {
			set mauus [lindex $ranmauu [rand [llength $ranmauu]]]
			regsub -all "%nick" $mauus $nick mauus
			putserv "PRIVMSG $chan :$mauus"
		}
	}
}

##  lucu  ##
bind pubm - "* lucu *" lcu_speak
bind pubm - "* lucu" lcu_speak
set ranlcu {
	"apanya yang lucu ?"
	"kalo lucu ketawa dong..!!"
	"maca ciihh.."
}

proc lcu_speak {nick uhost hand chan text} {
	global botnick ranlcu
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set lcus [lindex $ranlcu [rand [llength $ranlcu]]]
		putserv "PRIVMSG $chan :$lcus"
	}
}

##  bugil  ##
bind pubm - "* bugil *" bgil_speak
bind pubm - "* bugil" bgil_speak
bind pubm - "* telanjang *" bgil_speak
set ranbgil {
	"ih monic malu tauu.."
	"%nick duluan deh"
	"\001ACTION kick %nick\001"
	"\001ACTION sets mode: +b %nick\001"
	"\001ACTION ga napsu sama %nick\001"
	"%nick pikir monic ce murahan apa"
}

proc bgil_speak {nick uhost hand chan text} {
	global botnick ranbgil
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set bgils [lindex $ranbgil [rand [llength $ranbgil]]]
		regsub -all "%nick" $bgils $nick bgils
		putserv "PRIVMSG $chan :$bgils"
	}
}

##  wb  ##
bind pubm - "* wb *" wb_speak
bind pubm - "* wb" wb_speak
set ranwb {
	"makacih %nick"
}

proc wb_speak {nick uhost hand chan text} {
	global botnick ranwb
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set wbs [lindex $ranwb [rand [llength $ranwb]]]
		regsub -all "%nick" $wbs $nick wbs
		putserv "PRIVMSG $chan :$wbs"
	}
}

##  hjr  ##
bind pubm - "* kaplok *" hjr_speak
bind pubm - "kaplok *" hjr_speak
bind pubm - "* sepak *" hjr_speak
bind pubm - "kaplok *" hjr_speak
set ranhjr {
	"%nick mau monic mutilasi ya?"
	"kok %nick tega banget sih"
	"%nick jangan emosi begitu donk, sabar.. sabar.."
}

proc hjr_speak {nick uhost hand chan text} {
	global botnick ranhjr
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set hjrs [lindex $ranhjr [rand [llength $ranhjr]]]
		regsub -all "%nick" $hjrs $nick hjrs
		putserv "PRIVMSG $chan :$hjrs"
	}
}

##  tlong  ##
bind pubm - "tolong *" tlong_speak
bind pubm - "* tolong" tlong_speak
bind pubm - "* tolong *" tlong_speak
bind pubm - "tolongin *" tlong_speak
bind pubm - "* tolongin *" tlong_speak
bind pubm - "* tolongin" tlong_speak
bind pubm - "help *" tlong_speak
bind pubm - "* help *" tlong_speak
bind pubm - "* help" tlong_speak
bind pubm - "bantu *" tlong_speak
bind pubm - "* bantu" tlong_speak
bind pubm - "* bantu *" tlong_speak
bind pubm - "bantuin *" tlong_speak
bind pubm - "* bantuin *" tlong_speak
bind pubm - "* bantuin" tlong_speak
set rantlong {
	"males"
	"ogah"
}

proc tlong_speak {nick uhost hand chan text} {
	global botnick rantlong
	if {![channel get $chan talk]} { return 0 }
	if {[string match *cari* [string tolower $text]]} { return 0 } 
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set tlongs [lindex $rantlong [rand [llength $rantlong]]]
		putserv "PRIVMSG $chan :$tlongs"
	}
}

##  vakckep  ##
bind pubm - "* cakep *" vakckep_speak
bind pubm - "* ganteng *" vakckep_speak
set ranvakckep {
	"udah pasti dong"
	"paling ok tauu..."
}
set ranuckep {
	"jelek"
	"jelek bingit"
	"cakepan juga ayank Vaksin"
}
set ranugnteng {
	"jelek"
	"jelek bingit"
	"gantengan juga ayank Vaksin"
}
set runmonckp {
	"\001ACTION emang cakep"
}

proc vakckep_speak {nick uhost hand chan text} {
	global botnick ranvakckep ranuckep runmonckp ranugnteng
	if {![channel get $chan talk]} { return 0 }
	if {[string match "jelek *" [string tolower $text]] || [string match "* jelek *" [string tolower $text]] || [string match "* kemana *" [string tolower $text]] || [string match "* mana *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "mon *" [string tolower $text]]} {
		if {[string match "*monic*" [string tolower $text]]} { return 0 }
		if {($nick == "Vaksin") || ($nick == "vaksin")} {
			if {[string match "gw *" [string tolower $text]] || [string match "* gw *" [string tolower $text]] || [string match "* gw" [string tolower $text]] || [string match "gua *" [string tolower $text]] || [string match "* gua *" [string tolower $text]] || [string match "* gua" [string tolower $text]] || [string match "aku *" [string tolower $text]] || [string match "* aku *" [string tolower $text]] || [string match "* aku" [string tolower $text]] || [string match "ak *" [string tolower $text]] || [string match "* ak *" [string tolower $text]] || [string match "* ak" [string tolower $text]]} {
				set vakckeps [lindex $ranvakckep [rand [llength $ranvakckep]]]
				putserv "PRIVMSG $chan :$vakckeps"
				return 0
			}
		}
		if {([string match -nocase "*vaksin*" [string tolower $text]]) || ($nick == "Vaksin" && [string match "* gua *" [string tolower $text]]) || ($nick == "Vaksin" && [string match "gua *" [string tolower $text]]) || ($nick == "Vaksin" && [string match "aku *" [string tolower $text]]) || ($nick == "Vaksin" && [string match "* aku *" [string tolower $text]])} {
			set vakckeps [lindex $ranvakckep [rand [llength $ranvakckep]]]
			putserv "PRIVMSG $chan :$vakckeps"
			return 0
		}
		if {[string match "* ganteng ga *" [string tolower $text]] || [string match "* ganteng gak *" [string tolower $text]] || [string match "* ganteng ya *" [string tolower $text]]} {
			set gntengs [lindex $ranugnteng [rand [llength $ranugnteng]]]
			putserv "PRIVMSG $chan :$gntengs"
			return 0
		}
		if {[string match "* cakep ga *" [string tolower $text]] || [string match "* cakep gak *" [string tolower $text]] || [string match "* cakep ya *" [string tolower $text]]} {
			set cakeps [lindex $ranuckep [rand [llength $ranuckep]]]
			putserv "PRIVMSG $chan :$cakeps"
			return 0
		}
		if {[string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]] || [string match "elu *" [string tolower $text]] || [string match "* elu *" [string tolower $text]] || [string match "* elu" [string tolower $text]] || [string match "kamu *" [string tolower $text]] || [string match "* kamu *" [string tolower $text]] || [string match "* kamu" [string tolower $text]]} {
			set monckeps [lindex $runmonckp [rand [llength $runmonckp]]]
			putserv "PRIVMSG $chan :$monckeps"
			return 0
		}
		if {[string match "gw *" [string tolower $text]] || [string match "* gw *" [string tolower $text]] || [string match "* gw" [string tolower $text]] || [string match "gua *" [string tolower $text]] || [string match "* gua *" [string tolower $text]] || [string match "* gua" [string tolower $text]] ||  || [string match "aku *" [string tolower $text]] || [string match "* aku *" [string tolower $text]] || [string match "* aku" [string tolower $text]] ||  || [string match "ak *" [string tolower $text]] || [string match "* ak *" [string tolower $text]] || [string match "* ak" [string tolower $text]]} {
			set ugntengs [lindex $ranugnteng [rand [llength $ranugnteng]]]
			putserv "PRIVMSG $chan :$ugntengs"
			return 0
		}
	}
}

##  cantik  ##
bind pubm - "* cantik *" ckep_speak
bind pubm - "* cantik" ckep_speak
bind pubm - "cantik *" ckep_speak
set ranckep {
	"dia mah jelek"
	"jelek bingit"
	"cantikan juga monic"
}
set monckep {
	"cantik dunk"
	"cantik bingit tau"
}

proc ckep_speak {nick uhost hand chan text} {
	global botnick ranckep monckep
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match -nocase "*vaksin*" [string tolower $text]]} {
			putserv "PRIVMSG $chan :dia mah ganteng"
			return 0
		}
		if {[string match "* ga *" [string tolower $text]] || [string match "* gak *" [string tolower $text]] || [string match "* ya *" [string tolower $text]]} {
			set ckeps [lindex $ranckep [rand [llength $ranckep]]]
			putserv "PRIVMSG $chan :$ckeps"
			return 0
		}
		if {[string match -nocase "* aku *" [string tolower $text]] || [string match "aku *" [string tolower $text]]} {
			putserv "PRIVMSG $chan :Prreeeettttttt..."
			return 0
		}
		if {[string match "monic *" [string tolower $text]] || [string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "elu *" [string tolower $text]] || [string match "* elu *" [string tolower $text]] || [string match "kamu *" [string tolower $text]] || [string match "* kamu *" [string tolower $text]]} {
			set monckeps [lindex $monckep [rand [llength $monckep]]]
			putserv "PRIVMSG $chan :$monckeps"
			return 0
		}
	}
}

##  mojok  ##
bind pubm - "* mojok *" mjok_speak
set ranmjok {
	"kaburrrr... ah *di ajak mojok sama %nick*"
	"emang %nick ga punya gebetan yah ;p"
	"\001ACTION dah punya yayank *sambil nunjuk² ke Vaksin*\001"
	"di tengah aja, di pojok udah penuh tau"
	"ga ah, monic lagi pengen sendirian"
}

proc mjok_speak {nick uhost hand chan text} {
	global botnick ranmjok
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set mjoks [lindex $ranmjok [rand [llength $ranmjok]]]
		regsub -all "%nick" $mjoks $nick mjoks
		putserv "PRIVMSG $chan :$mjoks"
	}
}

##  bohong  ##
bind pubm - "* bohong *" bhongg_speak
bind pubm - "* bohong" bhongg_speak
set ranbhongg {
	"ga percaya? tanya ayank Vaksin aja"
	"suer deh"
	"ye beneran tauu"
}
proc bhongg_speak {nick uhost hand chan text} {
	global botnick ranbhongg
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set bhonggs [lindex $ranbhongg [rand [llength $ranbhongg]]]
		putserv "PRIVMSG $chan :$bhonggs"
	}
}

##  segede  ##
bind pubm - "* gede *" sgede_speak
bind pubm - "* besar *" sgede_speak
set ransgede {
	"hu`uh gede bingit"
	"gede tauu..."
	"meteran aja belum tentu muat tau"
}
set ransbesar {
	"hu`uh besar bingit"
	"besar tauu..."
	"meteran aja belum tentu muat tau"
}
proc sgede_speak {nick uhost hand chan text} {
	global botnick ransgede ransbesar
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "segede *" [string tolower $text]]} {
			set sgedes [lindex $ransgede [rand [llength $ransgede]]]
			putserv "PRIVMSG $chan :$sgedes"
			return 0
		}
		if {[string match "sebesar *" [string tolower $text]]} {
			set sbesars [lindex $ransbesar [rand [llength $ransbesar]]]
			putserv "PRIVMSG $chan :$sbesars"
			return 0
		}
	}
}

##  nenenn  ##
bind pubm - "* nenen *" nenenn_speak
bind pubm - "* nenen" nenenn_speak
set rannenenn {
	"\001ACTION tonjolin dada dikit biar keliatan gede (  •  ) _ (  •  ) \001"
	"punya monic gede ga nih (  •  ) _ (  •  ) xixixi..."
}
proc nenenn_speak {nick uhost hand chan text} {
	global botnick rannenenn
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set nenenns [lindex $rannenenn [rand [llength $rannenenn]]]
		putserv "PRIVMSG $chan :$nenenns"
	}
}

##  nyolot  ##
bind pubm - "* nyolot *" nylott_speak
bind pubm - "* nyolot" nylott_speak
set rannylott {
	"%nick duluan cih"
	"maka nya jangan gangguin monic mulu"
}
proc nylott_speak {nick uhost hand chan text} {
	global botnick rannylott
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set nylotts [lindex $rannylott [rand [llength $rannylott]]]
		regsub -all "%nick" $nylotts $nick nylotts
		putserv "PRIVMSG $chan :$nylotts"
	}
}

##  manis  ##
bind pubm - "* cantik *" mnis_speak
bind pubm - "* cakep *" mnis_speak
bind pubm - "* manis *" mnis_speak
bind pubm - "* cantik" mnis_speak
bind pubm - "* cakep" mnis_speak
bind pubm - "* manis" mnis_speak
set ranmnis {
	"%nick pasti mau pdkt nih"
	"%nick baru tau ya? kasian deh luu.."
	"ya iya lah monic gitu lho :)"
	"%nick bikin g'er aja dech :p"
	"%nick genit ikz"
}
proc mnis_speak {nick uhost hand chan text} {
	global botnick ranmnis
	if {![channel get $chan talk]} { return 0 }
	if {([string match "monic *" [string tolower $text]] || [string match "* mon" [string tolower $text]]) && ![string match "* ga *" [string tolower $text]])} {
		set mniss [lindex $ranmnis [rand [llength $ranmnis]]]
		regsub -all "%nick" $mniss $nick mniss
		putserv "PRIVMSG $chan :$mniss"
	}
}

##  tdur  ##
bind pubm - "* tidur *" tdur_speak
bind pubm - "* tidur" tdur_speak
bind pubm - "* bubuk" tdur_speak
bind pubm - "* bubuk *" tdur_speak
bind pubm - "* bobo *" tdur_speak
bind pubm - "* bobo" tdur_speak
bind pubm - "* bobok *" tdur_speak
bind pubm - "* bobok" tdur_speak
set rantdur {
	"bentar lagi"
	"\001ACTION belum ngantuk\001"
}

proc tdur_speak {nick uhost hand chan text} {
	global botnick rantdur
	if {![channel get $chan talk]} { return 0 }
	if {[string match "aku *" [string tolower $text]] || [string match "* aku *" [string tolower $text]] || [string match "ak *" [string tolower $text]] || [string match "* ak *" [string tolower $text]] || [string match "gua *" [string tolower $text]] || [string match "* gua *" [string tolower $text]] || [string match "gw *" [string tolower $text]] || [string match "* gw *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "bangun *" [string tolower $text]] || [string match "* bangun *" [string tolower $text]] || [string match "* bangun" [string tolower $text]] || [string match "* di *" [string tolower $text]] || [string match "* udah *" [string tolower $text]] || [string match "aku *" [string tolower $text]] || [string match "ak *" [string tolower $text]] || [string match "gua *" [string tolower $text]] || [string match "gw *" [string tolower $text]] || [string match "saya *" [string tolower $text]] || [string match "sy *" [string tolower $text]]} { return 0 }
		set tdurs [lindex $rantdur [rand [llength $rantdur]]]
		putserv "PRIVMSG $chan :$tdurs"
	}
}

##  ngantuk  ##
bind pubm - "* ngantuk *" ngantuk_speak
bind pubm - "* ngantuk" ngantuk_speak
set ranngantuk {
	"Di belakang ada kandang kosong tuh, %nick bubuk sana aja"
	"%nick, buruan gih tidur trus ga usah bangun lagi ya"
}

proc ngantuk_speak {nick uhost hand chan text} {
	global botnick ranngantuk
	if {![channel get $chan talk]} { return 0 }
	if {[string match "udah *" [string tolower $text]] || [string match "* udah *" [string tolower $text]] || [string match "belum *" [string tolower $text]] || [string match "* belum *" [string tolower $text]] || [string match "belom *" [string tolower $text]] || [string match "* belom *" [string tolower $text]] || [string match "blom *" [string tolower $text]] || [string match "* blom *" [string tolower $text]] || [string match "lum *" [string tolower $text]] || [string match "* lum *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set ngantuks [lindex $ranngantuk [rand [llength $ranngantuk]]]
		regsub -all "%nick" $ngantuks $nick ngantuks
		putserv "PRIVMSG $chan :$ngantuks"
	}
}

##  hjn  ##
bind pub - hujan hjn_speak
bind pub - ujan hjn_speak
set ranhjn {
	"di sini gak hujan, malah panas banget"
	"Sedia Perahu sebelum banjir %nick xixixi..."
	"%nick mau monic pinjemin perahu ga?"
}

proc hjn_speak {nick uhost hand chan text} {
	global botnick ranhjn
	if {![channel get $chan talk]} { return 0 }
	set hjns [lindex $ranhjn [rand [llength $ranhjn]]]
	regsub -all "%nick" $hjns $nick hjns
	putserv "PRIVMSG $chan :$hjns"
}

##  mkasih  ##
bind pubm - "* makasih *" mkasih_speak
bind pubm - "* thx *" mkasih_speak
bind pubm - "* terima kasih *" mkasih_speak
bind pubm - "* makasih" mkasih_speak
bind pubm - "* thx" mkasih_speak
bind pubm - "* terima kasih" mkasih_speak
set ranmkasih {
	"sama² %nick"
	"ok"
	"yw %nick" 
}

proc mkasih_speak {nick uhost hand chan text} {
	global botnick ranmkasih
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set mkasihs [lindex $ranmkasih [rand [llength $ranmkasih]]]
		regsub -all "%nick" $mkasihs $nick mkasihs
		putserv "PRIVMSG $chan :$mkasihs"
	}
}

##  lpr  ##
bind pub - laper lpr_speak
bind pub - lapar lpr_speak
set ranlpr {
	"Di dapur ada sisa nasi kemarin, %nick mau ga?"
	"ada makanan kucing nih %nick mau ga?"
}

proc lpr_speak {nick uhost hand chan text} {
	global botnick ranlpr
	if {![channel get $chan talk]} { return 0 }
	set lprs [lindex $ranlpr [rand [llength $ranlpr]]]
	regsub -all "%nick" $lprs $nick lprs
	putserv "PRIVMSG $chan :$lprs"
}

##  cium  ##
bind pubm - "sun *" cium_speak
bind pubm - "* sun *" cium_speak
bind pubm - "* sun" cium_speak
bind pubm - "cium *" cium_speak
bind pubm - "* cium *" cium_speak
bind pubm - "* cium" cium_speak
bind pubm - "kiss *" cium_speak
bind pubm - "* kiss *" cium_speak
bind pubm - "* kiss" cium_speak
bind pubm - "muach *" cium_speak
bind pubm - "* muach *" cium_speak
bind pubm - "* muach" cium_speak
bind pub - :* cium_speak
set rancium {
	"ih, %nick blm gosok gigi"
	"\001ACTION blm gosok gigi lho\001"
	"ogah"
	"%nick bau jigong"
}
set ranusrcium {
	"males ah dia ompong"
	"ogah dia ga pernah gosok gigi"
}

proc cium_speak {nick uhost hand chan text} {
	global botnick rancium ranusrcium
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "mau *" [string tolower $text]] || [string match "* mau *" [string tolower $text]] || [string match "* mau" [string tolower $text]]} { return 0 }
		foreach userr [chanlist $chan] {
			set cekusr [lindex $text 1]
			if {[string match -nocase $cekusr [string tolower $userr]]} {
				set usrcium [lindex $ranusrcium [rand [llength $ranusrcium]]]
				putserv "PRIVMSG $chan :$usrcium"
				return 0
			}
		}
		set ciums [lindex $rancium [rand [llength $rancium]]]
		regsub -all "%nick" $ciums $nick ciums
		putserv "PRIVMSG $chan :$ciums"
	}
}

##  knapa  ##
bind pubm - "* kenapa *" knapa_speak
bind pubm - "* kenapa" knapa_speak
set ranknapa {
	"kasih tau ga yaa..."
	"gpp"
	"\001ACTION rapopo\001"
}

proc knapa_speak {nick uhost hand chan text} {
	global botnick ranknapa
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set knapas [lindex $ranknapa [rand [llength $ranknapa]]]
		putserv "PRIVMSG $chan :$knapas"
	}
}

##  kasih tau  ##
bind pubm - "* kasih tau *" ksih_speak
bind pubm - "* kasih tau" ksih_speak
set ranksihtau {
	"jangan"
	"ga usah"
	"terserah %nick aja"
}
set ranksihtau2 {
	"%nick aja yang kasih tau"
	"males ah"
}

proc ksih_speak {nick uhost hand chan text} {
	global botnick ranksihtau ranksihtau2
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "*jangan kasih tau*" [string tolower $text]]} {
			putserv "PRIVMSG $chan :ok"
		}
		if {[string match "*kasih tau jangan*" [string tolower $text]] || [string match "*kasih tau apa jangan*" [string tolower $text]] || [string match "*kasih tau pa jangan*" [string tolower $text]] || [string match "*kasih tau * jangan*" [string tolower $text]] || [string match "*kasih tau * apa jangan*" [string tolower $text]] || [string match "*kasih tau * pa jangan*" [string tolower $text]]} {
			set ksihtaus [lindex $ranksihtau [rand [llength $ranksihtau]]]
			regsub -all "%nick" $ksihtaus $nick ksihtaus
			putserv "PRIVMSG $chan :$ksihtaus"
		}
		set ksihtauus [lindex $ranksihtau2 [rand [llength $ranksihtau2]]]
		regsub -all "%nick" $ksihtauus $nick ksihtauus
		putserv "PRIVMSG $chan :$ksihtauus"
	}
}

bind pubm - "* jangan *" jangan_speak

proc jangan_speak {nick uhost hand chan text} {
	global botnick
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "*kasih tau*" [string tolower $text]] || [string match "*nakal*" [string tolower $text]] || [string match "*bandel*" [string tolower $text]] || [string match "*badung*" [string tolower $text]]} { return 0 }
		putserv "PRIVMSG $chan :ok"
	}
}

bind pubm - "* yang mana *" ymana_speak
bind pubm - "* yg mana *" ymana_speak
bind pubm - "* yang mana" ymana_speak
bind pubm - "* yg mana" ymana_speak
bind pubm - "yang mana *" ymana_speak
bind pubm - "yg mana *" ymana_speak
set ranymana {
	"kasih tau ga yaa..."
	"mana aja boleh..."
}

proc ymana_speak {nick uhost hand chan text} {
	global botnick ranymana
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set ymanas [lindex $ranymana [rand [llength $ranymana]]]
		putserv "PRIVMSG $chan :$ymanas"
	}
}

##  rajin  ##
bind pubm - "rajin *" rajin_speak
bind pubm - "* rajin *" rajin_speak
bind pubm - "* rajin" rajin_speak

set ranlgirajin {
	"iya dong"
	"kata mama monic ga boleh males"
	"ya iya lah, emang nya %nick pemalas"
}

proc rajin_speak {nick uhost hand chan text} {
	global botnick ranlgirajin
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set lgirajins [lindex $ranlgirajin [rand [llength $ranlgirajin]]]
		regsub -all "%nick" $lgirajins $nick lgirajins
		putserv "PRIVMSG $chan :$lgirajins"
	}
}

bind pubm - "* ngapain" ngapain_speak
bind pubm - "* ngapain *" ngapain_speak
bind pubm - "* apa *" ngapain_speak
bind pubm - "* apa" ngapain_speak

set ranlgingapain {
	"lagi ngitungin rambut"
	"nguras air laut, %nick mau bantuin?"
	"%nick kepo amat sih nanya²"
	"nyari kutu"
	"ngukur jalan"
}

proc ngapain_speak {nick uhost hand chan text} {
	global botnick ranlgingapain
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "diem *" [string tolower $text]] || [string match "* diem *" [string tolower $text]] || [string match "* diem" [string tolower $text]]} { return 0 }
		if {[string match "lagi *" [string tolower $text]] || [string match "* lagi *" [string tolower $text]] || [string match "* lagi" [string tolower $text]] || [string match "lgi *" [string tolower $text]] || [string match "* lgi *" [string tolower $text]] || [string match "* lgi" [string tolower $text]]} {
			set lgingapains [lindex $ranlgingapain [rand [llength $ranlgingapain]]]
			regsub -all "%nick" $lgingapains $nick lgingapains
			putserv "PRIVMSG $chan :$lgingapains"
		}
	}
}

##  masak  ##
bind pubm - "masak *" masak_speak
bind pubm - "* masak *" masak_speak
bind pubm - "* masak" masak_speak

set ranmasak1 {
	"masak air"
	"indomie"
}
set ranmasak2 {
	"bisa dung"
	"ya bisa lah"
}

proc masak_speak {nick uhost hand chan text} {
	global botnick ranmasak1 ranmasak2
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "apa *" [string tolower $text]] || [string match "* apa *" [string tolower $text]] || [string match "* apa" [string tolower $text]] || [string match "lagi *" [string tolower $text]] || [string match "* lagi *" [string tolower $text]] || [string match "* lagi" [string tolower $text]]} {
			set masak1s [lindex $ranmasak1 [rand [llength $ranmasak1]]]
			putserv "PRIVMSG $chan :$masak1s"
		}
		if {[string match "* bisa *" [string tolower $text]] || [string match "* bsa *" [string tolower $text]]} {
			if {[string match "* apa *" [string tolower $text]]} { return 0 }
			set masak2s [lindex $ranmasak2 [rand [llength $ranmasak2]]]
			putserv "PRIVMSG $chan :$masak2s"
		}
	}
}

## sewot ##
bind pubm - "sewot *" sewot_speak
bind pubm - "* sewot *" sewot_speak
bind pubm - "* sewot" sewot_speak
set ransewot {
	"\001ACTION biasa² aja tuh\001"
	"suka² monic dong"
}

proc sewot_speak {nick uhost hand chan text} {
	global botnick ransewot
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* jangan *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]] || [string match "elu *" [string tolower $text]] || [string match "* elu *" [string tolower $text]] || [string match "* elu" [string tolower $text]] || [string match "kamu *" [string tolower $text]] || [string match "* kamu *" [string tolower $text]] || [string match "* kamu" [string tolower $text]]} {
			set sewots [lindex $ransewot [rand [llength $ransewot]]]
			putserv "PRIVMSG $chan :$sewots"
		}
	}
}

## ga ikut ##
bind pubm - "* ga ikut *" gaikut_speak
bind pubm - "* gak ikut *" gaikut_speak

set rangaikut {
	"\001ACTION nunggu di rumah aja\001"
	"\001ACTION lagi males keluar\001"
}

proc gaikut_speak {nick uhost hand chan text} {
	global botnick rangaikut
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "*kenapa*" [string tolower $text]] || [string match "* mati *" [string tolower $text]]} { return 0 }
		set gaikuts [lindex $rangaikut [rand [llength $rangaikut]]]
		putserv "PRIVMSG $chan :$gaikuts"
	}
}

##  darimana  ##
bind pubm - "dari mana *" dmana_speak
bind pubm - "* dari mana *" dmana_speak
bind pubm - "* dari mana" dmana_speak

set randrimna {
	"abis nyari ayank Vaksin"
	"%nick kepo amat sih nanya²"
	"ada deehhh..."
}
set randrimnatau {
	"%nick mau tau aja"
	"dari ayank Vaksin"
	"%nick kepo amat sih nanya²"
}

proc dmana_speak {nick uhost hand chan text} {
	global botnick randrimna randrimnatau
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "*monic*" [string tolower $text]] || [string match "mon *" [string tolower $text]]} {
		if {[string match "tau *" [string tolower $text]] || [string match "* tau *" [string tolower $text]] || [string match "* tau" [string tolower $text]]} {
			set dmanataus [lindex $randrimnatau [rand [llength $randrimnatau]]]
			regsub -all "%nick" $dmanataus $nick dmanataus
			putserv "PRIVMSG $chan :$dmanataus"
			return 0
		}
		set dmanavs [lindex $randrimna [rand [llength $randrimna]]]
		regsub -all "%nick" $dmanavs $nick dmanavs
		putserv "PRIVMSG $chan :$dmanavs"
	}
}

##  jomblo  ##
bind pubm - "jomblo *" jomblo_speak
bind pubm - "* jomblo *" jomblo_speak

set ranjomblo {
	"udah punya pacar"
	"udah laku dong"
}

proc jomblo_speak {nick uhost hand chan text} {
	global botnick ranjomblo
	if {![channel get $chan talk]} { return 0 }
	if {[string match "bener *" [string tolower $text]] || [string match "* bener *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "*monic*" [string tolower $text]] || [string match "mon *" [string tolower $text]]} {
		set jomblos [lindex $ranjomblo [rand [llength $ranjomblo]]]
		putserv "PRIVMSG $chan :$jomblos"
	}
}

##  putus  ##
bind pubm - "putus *" putus_speak
bind pubm - "* putus *" putus_speak

set ranputusvak {
	"kalo iya kenapa, kalo ga kenapa?"
	"kepo"
	"ga dong, soal nya Vaksin tuh LIMITED EDITION tau"
}

set ranputus {
	"jadian sama dia aja ga"
	"\001ACTION belum pernah jadian sama dia kok\001"
}

proc putus_speak {nick uhost hand chan text} {
	global botnick ranputusvak ranputus
	if {![channel get $chan talk]} { return 0 }
	if {[string match "bener *" [string tolower $text]] || [string match "* bener *" [string tolower $text]] || [string match "mau *" [string tolower $text]] || [string match "* mau *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "*monic*" [string tolower $text]] || [string match "mon *" [string tolower $text]]} {
		if {[string match -nocase "* vaksin *" [string tolower $text]]} {
			set ptusvak [lindex $ranputusvak [rand [llength $ranputusvak]]]
			putserv "PRIVMSG $chan :$ptusvak"
			return 0
		} else {
			set ptus [lindex $ranputus [rand [llength $ranputus]]]
			putserv "PRIVMSG $chan :$ptus"
		}
	}
}

##  berapa  ##
bind pubm - "berapa *" berapa_speak
bind pubm - "* berapa *" berapa_speak

set ranberapa {
	"%nick mau tau aja"
	"\001ACTION lupa\001"
}

proc berapa_speak {nick uhost hand chan text} {
	global botnick ranberapa
	if {![channel get $chan talk]} { return 0 }
	if {[string match "jam *" [string tolower $text]] || [string match "* jam *" [string tolower $text]]} { return 0 }
	if {[string match {+} [string tolower $text]] || [string match {*} [string tolower $text]] || [string match {/} [string tolower $text]] || [string match {-} [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "*monic*" [string tolower $text]] || [string match "mon *" [string tolower $text]]} {
		set berapas [lindex $ranberapa [rand [llength $ranberapa]]]
		regsub -all "%nick" $berapas $nick berapas
		putserv "PRIVMSG $chan :$berapas"
	}
}

##  udah  ##
bind pubm - "udah *" udah_speak
bind pubm - "* udah *" udah_speak

set ranudah {
	"udah"
	"belum"
}

proc udah_speak {nick uhost hand chan text} {
	global botnick ranudah
	if {![channel get $chan talk]} { return 0 }
	if {[string match "*berapa*" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "*monic*" [string tolower $text]] || [string match "mon *" [string tolower $text]]} {
		set udas [lindex $ranudah [rand [llength $ranudah]]]
		putserv "PRIVMSG $chan :$udas"
	}
}

##  nonton  ##
bind pubm - "nonton *" nonton_speak
bind pubm - "* nonton *" nonton_speak

set ranonton {
	"males ah, paling ntar %nick tidur"
	"nonton di mana?"
	"%nick beli tiket nya dulu gih"
	"film apa?"
}

proc nonton_speak {nick uhost hand chan text} {
	global botnick ranonton
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "*monic*" [string tolower $text]] || [string match "mon *" [string tolower $text]]} {
		set ntons [lindex $ranonton [rand [llength $ranonton]]]
		regsub -all "%nick" $ntons $nick ntons
		putserv "PRIVMSG $chan :$ntons"
	}
}

##  film apa  ##
bind pubm - "film apa *" film_speak
bind pubm - "* film apa *" film_speak
bind pubm - "film apa? *" film_speak
bind pubm - "* film apa" film_speak
bind pubm - "* film apa?" film_speak

set ranfilm {
	"%nick suka nya film apa?"
	"\001ACTION suka film barbie\001"
	"upin ipin"
	"hmmm... film apa ya"
	"terserah %nick aja"
}

proc film_speak {nick uhost hand chan text} {
	global botnick ranfilm
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set films [lindex $ranfilm [rand [llength $ranfilm]]]
		regsub -all "%nick" $films $nick films
		putserv "PRIVMSG $chan :$films"
	}
}

##  kemana  ##
bind pubm - "* kemana *" kmana_speak
bind pubm - "* kemana" kmana_speak
bind pubm - "* dimana *" kmana_speak
bind pubm - "* dimana" kmana_speak
bind pubm - "* mana *" kmana_speak

set rankmana {
	"udah mati"
	"cari aja sendiri"
	"mana tau, emang monic emaknya apa"
	"lagi gali sumur"
	"tadi sih monic liat lagi di kejar kantib"
}
set rankemanav {
	"lagi tidur"
	"ke warung"
	"lagi nyuci"
	"\001ACTION ga mau kasih tau ah, ntar di gebet sama %nick -_- \001"
}
set mbel {
	"lagi nonton sama Ndre"
	"tadi monic liat berduaan di taman sama Ndre"
	"kayak nya mojok sama Ndre"
}
set ndre {
	"lagi nonton sama gembel"
	"tadi monic liat berduaan di taman sama gembel"
	"kayak nya mojok sama gembel"
}

proc kmana_speak {nick uhost hand chan text} {
	global botnick rankmana rankemanav mbel ndre
	if {![channel get $chan talk]} { return 0 }
	if {[lindex $text 0] == "mana" || [string match "*sepi*" [string tolower $text]]} { return 0 }
	if {[string match "*mau*" [string tolower $text]] || [string match "*monic*" [string tolower $text]] || [string match "* tinggal *" [string tolower $text]] || [string match "* rumah *" [string tolower $text]] || [string match "* yang *" [string tolower $text]] || [string match "* yg *" [string tolower $text]] || [string match "* fb *" [string tolower $text]] || [string match "* facebook *" [string tolower $text]] || [string match "* lihat *" [string tolower $text]] || [string match "* liat *" [string tolower $text]] || [string match "* ada *" [string tolower $text]] || [string match "*rumah*" [string tolower $text]] || [string match "*jalan*" [string tolower $text]] || [string match "*beli*" [string tolower $text]] || [string match "* sama *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match -nocase "*vaksin*" [string tolower $text]]} {
			set kmanavs [lindex $rankemanav [rand [llength $rankemanav]]]
			regsub -all "%nick" $kmanavs $nick kmanavs
			putserv "PRIVMSG $chan :$kmanavs"
			return 0
		}
		if {[string match "pada *" [string tolower $text]] || [string match "* pada *" [string tolower $text]]} {
			putserv "PRIVMSG $chan :pada mati"
			return 0
		}
		if {[string match -nocase "*gembel*" [string tolower $text]]} {
			set mbels [lindex $mbel [rand [llength $mbel]]]
			regsub -all "%nick" $mbels $nick mbels
			putserv "PRIVMSG $chan :$mbels"
			return 0
		}
		if {[string match -nocase "*ndre*" [string tolower $text]]} {
			set ndres [lindex $ndre [rand [llength $ndre]]]
			regsub -all "%nick" $ndres $nick ndres
			putserv "PRIVMSG $chan :$ndres"
			return 0
		}
		if {![string match "* sekolah *" [string tolower $text]]} {
			if {[lindex $text 0] == "pada" || [string match "*kemana aja*" [string tolower $text]] || [string match "*kemana saja*" [string tolower $text]] || [string match "*dari*" [string tolower $text]]} { return 0 }
			set kmanas [lindex $rankmana [rand [llength $rankmana]]]
			regsub -all "%nick" $kmanas $nick kmanas
			putserv "PRIVMSG $chan :$kmanas"
			return 0
		}
	}
}

##  mau kemana  ##
bind pubm - "mau kemana *" nkmana_speak
bind pubm - "* mau kemana *" nkmana_speak
set ranmkmana {
	"kepo lu"
	"%nick mau ngajak jalan ya"
	"kemana aja boleh"
}

proc nkmana_speak {nick uhost hand chan text} {
	global botnick ranmkmana
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set mkmanas [lindex $ranmkmana [rand [llength $ranmkmana]]]
		regsub -all "%nick" $mkmanas $nick mkmanas
		putserv "PRIVMSG $chan :$mkmanas"
		return 0
	}
}

##  edann  ##
bind pubm - "edan *" edann_speak
bind pubm - "* edan *" edann_speak
bind pubm - "gila *" edann_speak
bind pubm - "* gila *" edann_speak
bind pubm - "sinting *" edann_speak
bind pubm - "* sinting *" edann_speak
bind pubm - "* edan" edann_speak
bind pubm - "* gila" edann_speak
bind pubm - "* sinting" edann_speak
set ranmonedann {
	"\001ACTION waras kok\001"
	"enak aja"
	"\001ACTION barusan kaya denger ada yg nggong gong *lirik %nick*\001"
	"dibanding %nick ya masih waras monic lah"
}
set ranvakedann {
	"dia waras kok"
	"dibanding %nick masih waras dia lah"
}
set ranedan {
	"emang"
	"dia mah udah lama"
	"%nick baru tau ya"
}

proc edann_speak {nick uhost hand chan text} {
	global botnick ranmonedann ranedan ranvakedann
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match -nocase "bot *" [string tolower $text]] || [string match -nocase "* bot *" [string tolower $text]] || [string match -nocase "* bot" [string tolower $text]]} { return 0 }
		if {[string match -nocase "*vaksin*" [string tolower $text]]} {
			set edanvaks [lindex $ranvakedann [rand [llength $ranvakedann]]]
			regsub -all "%nick" $edanvaks $nick edanvaks
			putserv "PRIVMSG $chan :$edanvaks"
			return 0
		}
		if {([lindex $text 0] == "Monic" && [lindex $text 1] == "gila") || ([lindex $text 0] == "monic" && [lindex $text 1] == "gila") || [string match "kamu *" [string tolower $text]] || [string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]]} {
			set edanmons [lindex $ranmonedann [rand [llength $ranmonedann]]]
			regsub -all "%nick" $edanmons $nick edanmons
			putserv "PRIVMSG $chan :$edanmons"
			return 0
		}
		set edanns [lindex $ranedan [rand [llength $ranedan]]]
		regsub -all "%nick" $edanns $nick edanns
		putserv "PRIVMSG $chan :$edanns"
	}
}

##  smbong  ##
bind pubm - "* sombong *" smbong_speak
bind pubm - "* songong *" smbong_speak
bind pubm - "* somse *" smbong_speak
bind pubm - "* sombong" smbong_speak
bind pubm - "* songong" smbong_speak
bind pubm - "* somse" smbong_speak
set ransmbong {
	"ga kok"
	"ah perasaan %nick aja"
}

proc smbong_speak {nick uhost hand chan text} {
	global botnick ransmbong
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set smbongs [lindex $ransmbong [rand [llength $ransmbong]]]
		regsub -all "%nick" $smbongs $nick smbongs
		putserv "PRIVMSG $chan :$smbongs"
	}
}

##  nkal  ##
bind pubm - "* nakal *" nkal_speak
bind pubm - "* bandel *" nkal_speak
bind pubm - "* badung *" nkal_speak
bind pubm - "* nakal" nkal_speak
bind pubm - "* bandel" nkal_speak
bind pubm - "* badung" nkal_speak
set rannkal {
	"%nick baru tau ya xixixixi..."
	"ga kok"
	"kan %nick yg ngajarin"
}
set ranvaknkal {
	"hu'uh"
	"iya"
}
set ranvakgankal {
	"ga kok"
	"dia mah anak baik"
}

proc nkal_speak {nick uhost hand chan text} {
	global botnick rannkal ranvaknkal ranvakgankal
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "*siapa*" [string tolower $text]]} { return 0 }
		if {[string match -nocase "* vaksin *" [string tolower $text]]} {
			set vakgankals [lindex $ranvakgankal [rand [llength $ranvakgankal]]]
			putserv "PRIVMSG $chan :$vakgankals"
			return 0
		}
		if {$nick == "Vaksin"} {
			if {[string match "*jangan*" [string tolower $text]]} {
				putserv "PRIVMSG $chan :iya"
				return 0
			}
			if {[string match "*gua*" [string tolower $text]] || [string match "*gw*" [string tolower $text]]} {
				putserv "PRIVMSG $chan :ga kok"
				return 0
			}
			if {[string match "* kayak *" [string tolower $text]] || [string match "* kyk *" [string tolower $text]]} { return 0 }
			set vaknkals [lindex $ranvaknkal [rand [llength $ranvaknkal]]]
			putserv "PRIVMSG $chan :$vaknkals"
			return 0
		}
		set nkals [lindex $rannkal [rand [llength $rannkal]]]
		regsub -all "%nick" $nkals $nick nkals
		putserv "PRIVMSG $chan :$nkals"
	}
}

##  kapan  ##
bind pubm - "* kapan *" kapan_speak
bind pubm - "kapan *" kapan_speak
set rankapan {
	"kapan aja boleh, terserah %nick dech"
	"emang %nick mau nya kapan?"
}

proc kapan_speak {nick uhost hand chan text} {
	global botnick rankapan
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match -nocase "*vaksin*" [string tolower $text]] && [string match "* mati" [string tolower $text]] || [string match -nocase "*vaksin*" [string tolower $text]] && [string match "* mati *" [string tolower $text]]} {
			puthelp "PRIVMSG $chan :nunggu $nick duluan kata nya"
			return 0
		}
		set kapans [lindex $rankapan [rand [llength $rankapan]]]
		regsub -all "%nick" $kapans $nick kapans
		putserv "PRIVMSG $chan :$kapans"
	}
}

##  hi  ##
bind pub - halo hi_speak
bind pub - hallo hi_speak
bind pub - hi hi_speak
set ranhi {
	"hi %nick"
	"halo %nick"
	"%nick sapa ya?"
}

proc hi_speak {nick uhost hand chan text} {
	global botnick ranhi
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set his [lindex $ranhi [rand [llength $ranhi]]]
		regsub -all "%nick" $his $nick his
		putserv "PRIVMSG $chan :$his"
	}
}

##  kangen  ##
bind pubm - "* kangen *" kangen_speak
bind pubm - "kangen *" kangen_speak
set rankangen {
	"\001ACTION juga kangen banget nich, tapi bukan sama %nick\001"
	"emang %nick kangen ?"
}
set rankangensiapa {
	"\001ACTION kangen ama ayank Vaksin :(\001"
	"yang pasti bukan sama %nick"
}

proc kangen_speak {nick uhost hand chan text} {
	global botnick rankangen rankangensiapa
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "* siapa *" [string tolower $text]]} {
			set kangensiapa [lindex $rankangensiapa [rand [llength $rankangensiapa]]]
			regsub -all "%nick" $kangensiapa $nick kangensiapa
			putserv "PRIVMSG $chan :$kangensiapa"
			return 0
		} else {
			set kangens [lindex $rankangen [rand [llength $rankangen]]]
			regsub -all "%nick" $kangens $nick kangens
			putserv "PRIVMSG $chan :$kangens"
		}
	}
}

##  skul  ##
bind pubm - "* skul *" skul_speak
bind pubm - "* sekolah *" skul_speak
set ranskul {
	"\001ACTION ga sekolah\001"
	"%nick mo bayarin uang sekolah monic ya"
	"\001ACTION udah lulus\001"
	"kalo %nick skul dimana?"
}

proc skul_speak {nick uhost hand chan text} {
	global botnick ranskul
	if {![channel get $chan talk]} { return 0 }
	if {([string match "*yuk*" [string tolower $text]])} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set skuls [lindex $ranskul [rand [llength $ranskul]]]
		regsub -all "%nick" $skuls $nick skuls
		putserv "PRIVMSG $chan :$skuls"
	}
}

##  suruh  ##
bind pubm - "* di suruh *" sruh_speak
bind pubm - "di suruh *" sruh_speak
set ransruh {
	"ogah la yau"
	"\001ACTION pura² budek ahh...\001"
}

proc sruh_speak {nick uhost hand chan text} {
	global botnick ransruh
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]]} {
		set sruhs [lindex $ransruh [rand [llength $ransruh]]]
		regsub -all "%nick" $sruhs $nick sruhs
		putserv "PRIVMSG $chan :$sruhs"
	}
}

##  matree  ##
bind pubm - "* matre *" matree_speak
bind pubm - "* matre" matree_speak
set ranmatree {
	"hari gini engga matre rugi tau"
	"\001ACTION cengar cengir\001"
	"wajar dong monic kan cewe"
}

proc matree_speak {nick uhost hand chan text} {
	global botnick ranmatree
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set matrees [lindex $ranmatree [rand [llength $ranmatree]]]
		putserv "PRIVMSG $chan :$matrees"
	}
}

##  nyanyi  ##
bind pubm - "* nyanyi *" nyanyi_speak
bind pubm - "* nyanyi" nyanyi_speak
set rannyanyi {
	"\001ACTION lagi batuk\001"
	"sakitnya tuh disini, di dalam hati ku... sakitnya tuh di sini, melihat kau selingkuh..."
	"nyanyi apa?"
	"\001ACTION ga bisa nyanyi, %nick ajarin ya\001"
	"\001ACTION lagi serek\001"
}

proc nyanyi_speak {nick uhost hand chan text} {
	global botnick rannyanyi
	if {![channel get $chan talk]} { return 0 }
	if {[string match -nocase "bisa *" [string tolower $text]] || [string match -nocase "* bisa *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match -nocase "bisa *" [string tolower $text]] || [string match -nocase "* bisa *" [string tolower $text]]} { return 0 }
		set nyanyis [lindex $rannyanyi [rand [llength $rannyanyi]]]
		regsub -all "%nick" $nyanyis $nick nyanyis
		putserv "PRIVMSG $chan :$nyanyis"
	}
}

##  brantem  ##
bind pubm - "* berantem *" brantem_speak
bind pubm - "* duel *" brantem_speak
set ranbrantem {
	"\001ACTION tuh cinta damai\001"
	"\001ACTION males berantem ma org cemen\001"
	"%nick berani nya sama cewek huh.."
}

proc brantem_speak {nick uhost hand chan text} {
	global botnick ranbrantem
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set brantems [lindex $ranbrantem [rand [llength $ranbrantem]]]
		regsub -all "%nick" $brantems $nick brantems
		putserv "PRIVMSG $chan :$brantems"
	}
}

##  stan  ##
bind pubm - "* setan *" stan_speak
bind pubm - "* kuntilanak *" stan_speak
bind pubm - "* setan" stan_speak
bind pubm - "* kuntilanak" stan_speak
set ranstan {
	"%nick gonderwo"
	"%nick tuyul"
	"%nick mulutnya mo monic tabok ya"
	"%nick buyutnya setan"
}

proc stan_speak {nick uhost hand chan text} {
	global botnick ranstan
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set stans [lindex $ranstan [rand [llength $ranstan]]]
		regsub -all "%nick" $stans $nick stans
		putserv "PRIVMSG $chan :$stans"
	}
}

##  liat  ##
bind pubm - "* liat *" liat_speak
bind pubm - "* lihat *" liat_speak
set ranliat {
	"\001ACTION ga lihat\001"
	"emang kenapa?"
}
set liatvak {
	"ngapain %nick cari² ayank monic"
	"\001ACTION liat, tapi ga mau ngasih tau %nick\001"
}
proc liat_speak {nick uhost hand chan text} {
	global botnick ranliat liatvak
	if {![channel get $chan talk]} { return 0 }
	if {[string match "punya *" [string tolower $text]] || [string match "* punya *" [string tolower $text]] || [string match "pnya *" [string tolower $text]] || [string match "* pnya *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "*pernah*" [string tolower $text]] || [string match "*nenen*" [string tolower $text]] || [string match "*bosen*" [string tolower $text]] || [string match "*bosan*" [string tolower $text]]} { return 0 }
		if {[lindex $text 0] == "liat" && [llength $text] == 2} {
			putserv "PRIVMSG $chan :liat apa?"
		}
		if {[lindex $text 0] == "lihat" && [llength $text] == 2} {
			putserv "PRIVMSG $chan :lihat apa?"
		}
		if {[string match -nocase "*vaksin*" [string tolower $text]]} {
			set lvaks [lindex $liatvak [rand [llength $liatvak]]]
			regsub -all "%nick" $lvaks $nick lvaks
			putserv "PRIVMSG $chan :$lvaks"
		} else {
			if {[llength $text] == 2} { return 0 }
			set liats [lindex $ranliat [rand [llength $ranliat]]]
			regsub -all "%nick" $liats $nick liats
			putserv "PRIVMSG $chan :$liats"
			putserv "PRIVMSG $chan :$nick mau nagih utang ya"
		}
	}
}

##  ktau  ##
bind pubm - "* tau *" ktau_speak
bind pubm - "* tau" ktau_speak

proc ktau_speak {nick uhost hand chan text} {
	global botnick
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "*baru*" [string tolower $text]] || [string match "*malu*" [string tolower $text]] || [string match "*kasih*" [string tolower $text]] || [string match "*ksih*" [string tolower $text]] || [string match "*dari mana*" [string tolower $text]] || [string match "udah *" [string tolower $text]] || [string match "* udah *" [string tolower $text]] || [string match "dah *" [string tolower $text]] || [string match "* dah *" [string tolower $text]]} { return 0 }
		if {[string match -nocase "ga tau *" [string tolower $text]] || [string match "* ga tau *" [string tolower $text]] || [string match -nocase "ga tahu *" [string tolower $text]] || [string match "* ga tahu *" [string tolower $text]]} { return 0 }
		if {$nick == "Vaksin"} {
			putserv "PRIVMSG $chan :tau dong"
			return 0
		}
		putserv "PRIVMSG $chan :tau dong"
		putserv "PRIVMSG $chan :\001ACTION ga kayak $nick bolot\001"
	}
}

##  cuekin  ##
bind pubm - "* dicuekin *" cuekin_speak

proc cuekin_speak {nick uhost hand chan text} {
	global botnick
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		putserv "PRIVMSG $chan :sukurin"
	}
}

##  nungging  ##
bind pubm - "* nungging *" nungging_speak
bind pubm - "* nungging" nungging_speak
bind pubm - "nungging *" nungging_speak
set rannungging {
	"\001ACTION lagi males\001"
	"%nick aja sendiri yg nungging"
	"emang monic mo diapain sama %nick?"
	"tapi monic jangan diapa²in ya"
	"pantat monic lagi bisulan tauu..."
}

proc nungging_speak {nick uhost hand chan text} {
	global botnick rannungging
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "mau *" [string tolower $text]] || [string match "* mau *" [string tolower $text]]} { return 0 }
		set nunggings [lindex $rannungging [rand [llength $rannungging]]]
		regsub -all "%nick" $nunggings $nick nunggings
		putserv "PRIVMSG $chan :$nunggings"
	}
}

##  bisa ga  ##
bind pubm - "* bisa ga *" bisa_speak
bind pubm - "* bisa gak *" bisa_speak
bind pubm - "* bisa ngga *" bisa_speak
bind pubm - "* bisa nggak *" bisa_speak
bind pubm - "* bisa ga" bisa_speak
bind pubm - "* bisa gak" bisa_speak
bind pubm - "* bisa ngga" bisa_speak
bind pubm - "* bisa nggak" bisa_speak

proc bisa_speak {nick uhost hand chan text} {
	global botnick
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "* ngitung *" [string tolower $text]] || [string match "* hitung *" [string tolower $text]] || [string match "* gara2 *" [string tolower $text]] || [string match "* gara² *" [string tolower $text]]} { return 0 }
		putserv "PRIVMSG $chan :\001ACTION ga bisa\001"
	}
}

##  kenal  ##
bind pubm - "* kenal *" kenal_speak
set rankenal {
	"\001ACTION ga kenal\001"
	"\001ACTION males kenalan sama org jelek\001"
	"ga kenal, males juga monic kenal sama dia"
}
set ranlamkenal {
	"salam kenal juga %nick"
	"iya sama² %nick"
}

proc kenal_speak {nick uhost hand chan text} {
	global rankenal ranlamkenal
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "*males*" [string tolower $text]]} { return 0 }
		if {[string match -nocase "*vaksin*" [string tolower $text]]} {
			putserv "PRIVMSG $chan :kenal dong, kan ayank monic"
			putserv "PRIVMSG $chan :$nick ngapain nanya², $nick naksir ya"
			return 0
		}
		if {[string match "*salam*" [string tolower $text]]} {
			set lamkenals [lindex $ranlamkenal [rand [llength $ranlamkenal]]]
			regsub -all "%nick" $lamkenals $nick lamkenals
			putserv "PRIVMSG $chan :$lamkenals"
			return 0
		}
		set kenals [lindex $rankenal [rand [llength $rankenal]]]
		putserv "PRIVMSG $chan :$kenals"
	}
}

##  kenalan  ##
bind pubm - "* kenalan *" kenalan_speak
set rankenalan {
	"17 F Jkt"
	"16 cewek Makassar"
	"lupa umur nya brp"
	"lagi males kenalan"
}

proc kenalan_speak {nick uhost hand chan text} {
	global botnick rankenalan
	if {![channel get $chan talk]} { return 0 }
	if {[string match "klo *" [string tolower $text]] || [string match "* klo *" [string tolower $text]] || [string match "kalo *" [string tolower $text]] || [string match "* kalo *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set kenalans [lindex $rankenalan [rand [llength $rankenalan]]]
		putserv "PRIVMSG $chan :\001ACTION $kenalans\001"
	}
}

##  asl  ##
bind pubm - "* asl *" asl_speak
bind pubm - "* asl" asl_speak
set ranasl {
	"17 F Jkt"
	"16 cewek Makassar"
	"lupa umur nya brp"
	"lagi males kenalan"
}

proc asl_speak {nick uhost hand chan text} {
	global botnick ranasl
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set asls [lindex $ranasl [rand [llength $ranasl]]]
		putserv "PRIVMSG $chan :$asls"
	}
}

bind pubm - "* rumah *" drmah_speak
bind pubm - "* rumahnya *" drmah_speak
set randrmah {
	"%nick mau ngapelin monic ya?"
	"di mana aja boleh"
}

proc drmah_speak {nick uhost hand chan text} {
	global botnick randrmah
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "dimana *" [string tolower $text]] || [string match "* dimana *" [string tolower $text]] || [string match "* dimana" [string tolower $text]]} {
			set drmahs [lindex $randrmah [rand [llength $randrmah]]]
			regsub -all "%nick" $drmahs $nick drmahs
			putserv "PRIVMSG $chan :$drmahs"
		}
	}
}

##  pergi  ##
bind pubm - "* pergi *" prgi_speak
bind pubm - "* jalan *" prgi_speak
bind pubm - "* jalan2 *" prgi_speak
bind pubm - "* jalan² *" prgi_speak
set ranprgi {
	"ga mau ah, %nick kere cih"
	"acikkkkkkkk, monic mo diajak ke mall ya"
	"mo kemana emangnya"
	"%nick mau traktir monic ya"
}

proc prgi_speak {nick uhost hand chan text} {
	global botnick ranprgi
	if {![channel get $chan talk]} { return 0 }
	if {[string match "*kemana*" [string tolower $text]] || [string match "*jauh*" [string tolower $text]]} { return 0 } 
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set prgis [lindex $ranprgi [rand [llength $ranprgi]]]
		regsub -all "%nick" $prgis $nick prgis
		putserv "PRIVMSG $chan :$prgis"
	}
}

##  betul  ##
bind pubm - "* masa *" msa_speak
set ranmsa {
	"iya"
	"hu'uh"
	"ga percaya ya udah"
}

proc msa_speak {nick uhost hand chan text} {
	global botnick ranmsa
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set msas [lindex $ranmsa [rand [llength $ranmsa]]]
		putserv "PRIVMSG $chan :$msas"
	}
}

##  sirik  ##
bind pubm - "sirik *" sirik_speak
bind pubm - "* sirik *" sirik_speak
set ransirik {
	"ga kok"
	"ah itu perasaan %nick aja"
	"ngapain juga sirik dama orang jelek"
}

proc sirik_speak {nick uhost hand chan text} {
	global botnick ransirik
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set msirik [lindex $ransirik [rand [llength $ransirik]]]
		regsub -all "%nick" $msirik $nick msirik
		putserv "PRIVMSG $chan :$msirik"
	}
}
##  sirik  ##
bind pubm - "sirik *" sirik_speak
bind pubm - "* sirik *" sirik_speak
set ransirik {
	"ga kok"
	"ah itu perasaan %nick aja"
	"ngapain juga sirik dama orang jelek"
	"ga la yau"
}

proc sirik_speak {nick uhost hand chan text} {
	global botnick ransirik
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "elu *" [string tolower $text]] ||[string match "* elu *" [string tolower $text]]} {
			set msirik [lindex $ransirik [rand [llength $ransirik]]]
			regsub -all "%nick" $msirik $nick msirik
			putserv "PRIVMSG $chan :$msirik"
		}
	}
}

##  betul  ##
bind pubm - "* betul *" btul_speak
bind pubm - "* bener *" btul_speak
bind pubm - "* beneran *" btul_speak
set ranbtul {
	"iya"
	"hu'uh"
	"ga percaya ya udah"
}

proc btul_speak {nick uhost hand chan text} {
	global botnick ranbtul
	if {![channel get $chan talk]} { return 0 }
	if {[string match "*bener mon*" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "sepi *" [string tolower $text]] || [string match "* sepi *" [string tolower $text]] || [string match "suka *" [string tolower $text]] || [string match "* suka *" [string tolower $text]] || [string match "beneran *" [string tolower $text]] || [string match "* beneran *" [string tolower $text]]} { return 0 }
		set btuls [lindex $ranbtul [rand [llength $ranbtul]]]
		putserv "PRIVMSG $chan :$btuls"
	}
}

##  bosen  ##
bind pubm - "* boring *" bosen_speak
bind pubm - "* bosen *" bosen_speak
bind pubm - "* bosan *" bosen_speak
set ranbosen {
	"%nick mendingan pijitin monic aja kalo lagi bosen, monic lagi pegel² nih xixixi..."
	"%nick main ke rumah monic aja kalo lagi bosen"
	"jalan² ke kuburan aja %nick kalo bosen"
	"%nick ngobrol sama monic aja mau ga?"
}
set fbosen {
	"%nick mendingan pijitin monic aja, monic lagi pegel² nih xixixi..."
	"%nick main ke rumah monic aja"
	"jalan² ke kuburan aja %nick"
	"%nick ngobrol sama monic aja mau ga?"
}

proc bosen_speak {nick uhost hand chan text} {
	global botnick ranbosen fbosen
	if {![channel get $chan talk]} { return 0 }
	set bosens [lindex $ranbosen [rand [llength $ranbosen]]]
	regsub -all "%nick" $bosens $nick bosens
	putserv "PRIVMSG $chan :$bosens"
}

##  tabok  ##
bind pubm - "* tabok *" tbok_speak
bind pubm - "* pukul *" tbok_speak
set rantbok {
	"%nick mau monic kebiri ya?"
	"kok %nick ja'at cih ma monic"
	"%nick ntar monic bilangin Vaksin lho"
}

proc tbok_speak {nick uhost hand chan text} {
	global botnick rantbok
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set tboks [lindex $rantbok [rand [llength $rantbok]]]
		regsub -all "%nick" $tboks $nick tboks
		putserv "PRIVMSG $chan :$tboks"
	}
}

##  game  ##
bind pubm - "* main game *" game_speak
set rangame {
	"\001ACTION lagi males \001"
	"males ah, yg lagi main ga level sama monic"
}

proc game_speak {nick uhost hand chan text} {
	global botnick rangame
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]] && [string match "* game *" [string tolower $text]]} {
		set games [lindex $rangame [rand [llength $rangame]]]
		putserv "PRIVMSG $chan :$games"
	}
}

##  mandi  ##
bind pubm - "mandi *" mndi_speak
bind pubm - "* mandi *" mndi_speak
bind pubm - "* mandi" mndi_speak
set ranmndi {
	"\001ACTION lagi males mandi \001"
	"%nick yg mandiin ya ;p"
	"\001ACTION udah mandi dong\001"
	"\001ACTION dah mandi tadi, %nick cium masih wangi kan?\001"
	"emang %nick ga liat rambut monic masih basah?"
}

proc mndi_speak {nick uhost hand chan text} {
	global botnick ranmndi
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "* bau *" [string tolower $text]] || [string match "mau ga *" [string tolower $text]] || [string match "* mau ga *" [string tolower $text]] || [string match "* mau ga" [string tolower $text]] || [string match "mau gak *" [string tolower $text]] || [string match "* mau gak *" [string tolower $text]] || [string match "* mau gak" [string tolower $text]] || [string match "udah *" [string tolower $text]] || [string match "* udah *" [string tolower $text]]} { return 0 }
		set mndis [lindex $ranmndi [rand [llength $ranmndi]]]
		regsub -all "%nick" $mndis $nick mndis
		putserv "PRIVMSG $chan :$mndis"
	}
}

##  sehat  ##
bind pubm - "* sehat *" sehat_speak
bind pubm - "* sehat" sehat_speak
bind pubm - "sehat *" sehat_speak
set ransehat {
	"sehat dunk, emang %nick otak nya kurang se ons"
	"\001ACTION sehat lahir dan batin %nick \001"
}

proc sehat_speak {nick uhost hand chan text} {
	global botnick ransehat
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set sehats [lindex $ransehat [rand [llength $ransehat]]]
		regsub -all "%nick" $sehats $nick sehats
		putserv "PRIVMSG $chan :$sehats"
	}
}

##  monyet  ##
bind pubm - "* monyet *" mnyet_speak
bind pubm - "* monyet" mnyet_speak
bind pubm - "* monyet lu *" mnyet_speak
bind pubm - "* lu monyet *" mnyet_speak
set ranmnyet {
	"%nick tuh yg kayak monyet"
	"ayank Vaksiiinnn... monic di bilang monyet tuh sama %nick :("
}

proc mnyet_speak {nick uhost hand chan text} {
	global botnick ranmnyet
	if {![channel get $chan talk]} { return 0 }
	if {[string match "monic *" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "* mon" [string tolower $text]]} {
		if {[lindex $text 0] == $botnick && [llength $text] < 1} {
			set mnyetss [lindex $ranmnyet [rand [llength $ranmnyet]]]
			regsub -all "%nick" $mnyetss $nick mnyetss
			putserv "PRIVMSG $chan :$mnyetss"
			return 0
		}
		set mnyets [lindex $ranmnyet [rand [llength $ranmnyet]]]
		regsub -all "%nick" $mnyets $nick mnyets
		putserv "PRIVMSG $chan :$mnyets"
	}
}

## ga di kasih ##
bind pubm - "* ga di kasih *" gaksih_speak
bind pubm - "* ga di kasih" gaksih_speak
bind pubm - "* gak di kasih *" gaksih_speak
bind pubm - "* gak di kasih" gaksih_speak
set rangaksih {
	"dia mah ga usah"
	"ogah"
}

proc gaksih_speak {nick uhost hand chan text} {
	global botnick rangaksih
	if {![channel get $chan talk]} { return 0 }
	if {[string match "monic *" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]]} {
		if {[string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]] || [string match "elu *" [string tolower $text]] || [string match "* elu *" [string tolower $text]] || [string match "* elu" [string tolower $text]] || [string match "kamu *" [string tolower $text]] || [string match "* kamu *" [string tolower $text]] || [string match "* kamu" [string tolower $text]]} { return 0 }
		set gaksihs [lindex $rangaksih [rand [llength $rangaksih]]]
		putserv "PRIVMSG $chan :$gaksihs"
	}
}

##  homo  ##
bind pubm - "* homo *" homo_speak
bind pubm - "* maho *" homo_speak
set ranhomo {
	"hmmm... ga enak nih ngomongnya"
	"kasih tau ga yaa..."
	"iya, %nick emang ga tau ??"
	"embeerrrr..."
	"hu'uh"
}
set ranhomovak {
	"dia mah normal, ga kayak %nick upnormal"
	"normal lah, emang nya situ"
}

proc homo_speak {nick uhost hand chan text} {
	global botnick ranhomo ranhomovak
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* kamu *" [string tolower $text]] || [string match "* tau *" [string tolower $text]] || [string match -nocase "tau *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "* kamu *" [string tolower $text]] || [string match "* tau *" [string tolower $text]]} { return 0 }
		if {[string match -nocase "*vaksin*" [string tolower $text]]} {
			set homovaks [lindex $ranhomovak [rand [llength $ranhomovak]]]
			regsub -all "%nick" $homovaks $nick homovaks
			putserv "PRIVMSG $chan :$homovaks"
			return 0
		}
		if {[string match "*lesbi*" [string tolower $text]] && [string match "* apa *" [string tolower $text]]} {
			putserv "PRIVMSG $chan :dia bisex tauu.."
			return 0
		} else {
			set homos [lindex $ranhomo [rand [llength $ranhomo]]]
			regsub -all "%nick" $homos $nick homos
			putserv "PRIVMSG $chan :$homos"
		}
	}
}

##  lesbi  ##
bind pubm - "* lesbi *" lesbi_speak
set ranlesbi {
	"hu`uh"
	"kasih tau ga yaa..."
	"embeerrrr..."
}

proc lesbi_speak {nick uhost hand chan text} {
	global botnick ranlesbi
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* apa *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "mon *" [string tolower $text]]} {
		if {[string match -nocase "*vaksin*" [string tolower $text]] || [string match "*monic*" [string tolower $text]] || [string match "* kamu *" [string tolower $text]] || [string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]] || [string match "* homo *" [string tolower $text]] || [string match "* maho *" [string tolower $text]]} { return 0 }
		set lesbis [lindex $ranlesbi [rand [llength $ranlesbi]]]
		putserv "PRIVMSG $chan :$lesbis"
	}
}

##  suara  ##
bind pubm - "* suara *" suara_speak
bind pubm - "* suara" suara_speak
set ransuara {
	"bagus kok, kuping %nick aja yang rusak"
}

proc suara_speak {nick uhost hand chan text} {
	global botnick ransuara
	if {![channel get $chan talk]} { return 0 }
	if {([string match "mon *" [string tolower $text]] || [string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]]) && [string match "*jelek*" [string tolower $text]]} {
		if {[string match -nocase "*vaksin*" [string tolower $text]] || [string match "*monic*" [string tolower $text]] || [string match "* kamu *" [string tolower $text]] || [string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]]} {
			set suaras [lindex $ransuara [rand [llength $ransuara]]]
			regsub -all "%nick" $suaras $nick suaras
			putserv "PRIVMSG $chan :$suaras"
		}
	}
}

##  jelekk  ##
bind pubm - "* jelek *" jlekk_speak
bind pubm - "* jelek" jlekk_speak
set ranjlekk {
	"%nick lebih jelek"
	"cakep kok, %nick aja yg rabun"
}
set ranujlek {
	"hu'uh"
	"jelek bingit"
}
set runjlk1 {
	"%sijlk1"
	"%sijlk2"
	"dua²nya jelek"
}

proc jlekk_speak {nick uhost hand chan text} {
	global botnick ranjlekk ranujlek runjlk1
	if {![channel get $chan talk]} { return 0 }
	if {[string match "mon *" [string tolower $text]] || [string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "monic *" [string tolower $text]] || [string match "* monic *" [string tolower $text]]} {
		if {[string match "suara *" [string tolower $text]] || [string match "* suara *" [string tolower $text]] || [string match "* suara" [string tolower $text]] || [string match "iya *" [string tolower $text]]} { return 0 }
		if {[string match -nocase "* monic jelek" [string tolower $text]] || [string match -nocase "monic lebih *" [string tolower $text]] || [string match -nocase "*vaksin*" [string tolower $text]] || [string match -nocase "*v*a*k*s*i*n*" [string tolower $text]]} {
			set monujlk [lindex $ranjlekk [rand [llength $ranjlekk]]]
			regsub -all "%nick" $monujlk $nick monujlk
			putserv "PRIVMSG $chan :$monujlk"
			return 0
		}
		if {[string match "ailie *" [string tolower $text]] || [string match "* ailie *" [string tolower $text]]} {
			putserv "PRIVMSG $chan :dia cantik kok"
			return 0
		}
		if {[string match "aku *" [string tolower $text]] || [string match "* aku *" [string tolower $text]] || [string match "gw *" [string tolower $text]] || [string match "* gw *" [string tolower $text]] || [string match "gue *" [string tolower $text]] || [string match "* gue *" [string tolower $text]] || [string match "gua *" [string tolower $text]] || [string match "* gua *" [string tolower $text]] || [string match -nocase "*vaksin*" [string tolower $text]]} {
			if {$nick == "ailie"} {
				putserv "PRIVMSG $chan :cantik"
				return 0
			}
			if {$nick == "Vaksin"} {
				putserv "PRIVMSG $chan :cakep dong"
				return 0
			} else {
				set ujleks [lindex $ranujlek [rand [llength $ranujlek]]]
				putserv "PRIVMSG $chan :$ujleks"
				return 0
			}
		}
		if {$nick == "Vaksin"} {
			if {[string match "* gw *" [string tolower $text]] || [string match "* gua *" [string tolower $text]] || [string match "* gue *" [string tolower $text]] || [string match -nocase "*vaksin*" [string tolower $text]]} {
				putserv "PRIVMSG $chan :cakep dong"
				return 0
			}
		}
		if {([lindex $text 0] == "yang" && [lindex $text 3] == "apa") || ([lindex $text 0] == "yg" && [lindex $text 3] == "apa")} {
			if {[string match "* gua *" [string tolower $text]] || [string match "* gue *" [string tolower $text]] || [string match "* gw *" [string tolower $text]]} {
				if {$nick == "Vaksin"} {
					putserv "PRIVMSG $chan :yang pasti bukan ayank Vaksin"
					return 0
				} else {
					putserv "PRIVMSG $chan :dua²nya"
					return 0
				}
			}
			set jlknick1 [lindex $text 2]
			set jlknick2 [lindex $text 4]
			set runjlk1s [lindex $runjlk1 [rand [llength $runjlk1]]]
			regsub -all "%sijlk1" $runjlk1s $jlknick1 runjlk1s
			regsub -all "%sijlk2" $runjlk1s $jlknick2 runjlk1s
			putserv "PRIVMSG $chan :$runjlk1s"
			return 0
		}
		if {([lindex $text 0] == "monic" && [lindex $text 1] == "jelek") || ([lindex $text 0] == "Monic" && [lindex $text 1] == "jelek") || ([lindex $text 0] == "monic" && [lindex $text 1] == "juga") || ([string match -nocase "*vaksin*" [string tolower $text]] || [string match "*kamu*" [string tolower $text]] || [string match "lu *" [string tolower $text]] || [string match "* lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]] || [string match "elu *" [string tolower $text]] || [string match "* elu *" [string tolower $text]] || [string match "* elu" [string tolower $text]] || [string match "loe *" [string tolower $text]] || [string match "* loe *" [string tolower $text]] || [string match "* loe" [string tolower $text]] || [string match "* jelek mon" [string tolower $text]])} {
			set jlekks [lindex $ranjlekk [rand [llength $ranjlekk]]]
			regsub -all "%nick" $jlekks $nick jlekks
			putserv "PRIVMSG $chan :$jlekks"
		} else {
			set ujleks [lindex $ranujlek [rand [llength $ranujlek]]]
			putserv "PRIVMSG $chan :$ujleks"
		}
	}
}

##  cari  ##
bind pubm - "di cari *" cari_speak
bind pubm - "* di cari *" cari_speak
bind pubm - "* dicariin *" cari_speak
bind pubm - "* di cari" cari_speak
bind pubm - "* dicariin" cari_speak
bind pubm - "dicariin *" cari_speak
set rancari {
	"dia mau bayar utang ya"
	"ah, ngapain orang jelek nyari-nyari monic"
	"\001ACTION males di cari sama orang pelit\001"
}
set vakcari "ok"

proc cari_speak {nick uhost hand chan text} {
	global botnick rancari vakcari
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match -nocase "*vaksin*" [string tolower $text]]} {
			putserv "PRIVMSG $chan :$vakcari"
		} else {
			set caris [lindex $rancari [rand [llength $rancari]]]
			putserv "PRIVMSG $chan :$caris"
		}
	}
}

##  matamu  ##
bind pubm - "mata mu *" matamu_speak
bind pubm - "* mata mu *" matamu_speak
bind pubm - "* mata mu" matamu_speak
bind pubm - "matamu *" matamu_speak
bind pubm - "* matamu *" matamu_speak
bind pubm - "* matamu" matamu_speak
set ranmatamu {
	"%nick mulutnya ga disekolahin ya"
	"%nick minta ditabok ya mulutnya"
}

proc matamu_speak {nick uhost hand chan text} {
	global botnick ranmatamu
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon" [string tolower $text]]} {
		set matamus [lindex $ranmatamu [rand [llength $ranmatamu]]]
		regsub -all "%nick" $matamus $nick matamus
		putserv "PRIVMSG $chan :$matamus"
	}
}


bind pubm - "* sepi *" sepi_speak
bind pubm - "* sepi" sepi_speak
set ransepi {
	"%nick pengen rame ya, di pasar sana."
	"bakar rumah %nick aja.. monic jamin rame dech"
	"emang kalo rame %nick mau ngapain?"
}

proc sepi_speak {nick uhost hand chan text} {
	global botnick ransepi
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set sepis [lindex $ransepi [rand [llength $ransepi]]]
		regsub -all "%nick" $sepis $nick sepis
		putserv "PRIVMSG $chan :$sepis"
	}
}

##  sayang  ##
bind pubm - "* sayang *" syang_speak
bind pubm - "* sayang" syang_speak
set ransyang {
	"%nick kirim duit 50 ribu donk.. nanti boleh panggil monic sayang deh"
	"\001ACTION juga sayang sama %nick\001"
}

proc syang_speak {nick uhost hand chan text} {
	global botnick ransyang
	if {![channel get $chan talk]} { return 0 }
	if {[string match "siapa *" [string tolower $text]] || [string match "* siapa *" [string tolower $text]] || [string match "* siapa" [string tolower $text]] || [string match "* gak " [string tolower $text]] || [string match "* gak" [string tolower $text]] || [string match "gak *" [string tolower $text]]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "lebih *" [string tolower $text]] || [string match "* lebih *" [string tolower $text]]} {
			putserv "PRIVMSG $chan :bodo amat"
			return 0
		}
		set syangs [lindex $ransyang [rand [llength $ransyang]]]
		regsub -all "%nick" $syangs $nick syangs
		putserv "PRIVMSG $chan :$syangs"
	}
}

##  asem  ##
bind pubm - "* asem" asem_speak
bind pubm - "* asem *" asem_speak
set ranasem {
	"keteknya %nick kali yg asem"
	"kalo asem ya + GULA aja.. kaya monic nich, maniez xixixi..."
}

proc asem_speak {nick uhost hand chan text} {
	global botnick ranasem
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set asems [lindex $ranasem [rand [llength $ranasem]]]
		regsub -all "%nick" $asems $nick asems
		putserv "PRIVMSG $chan :$asems"
	}
}

##  jahatt  ##
bind pubm - "* jahat *" jhatt_speak
bind pubm - "* jahat" jhatt_speak
bind pubm - "* jaat *" jhatt_speak
bind pubm - "* jaat" jhatt_speak
set ranjhatt {
	"%nick duluan sih"
	"ga kok"
}

proc jhatt_speak {nick uhost hand chan text} {
	global botnick ranjhatt
	if {![channel get $chan talk]} { return 0 }
	if {([string match "monic *" $text] && ![string match "*masa*" $text]) || ([string match "* monic *" $text] && ![string match "*masa*" $text]) || ([string match "mon *" $text] && ![string match "*masa*" $text]) || ([string match "* mon *" $text] && ![string match "*masa*" $text]) || ([string match "* mon" $text] && ![string match "*masa*" $text])} {
		if {[string match "jangan *" [string tolower $text]] || [string match "* jangan *" [string tolower $text]]} { return 0 }
		set jhatts [lindex $ranjhatt [rand [llength $ranjhatt]]]
		regsub -all "%nick" $jhatts $nick jhatts
		putserv "PRIVMSG $chan :$jhatts"
	}
}

##  imut  ##
bind pubm - "* imut *" imut_speak
bind pubm - "* imoet *" imut_speak
set ranimut {
	"%nick baru tau ya"
	"\001ACTION gitu lho \001"
}

proc imut_speak {nick uhost hand chan text} {
	global botnick ranimut
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set imuts [lindex $ranimut [rand [llength $ranimut]]]
		regsub -all "%nick" $imuts $nick imuts
		putserv "PRIVMSG $chan :$imuts"
	}
}

##  setuju  ##
bind pubm - "* setuju *" setuju_speak
bind pubm - "* setuju" setuju_speak
set ransetuju {
	"setuju aja deh"
	"\001ACTION mah terserah \001"
}

proc setuju_speak {nick uhost hand chan text} {
	global botnick ransetuju
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set setujus [lindex $ransetuju [rand [llength $ransetuju]]]
		putserv "PRIVMSG $chan :$setujus"
	}
}

##  siapa  ##
bind pubm - "* siapa *" siapa_speak
bind pubm - "* siapa" siapa_speak
set ransiapa {
	"siapa yaa..."
	"ga tau"
}
set ransiapavak {
	"ayank monic dong"
	"%nick ngapain nanya²"
}

proc siapa_speak {nick uhost hand chan text} {
	global botnick ransiapa ransiapavak
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "tau *" [string tolower $text]] || [string match "* tau *" [string tolower $text]] || [string match "* tau" [string tolower $text]] || [string match "*pacar*" [string tolower $text]] || [string match "*ajarin*" [string tolower $text]] || [string match "*ayank*" [string tolower $text]] || [string match "punya *" [string tolower $text]] || [string match "* punya *" [string tolower $text]] || [string match "*digodain*" [string tolower $text]] || [string match "*digangguin*" [string tolower $text]] || [string match "* kangen *" [string tolower $text]] || [string match -nocase "kangen *" [string tolower $text]]} { return 0 }
		if {[string match -nocase "*vaksin*" [string tolower $text]]} {
			set siapavaks [lindex $ransiapavak [rand [llength $ransiapavak]]]
			regsub -all "%nick" $siapavaks $nick siapavaks
			putserv "PRIVMSG $chan :$siapavaks"
			return 0
		}
		set siapas [lindex $ransiapa [rand [llength $ransiapa]]]
		putserv "PRIVMSG $chan :$siapas"
	}
}

##  kick  ##
bind pubm - "* kick *" kick_speak
bind pubm - "* tendang *" kick_speak
bind pubm - "* sepak *" kick_speak
set rankick {
	"jahat ih.. masa monic mau di tendang :("
	"berani kick monic, ntar mandul lho"
	"yang berani kick monic monet !!"
}

proc kick_speak {nick uhost hand chan text} {
	global botnick rankick
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set kicks [lindex $rankick [rand [llength $rankick]]]
		putserv "PRIVMSG $chan :$kicks"
	}
}

##  sore  ##
bind pubm - "* sore *" sore_speak
bind pubm - "sore *" sore_speak

set ransore {
	"selamat sore juga %nick"
	"sore %nick"
}

proc sore_speak {nick uhost hand chan text} {
	global botnick ransore
	if {![channel get $chan talk]} { return 0 }
	if {[string match -nocase "udah *" [string tolower $text]] || [string match "* udah *" [string tolower $text]]} { return 0 }
	if {[string match "* mon" [string tolower $text]] || [string match "* monic" [string tolower $text]]} {
		set sores [lindex $ransore [rand [llength $ransore]]]
		regsub -all "%nick" $sores $nick sores
		putserv "PRIVMSG $chan :$sores"
	}
}

##  malam  ##
bind pubm - "* malam *" mlm_speak
bind pubm - "* malem *" mlm_speak
bind pubm - "malam *" mlm_speak
bind pubm - "malem *" mlm_speak

set ranmlm {
	"selamat malam juga %nick"
	"malam %nick"
}

proc mlm_speak {nick uhost hand chan text} {
	global botnick ranmlm
	if {![channel get $chan talk]} { return 0 }
	if {[string match -nocase "udah *" [string tolower $text]] || [string match "* udah *" [string tolower $text]]} { return 0 }
	if {[string match "* mon" [string tolower $text]] || [string match "* monic" [string tolower $text]]} {
		set mlms [lindex $ranmlm [rand [llength $ranmlm]]]
		regsub -all "%nick" $mlms $nick mlms
		putserv "PRIVMSG $chan :$mlms"
	}
}

##  pagi  ##
bind pubm - "pagi *" pagi_speak
bind pubm - "* pagi *" pagi_speak
set ranpagi {
	"selamat pagi juga %nick"
	"pagi %nick"
}

proc pagi_speak {nick uhost hand chan text} {
	global botnick ranpagi
	if {![channel get $chan talk]} { return 0 }
	if {[string match -nocase "udah *" [string tolower $text]] || [string match "* udah *" [string tolower $text]]} { return 0 }
	if {[string match "* mon" [string tolower $text]] || [string match "* monic" [string tolower $text]]} {
		set pagis [lindex $ranpagi [rand [llength $ranpagi]]]
		regsub -all "%nick" $pagis $nick pagis
		putserv "PRIVMSG $chan :$pagis"
	}
}

##  siang  ##
bind pubm - "siang *" siang_speak
bind pubm - "* siang *" siang_speak
set ransiang {
	"selamat siang juga %nick"
	"siang %nick"
}

proc siang_speak {nick uhost hand chan text} {
	global botnick ransiang
	if {![channel get $chan talk]} { return 0 }
	if {[string match -nocase "udah *" [string tolower $text]] || [string match "* udah *" [string tolower $text]]} { return 0 }
	if {[string match "* mon" [string tolower $text]] || [string match "* monic" [string tolower $text]]} {
		set siangs [lindex $ransiang [rand [llength $ransiang]]]
		regsub -all "%nick" $siangs $nick siangs
		putserv "PRIVMSG $chan :$siangs"
	}
}


##  diamm  ##
bind pubm - "* diam *" diamm_speak
bind pubm - "* brisik *" diamm_speak
bind pubm - "* berisik *" diamm_speak
bind pubm - "* diem *" diamm_speak
bind pubm - "* diam" diamm_speak
bind pubm - "* brisik" diamm_speak
bind pubm - "* berisik" diamm_speak
bind pubm - "* diem" diamm_speak
set randiamm {
  "%nick ga usah sirik deh"
  "terserah monic dong, yang ketik monic kok" 
}

proc diamm_speak {nick uhost hand chan text} {
	global botnick randiamm
	if {![channel get $chan talk]} { return 0 }
	if {[string match "monic *" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]]} {
		if {[string match "* aku *" [string tolower $text]] || [string match "* gua *" [string tolower $text]] || [string match "* saya *" [string tolower $text]] || [string match "lu *" [string tolower $text]] || [string match "* lu" [string tolower $text]] || [string match "elu *" [string tolower $text]] || [string match "* elu" [string tolower $text]] || [string match "bisa *" [string tolower $text]] || [string match "* bisa *" [string tolower $text]]} { return 0 }
		set diamms [lindex $randiamm [rand [llength $randiamm]]]
		regsub -all "%nick" $diamms $nick diamms
		putserv "PRIVMSG $chan :$diamms"
	}
}

##  bwel  ##
bind pubm - "* bawel *" bwel_speak
bind pubm - "* cerewet *" bwel_speak
bind pubm - "* crewet *" bwel_speak
bind pubm - "* bawel" bwel_speak
bind pubm - "* cerewet" bwel_speak
bind pubm - "* crewet" bwel_speak
set ranbwel {
	"\001ACTION kan ce wajar klo bawel \001"
	"biarin, yang ngetik monic kok"
}

proc bwel_speak {nick uhost hand chan text} {
	global botnick ranbwel
	if {![channel get $chan talk]} { return 0 }
	if {[string match "monic *" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]]} {
		set bwels [lindex $ranbwel [rand [llength $ranbwel]]]
		putserv "PRIVMSG $chan :$bwels"
	}
}

## iya ##
bind pubm - "* iya *" iya_speak
set raniya {
	"ok deh %nick"
	"%nick ga bohong kan?"
	"yang bener?"
}

proc iya_speak {nick uhost hand chan text} {
	global botnick raniya
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		if {[string match "tau *" [string tolower $text]] || [string match "* kan *" [string tolower $text]] || [string match "* tau *" [string tolower $text]] || [string match "* tau" [string tolower $text]] || [string match "*suara*" [string tolower $text]]} { return 0 }
		set raniyas [lindex $raniya [rand [llength $raniya]]]
		regsub -all "%nick" $raniyas $nick raniyas
		putserv "PRIVMSG $chan :$raniyas"
	}
}

## iya kan ##
bind pubm - "* iya kan *" iykan_speak
set raniyk {
	"iya aja deh"
	"mau nya %nick ?"
	"hu'uh"
	"iya kali"
}

proc iykan_speak {nick uhost hand chan text} {
	global botnick raniyk
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* mon?" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set raniyks [lindex $raniyk [rand [llength $raniyk]]]
		regsub -all "%nick" $raniyks $nick raniyks
		putserv "PRIVMSG $chan :$raniyks"
	}
}

## hitung ##
bind pubm - "* ngitung *" hitung_speak 
bind pubm - "* menghitung *" hitung_speak 
set ranhitung {
	"bisa dong"  
	"bisa, emang nya %nick blo'on"
}

proc hitung_speak {nick uhost hand chan text} {
	global botnick ranhitung
	if {![channel get $chan talk]} { return 0 }
	if {([string match "* mon *" [string tolower $text]] && ![string match "* bisa *" [string tolower $nick]]) || ([string match "* mon" [string tolower $text]] && ![string match "* bisa *" [string tolower $nick]]) || ([string match "* monic *" [string tolower $text]] && ![string match "* bisa *" [string tolower $nick]]) || ([string match "* monic" [string tolower $text]] && ![string match "* bisa *" [string tolower $nick]]) || ([string match "mon *" [string tolower $text]] && ![string match "* bisa *" [string tolower $nick]]) || ([string match "monic *" [string tolower $text]] && ![string match "* bisa *" [string tolower $nick]])} {
		set hitungs [lindex $ranhitung [rand [llength $ranhitung]]]
		regsub -all "%nick" $hitungs $nick hitungs
		putserv "PRIVMSG $chan :$hitungs"
	}
}

##  mesum  ##
bind pubm - "* ml *" mesum_speak
bind pubm - "* mesum *" mesum_speak
bind pubm - "* ml" mesum_speak
bind pubm - "* mesum" mesum_speak
bind pubm - "*some*" mesum_speak
set ranmesum {
	"sama %user aja gih"
	"ajakin %user aja gih"
}
set ranml {
	"sama %user aja gih"
	"ajakin %user aja gih"
}

proc mesum_speak {nick uhost hand chan text} {
	global botnick ranmesum ranml
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* gih *" [string tolower $text]] || [string match -nocase "*vaksin*" [string tolower $text]] || [string match "*monic mau*" [string tolower $text]]} { return 0 }
	set user [rnduser $nick $chan]
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]]} {
		if {[string match "*pengen*" [string tolower $text]] || [string match "* mau *" [string tolower $text]]} {
			if {[lindex $text 2] == "ml"} {
				set mntarget [lindex $text 0]
				putserv "PRIVMSG $chan :\001ACTION toel² $user, diajakin ml tuh sama $mntarget\001"
				return 0
			}
			if {[lindex $text 2] == "mesum"} {
				set mntarget [lindex $text 0]
				putserv "PRIVMSG $chan :\001ACTION toel² $user, diajakin mesum tuh sama $mntarget\001"
				return 0
			}
			if {[lindex $text 3] == "ml"} {
				set mntarget [lindex $text 1]
				putserv "PRIVMSG $chan :\001ACTION toel² $user, diajakin ml tuh sama $mntarget\001"
				return 0
			}
			if {[lindex $text 3] == "mesum"} {
				set mntarget [lindex $text 1]
				putserv "PRIVMSG $chan :\001ACTION toel² $user, diajakin mesum tuh sama $mntarget\001"
				return 0
			}
		}
		if {[string match "yuk *" [string tolower $text]] || [string match "* yuk *" [string tolower $text]] || [string match "* yuk" [string tolower $text]]} {
			if {[string match "ml *" [string tolower $text]] || [string match "* ml *" [string tolower $text]] || [string match "* ml" [string tolower $text]]} {
				set mls [lindex $ranml [rand [llength $ranml]]]
				regsub -all "%nick" $mls $nick mls
				regsub -all "%user" $mls $user mls
				putserv "PRIVMSG $chan :$mls"
			}
			if {[string match "mesum *" [string tolower $text]] || [string match "* mesum *" [string tolower $text]] || [string match "* mesum" [string tolower $text]]} {
				set mesums [lindex $ranmesum [rand [llength $ranmesum]]]
				regsub -all "%nick" $mesums $nick mesums
				regsub -all "%user" $mesums $user mesums
				putserv "PRIVMSG $chan :$mesums"
			}
		}
	}
}

##  sange  ##
bind pubm - "* sange *" sange_speak
bind pubm - "* napsu *" sange_speak
bind pubm - "* nafsu *" sange_speak
set ransange {
	"suruh sama %user aja"
	"tuh si %user lagi bengong"
	"\001ACTION toel² %user, tuh ada yg pengen"
}

proc sange_speak {nick uhost hand chan text} {
	global botnick ransange
	if {![channel get $chan talk]} { return 0 }
	set user [rnduser $nick $chan]
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set sanges [lindex $ransange [rand [llength $ransange]]]
		regsub -all "%user" $sanges $user sanges
		putserv "PRIVMSG $chan :$sanges"
	}
}

proc rnduser {nick chan} {
	global botnick
	set clist [chanlist $chan]
	if {([llength $clist] == 1)} {set clist "$clist her"}
	set pickeduser 0
	while {$pickeduser == 0} {
		set user [lindex $clist [rand [llength $clist]]]
		set pickeduser 1
		if {([string tolower $user] == [string tolower $botnick]) || ([string tolower $user] == [string tolower $nick])} { set pickeduser 0 }
	}
	set uhand [nick2hand $user $chan]
	return $user
}

bind pubm - "puasa *" puasa_speak
bind pubm - "* puasa *" puasa_speak
set monpuasa {
	"puasa dong"
	"ngapain %nick nanya²"
	"%nick mau tau aja"
}
proc puasa_speak { nick host hand chan text } {
	global monpuasa
	if {![channel get $chan talk]} { return 0 }
	if {[string match "* mon *" [string tolower $text]] || [string match "* mon" [string tolower $text]] || [string match "* monic *" [string tolower $text]] || [string match "* monic" [string tolower $text]] || [string match "mon *" [string tolower $text]] || [string match "monic *" [string tolower $text]]} {
		set monpuasas [lindex $monpuasa [rand [llength $monpuasa]]]
		regsub -all "%nick" $monpuasas $nick monpuasas
		putserv "PRIVMSG $chan :$monpuasas"
	}
}

## moooon ##
bind pubm - "*ooo*" kget_speak

set mkget {
	"%nick ga usah teriak² sih"
	"duh sampe kaget"
	"%nick kesurupan ya?"
}
set vkget {
	"iya ayank"
	"apa yank"
}
	
proc kget_speak {nick host hand chan text} {
	global botnick mkget vkget
	if {![channel get $chan talk]} { return 0 }
	if {[string first m $text] == 0} {
		if {$nick == "Vaksin"} {
			set vkgets [lindex $vkget [rand [llength $vkget]]]
			putserv "PRIVMSG $chan :$vkgets"
			return 0
		} else {
			set mkgets [lindex $mkget [rand [llength $mkget]]]
			regsub -all "%nick" $mkgets $nick mkgets
			putserv "PRIVMSG $chan :$mkgets"
		}
	}
}

## rek lagu ##
bind pubm n "* minta lagu *" lgu_speak
bind pubm n "minta lagu *" lgu_speak
bind pubm n "* rek lagu *" lgu_speak
bind pubm n "rek lagu *" lgu_speak
bind pub n flagu flood_lgu

set lgu {
	"!rek luka di sini"
	"!rek aku cuma punya hati"
	"!rek diantara bintang"
	"!rek pernah -.azmi"
	"!rek surat cinta untuk starla"
	"!rek give me one more change - vicky & elke"
	"!rek i love you so much - vicky & elke"
	"!rek You Raise Me Up - Josh Groban"
	"!rek Sometimes When We Touch - Dan_Hill"
	"!rek Somewhere Between - The Tumbleweeds"
	"!rek amazing grace"
	"!rek forever tonight - Peter_Cetera & Crystal Bernard"
	"!rek Rest Your Love On Me - Bee-Gees "
}

proc lgu_speak {nick host hand chan text} {
	global lgu
	if {![channel get $chan talk]} { return 0 }
	if {[string match "monic *" [string tolower $text]] || [string match "* mon" [string tolower $text]]} {
		set lgus [lindex $lgu [rand [llength $lgu]]]
		putserv "PRIVMSG $chan :$lgus"
	}
}

proc flood_lgu {nick host hand chan text} {
	global lgu
	if {![channel get $chan talk]} { return 0 }
	foreach lg $lgu {
		putserv "PRIVMSG $chan :$lg"
	}
}

		