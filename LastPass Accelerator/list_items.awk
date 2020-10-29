BEGIN {
    FS = "/"
    print "{ \"items\": [ {}"
}

{
    getline id < "id"
    getline user < "user"

    printf(",{ \"uid\": \"%s\", \"title\": \"%s\", \"arg\": \"%s\", \"subtitle\": \"%s\", \"autocomplete\": \"%s\", \"match\": \"%s\" }\n",
	   id, $0, id, user, $NF, $NF)
}

END {
    print "] }"
}
