# tf_chef_compliance
Terraform plan for adding Chef Compliance. Requires Chef Server

## Assumptions

* Requires:
  * AWS (duh!)
  * AWS subnet id
  * AWS VPC id
  * SSL certificate/key for created instance
* Uses a public IP and public DNS
* Creates default security group as follows:
  * 22/tcp: SSH
  * 443/tcp: HTTPS
  * 80/tcp: HTTP
* Understand Terraform and ability to read the source

## Supported OSes
All supported OSes are 64-bit and HVM (though PV should be supported)

* Ubuntu 12.04 LTS
* Ubuntu 14.04 LTS
* Ubuntu 16.04 LTS (pending)
* CentOS 6 (Default)
* CentOS 7 (pending)
* Others (here be dragons! Please see Map Variables)

## AWS

These resources will incur charges on your AWS bill. It is your responsibility to delete the resources.

## Setup

Create a local `terraform.tfvars` and populate with override values for variables listed. Once the plan run is complete, navigate to `https://host.domain.tld/` to accept the EULA and create the first administrative user and begin using the product.

## Input variables

### AWS variables

* `aws_access_key`: Your AWS key, usually referred to as `AWS_ACCESS_KEY_ID`
* `aws_flavor`: The AWS instance type. Default: `c3.xlarge`
* `aws_key_name`: The private key pair name on AWS to use (String)
* `aws_private_key_file`: The full path to the private kye matching `aws_key_name` public key on AWS
* `aws_region`: AWS region you want to deploy to. Default: `us-west-1`
* `aws_secret_key`: Your secret for your AWS key, usually referred to as `AWS_SECRET_ACCESS_KEY`
* `aws_subnet_id`: The AWS id of the subnet to use. Example: `subnet-ffffffff`
* `aws_vpc_id`: The AWS id of the VPC to use. Example: `vpc-ffffffff`

### tf_chef_compliance variables

* `allowed_cidrs`: The comma seperated list of addresses in CIDR format to allow SSH access. Default: `0.0.0.0/0`
* `chef_fqdn`: DNS address of the Chef Server
* `chef_org`: Chef organization to join to
* `chef_org_validator`: Path to validation PEM file for your chef organization
* `chef_sg`: Chef server security group
* `domain`: Server's basename. Default: `localdomain`
* `hostname`: Server's basename. Default: `compliance`
* `knife_rb`: Path to your `knife.rb` configuration file
* `r53`: Boolean determines if Route53 will be used or not. Default: `0`
* `r53_ttl`: Time to Live (TTL) setting for Route53 A record to be created. Default: `180`
* `r53_zone_id`: AWS Route53 Zone ID to add an A record for the server
* `r53_zone_internal_id`: AWS Route53 Internal Zone ID to add an A record for the server
* `server_count`: Server count. Default: `1`; DO NOT CHANGE!
* `ssl_cert`: Server SSL certificate in PEM format
* `ssl_key`: Server SSL certificate key
* `tag_description`: Text field tag 'Description'

### Map variables

The below mapping variables construct selection criteria

* `ami_map`: AMI selection map comprised of `ami_os` and `aws_region`
* `ami_usermap`: Default username selection map based off `ami_os`

The `ami_map` is a combination of `ami_os` and `aws_region` which declares the AMI selected. To override this pre-declared AMI, define

```
ami_map.<ami_os>-<aws_region> = "value"
```

Variable `ami_os` should be one of the following:

* centos6 (default)
* centos7
* ubuntu12
* ubuntu14
* ubuntu16

Variable `aws_region` should be one of the following:

* us-east-1
* us-west-2
* us-west-1 (default)
* eu-central-1
* eu-west-1
* ap-southeast-1
* ap-southeast-2
* ap-northeast-1
* ap-northeast-2
* sa-east-1
* Custom (must be an AWS region, requires setting `ami_map` and setting AMI value)

Map `ami_usermap` uses `ami_os` to look the default username for interracting with the instance. To override this pre-declared user, define

```
ami_usermap.<ami_os> = "value"
```

## Outputs

* `fqdn`: The fully qualified domain name of the instance
* `private_ip`: The private IP address of the instance
* `public_ip`: The public IP address of the instance
* `security_group_id`: The AWS security group id for this instance

## Contributors

* [Brian Menges](https://github.com/mengesb)

## Runtime sample

GIST for runtime has not yet been added. Check back later!

## Contributing

Please understand that this is a work in progress and is subject to change rapidly. Please be sure to keep up to date with the repo should you fork, and feel free to contact me regarding development and suggested direction

## `CHANGELOG`

Please refer to the [`CHANGELOG.md`](CHANGELOG.md)

## License

This is licensed under [the Apache 2.0 license](LICENSE).
