#!/bin/sh

#
# Global variables.
#

# Base directory where to install extensions.
basedir=

# Temporary file where to store the plugin file.
tmpfile=

# The actual script name.
destfile=

#
# Functios.
#

# Main function.
main () {
	local type script_id src_id
	type="$1"
	script_id="$2"
	src_id="$3"

	basedir="$4"

	download_file "${script_id}" "${src_id}"
	install_file "${type}"

	rm -f "${tmpfile}"
}


# Downloads a file. echo's the temporary file name and the real file name,
# separated by space. e.g.: /tmp/tmp.XXXX plugin.vba.
download_file () {
	local script_id src_id
	local page_url package_url
	local tmpline
	script_id="$1"
	src_id="$2"
	page_url="http://www.vim.org/scripts/script.php?script_id=${script_id}"
	package_url="http://www.vim.org/scripts/download_script.php?src_id=${src_id}"

	tmpfile=$(mktemp /tmp/tmp.XXXX)
	download "${page_url}" "${tmpfile}"

	tmpline=$(grep 'download_script\.php?src_id' "${tmpfile}" | head -1)
	destfile=$(echo "${tmpline}" | sed 's/^\([^>]*>\)\{2\}//' \
	    | sed 's/\(<[^>]*>\)\{2\}$//')

	rm "${tmpfile}"
	download "${package_url}" "${tmpfile}"
}


# Install a file. Uses either the install_syntax or the install_plugin
# functions.
install_file () {
	local type

	type="$1"

	case "${type}" in
	"syntax")
		install_syntax "${tmpfile}" "${destfile}"
		;;
	"plugin")
		install_plugin "${tmpfile}" "${destfile}"
		;;
	esac
}


# Install a syntax file.
install_syntax () {
	local tmpfile destfile
	local syntaxdir

	tmpfile="$1"
	destfile="$2"

	syntaxdir="${basedir}/after/syntax"
	mkdir -p "${syntaxdir}"

	echo mv "${tmpfile}" "${syntaxdir}/${destfile}"
	mv "${tmpfile}" "${syntaxdir}/${destfile}"
}


# Install a plugin.
install_plugin () {
	local tmpfile destfile
	tmpfile="$1"
	destfile="$2"

	case $(extension "${destfile}") in
	"vba")
		install_plugin_vba "${tmpfile}"
		;;
	"vim")
		install_plugin_vim "${tmpfile}" "${destfile}"
		;;
	"tgz")
		echo tar zxf "${tmpfile}" -C "${basedir}"
		;;
	"zip")
		unzip -o -d "${basedir}" "${tmpfile}"
		;;
	esac
}


# Install a plugin which extension is "vba", i. e., it is a vimball.  Used by
# the install_plugin function.
install_plugin_vba () {
	local tmpfile vimscript
	tmpfile="$1"
	vimscript=$(mktemp /tmp/tmp.XXXX)
	echo ":exec 'set runtimepath=${basedir},' . &runtimepath" > "${vimscript}"
	echo ':source %' >> "${vimscript}"
	echo ':quit' >> "${vimscript}"
	vim -s "${vimscript}" "${tmpfile}"
	rm "${vimscript}"
}


# Install a plugin which extension is "vim", i. e., it is a single file. Used by
# the install_plugin function.
install_plugin_vim () {
	local tmpfile destfile
	tmpfile="$1"
	destfile="$2"
	plugindir="${basedir}/plugin"
	mkdir -p "${plugindir}"
	mv "${tmpfile}" "${plugindir}/${destfile}"
}


# Given a filename, echo's its extension.
extension () {
	echo "$1" | awk -F. '{ print $NF }'
}

download () {
	local url target
	url="$1"
	target="$2"
	# TODO: allow uses of other tools besides wget
	wget -q -O "${target}" "${url}"
}

main "$@"
