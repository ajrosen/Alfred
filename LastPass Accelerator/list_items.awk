BEGIN {
    FS = "/"
    print "{ \"items\": [ {}"
}

{
    getline id < "id"
    getline user < "user"
    getline path < "path"
    getline url < "url"

    if ((url == "http://group") || (url == "http://sn")) {
	next
    }

    x = tolower(arg)

    if ((tolower(user) ~ x) || (tolower(path) ~ x) || (tolower(url) ~ x)) {
	printf(",{ \"uid\": \"%s\", \"title\": \"%s\", \"subtitle\": \"%s\", \"arg\": \"%s\" }\n",
	       id, path, user, id)
    }
}

END {
    print "] }"
}
