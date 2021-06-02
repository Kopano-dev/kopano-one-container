#!/bin/bashens	

cfgdir=${cfgdir:-/etc/kopano}
tpldir=${tpldir:-/etc/kopano.in}

# copy config file if it does not yet exist
ensure_config(){
	cfgfile=${1?Undefined config file}
	if [ ! -e "$cfgdir/$cfgfile" ]; then
		cp "$tpldir/$cfgfile" "$cfgdir/$cfgfile"
	fi
}

ensure_dir(){
	dircheck=${1?Undefined folder}
	if [ ! -d "$dircheck" ]; then
		mkdir -p "$dircheck"
	fi
}