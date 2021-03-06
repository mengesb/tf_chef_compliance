tf_chef_compliance CHANGELOG
========================

This file is used to list changes made in each version of the tf_chef_compliance Terraform plan.

v0.1.6 (2016-05-25)
-------------------
- [Brian Menges] - Add `audit` cookbook to [chef-cookbooks.sh](files/chef-cookbooks.sh)

v0.1.5 (2016-05-25)
-------------------
- [Brian Menges] - Correct `accept_license` in [attributes-json.tpl](files/attributes-json.tpl)
- [Brian Menges] - Remove legacy `touch .license.accepted` remote-exec

v0.1.4 (2016-05-25)
-------------------
- [Brian Menges] - Correct [CHANGELOG.md](CHANGELOG.md)
- [Brian Menges] - Update `accept_license` variable type, handling and documentation
- [Brian Menges] - Add `"accept_license": "${license}",` to [attributes-json.tpl](files/attributes-json.tpl)

v0.1.3 (2016-05-25)
-------------------
- [Brian Menges] - Spruce up [CONTRIBUTING.md](CONTRIBUTING.md)

v0.1.2 (2016-04-25)
-------------------
- [Brian Menges] - Fix count on provisioner
- [Brian Menges] - Implement break on license not accepted in `null_resource.compliance-prep`

v0.1.1 (2016-04-25)
-------------------
- [Brian Menges] - Remove `boolean` map
- [Brian Menges] - Update `accept_license`. true = `1`, false = `0`

v0.1.0 (2016-04-25)
-------------------
- [Brian Menges] - Add variable `accept_license` and map `boolean`
- [Brian Menges] - `accept_license` defaults to `false` forcing explicit acceptance
- [Brian Menges] - Update some comments in plan
- [Brian Menges] - Remove unnecessary template write
- [Brian Menges] - Remove unnecessary global Chef Server <-> Compliance SG allow
- [Brian Menges] - Documentation updates

v0.0.7 (2016-04-22)
-------------------
- [Brian Menges] - Removed `accept_license` in `attribtes-json.tpl`
- [Brian Menges] - Accepting the licence via different means

v0.0.6 (2016-04-22)
-------------------
- [Brian Menges] - Adding `accept_license` to `attribtes-json.tpl`

v0.0.5 (2016-04-22)
-------------------
- [Brian Menges] - Fix prep resource

v0.0.4 (2016-04-22)
-------------------
- [Brian Menges] - Add [chef-cookbooks.sh](files/chef-cookbooks.sh) script
- [Brian Menges] - Add `compliance_prep` resource to upload required cookbooks

v0.0.3 (2016-04-22)
-------------------
- [Brian Menges] - Fixed missing `cert_key` variable in template call

v0.0.2 (2016-04-22)
-------------------
- [Brian Menges] - Remove Route53
- [Brian Menges] - Commented out sg rules regarding complaince and server, likely not necessary
- [Brian Menges] - Commented out variable `chef_sg`
- [Brian Menges] - [CHANGELOG.md](CHANGELOG.md) reformatting
- [Brian Menges] - Added provisioner in [main.tf](main.tf)
- [Brian Menges] - Added variable `client_version`
- [Brian Menges] - Added variable `log_to_file`
- [Brian Menges] - Added variable `public_ip`
- [Brian Menges] - Added variable `root_delete_terminiation`
- [Brian Menges] - Added variable `wait_on`

v0.0.1 (2016-04-01)
-------------------
- [Brian Menges] - initial commit

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
