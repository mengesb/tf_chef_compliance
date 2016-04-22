{
  "fqdn": "${host}.${domain}",
  "chef-compliance": {
    "configuration": {
      "compliance_fqdn": "${host}.${domain}",
      "ssl": {
        "certificate": "${cert}",
        "certificate_key": "${cert_key}"
      }
    }
  },
  "chef-ingredient": {
    "accept_license: true
  },
  "firewall": {
    "allow_established": true,
    "allow_ssh": true
  },
  "system": {
    "short_hostname": "${host}",
    "domain_name": "${domain}",
    "manage_hostsfile": true
  },
  "tags": []
}

