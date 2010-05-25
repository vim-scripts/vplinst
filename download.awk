BEGIN {
	type = ""
	basedir = ENVIRON["BASEDIR"]
	if (basedir == "") {
		basedir = "~/.vim"
	}
	FS = "[ \t]*[=:][ \t]*"
}

#
# Lines that have no meaning (for now).
#

# Comments.
/^[ \t]*#.*$/			{next}

# Blank lines.
/^[ \t]*$/			{next}

# Some tags (not implemented yet).
/^[ \t]name[ \t]*:[ \t]*/	{next}
/^[ \t]version[ \t]*:[ \t]*/	{next}
/^[ \t]url[ \t]*:[ \t]*/	{next}

#
# Lines with meaning.
#

# basedir variable.
/^[ \t]*basedir[ \t]*=/ {
	basedir = $2
	next
}

# A syntax-file block.
/^[ \t]*syntax[ \t]*{[ \t]*$/ {
	type = "syntax"
	next
}

# A plugin-file block.
/^[ \t]*plugin[ \t]*{[ \t]*$/ {
	type = "plugin"
	next
}

# Script id.  The id of the script homepage in the vim's site, as it appear in a
# vim plugin homepage URL.
/^[ \t]*script[ \t]*id[ \t]*:[ \t]*/ {
	script_id = $2
	next
}

# Src id.  The id of a file in a script homepage, as it is in the link of the
# file, in a vim plugin homepage.
/^[ \t]*src[ \t]*id[ \t]*:[ \t]*/ {
	src_id = $2
	next
}

# End of a block.  When a block finishes, we (theoretically) have all
# information we need, then we just call the "setup.sh" script passing all
# parameters as necessary.
/^[ \t]*}[ \t]*$/ {
	cmd = "sh setup.sh " type " " script_id " " src_id " " basedir
	system(cmd)
	type = ""
	next
}

# Anything other than syntax rules above is considered error.
/.*/ {
	print "Syntax error at line " NR ". Pattern not recognized:\n" $0 > "/dev/stderr"
	exit
}
