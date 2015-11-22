#!/bin/bash
dir=~/bin/.darkmode;
dir_prof=$dir/profiles;
prof_prefix=profile_;
perl_script=$dir/darkmode.pl;

function change_profile {
	if [ $# != 1 ]; then
		echo "1 argument expected: profile name" >&2;
		exit 1;
	fi
	list_str=`gconftool-2 --get /apps/gnome-terminal/global/profile_list`;
	# If no directory with exported profiles exists, create one.
	if [ ! -e $dir_prof ]; then
		mkdir $dir_prof;
		# Get list of existing profiles and remove surrounding brackets
		list_str=`gconftool-2 --get /apps/gnome-terminal/global/profile_list`;
		list_str=`echo ${list_str::-1} | cut -c 2-`;
		# Turn list string into array
		profile_array=`echo $list_str | tr "," "\n"`;
		# For every profile, create a file which can be loaded by `gconftool-2 --load`
		for p in $profile_array
		do
			file=$dir_prof/$prof_prefix$p;
			gconftool-2 --dump "/apps/gnome-terminal/profiles/$p" | sed "s,profiles/$p,profiles/Default,g" >$file;
		done
		echo "Profiles exported to $dir_prof/";
	fi
	if [ ! `grep $1 <<< $list_str` ]; then
		echo "Argument is not a valid profile, current profiles are $list_str" >&2;
		exit 1;
	fi
	gconftool-2 --load $dir_prof/$prof_prefix$1;
	gconftool-2 --set --type string --set "/apps/gnome-terminal/profiles/Default/visible_name" "Default";
}

if [ ! -e $dir ]; then mkdir $dir; fi;
echo 'my $fn = "/home/tim/.atom/config.cson";
$/=undef;
open(FILE,$fn) or die "Failed to open $fn for reading: $!";
$_ = <FILE>;
if($ARGV[0] eq "on"){
	$_=~s/themes: \[(.*)\]/themes: \[\n      "one-light-ui"\n      "atom-light-syntax"\n    \]/s;
}else{
	$_=~s/themes: \[(.*)\]/themes: \[\n      "one-dark-ui"\n      "atom-darl-syntax"\n    \]/s;
}
close(FILE);
open(FILE,">",$fn) or die "Failed to open $fn for writing: $!";
print FILE $_;
close(FILE);' >$perl_script
# Invert screen colours
xcalib -i -a;
darkmode_file=$dir/status;
if [ ! -e $darkmode_file ]; then
	echo 0 >$darkmode_file;
fi
darkmode=`cat $darkmode_file`;
if [ $darkmode == 0 ]; then # Turn Dark mode ON
	# Change Atom theme settings to light
	perl $perl_script on;
	# Change gnome terminal profile to Light
	change_profile Profile0;
	echo 1 >$darkmode_file;
else # Turn Dark mode OFF
	# Change Atom theme settings to dark
	perl $perl_script off;
	# Change gnome terminal profile to Default
	change_profile Default;
	echo 0 >$darkmode_file;
fi
