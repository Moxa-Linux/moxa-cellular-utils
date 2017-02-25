#         [1] 3gpp - AT&T Mobile
#                 APN: 'internet'
#                 PDP type: 'ipv4-or-ipv6
#                 Auth: 'none'

BEGIN {
    i = 0
}
$2 == "3gpp" {
    i++
    gsub("\\[|\\]", "", $1)
    pdp[i]["id"] = $1
    pdp[i]["apn"] = ""
    pdp[i]["type"] = ""
}
$1 == "APN:" {
    gsub("'", "", $0)
    pdp[i]["apn"] = substr($0, index($0,$2))
}
$1 == "PDP" && $2 == "type:" {
    gsub("'", "", $0)
    pdp[i]["type"] = substr($0, index($0,$3))
    if (pdp[i]["type"] == "ipv4")
        pdp[i]["type"] = "IP"
    else if (pdp[i]["type"] == "ipv6")
        pdp[i]["type"] = "IPV6"
    else if (pdp[i]["type"] == "ipv4-or-ipv6")
        pdp[i]["type"] = "IPV4V6"
}
END {
    for (j in pdp) {
        printf "%s,%s,%s\n",pdp[j]["id"],pdp[j]["apn"],pdp[j]["type"]
    }
}
