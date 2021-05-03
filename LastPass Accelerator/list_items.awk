##################################################
# Surround a string in quotes

function q(s) {
    return "\"" s "\""
}


##################################################
# Build a "mods" object

function mods(valid, retval) {
    retval = "," q("mods") ":{"

    for (m in modifiers) {
	retval = retval q(modifiers[m]) ":{" q("valid") ":" q(valid) "," q("subtitle") ":" q(subtitle) "},"
    }

    return retval "}"
}


##################################################
# Initialization

BEGIN {
    FS = ","
    split("command,control,function,shift", modifiers)
    x = tolower(arg)
    n = 0
}


##################################################
# Process all records

{
    # Get id, username, path, and url
    split($0, line)
    id = line[1] ; delete line[1]
    subtitle = "" ; for (b in line) { subtitle = subtitle line[b] }
    getline title < f_path
    getline url < f_url

    type = "password"
    a = id

    if (url == "http://group") {
	if (arg == title) { next }
	type = "group"
	a = title
	id = 0
    } else {
	if ((ENVIRON["ShowFolders"] == "true") && (length(arg) == 0)) { next }
    }

    if (url == "http://sn") {
	type = "sn"
	subtitle = "Secure Note"
    }

    icon = type ".png"

    # Filter matches
    if ((tolower(title) ~ x) || (tolower(subtitle) ~ x) || (tolower(url) ~ x)) {
	i = ",{"
	i = i q("title") ":" q(title)
	if (ENVIRON["ShowFolders"] != "true") { i = i "," q("uid") ":" q(id) }
	i = i "," q("subtitle") ":" q(subtitle)
	i = i "," q("arg") ":" q(a)
	i = i "," q("icon") ":{" q("path") ":" q(icon) "}"
	i = i "," q("variables") ":{" q("type") ":" q(type) "," q("lpitem") ":" q(id) "}"
	i = i "," q("autocomplete") ":" q(title)
	if ((type == "group") || (type == "sn")) { i = i mods("false") }
	i = i "}"

	items[n++] = i
    }
}


##################################################
# Print it

END {
    for (i in items) { print items[i] }
}
