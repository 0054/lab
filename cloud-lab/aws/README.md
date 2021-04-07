# AWS


## aws cli

### install aws-cli

качаем [отсюда](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html) 
затем распаковываем и устанавливаем например так:
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
or
```
pip3 install awscli
```

### autocompletion for aws cli


ищем где у нас установлен aws_completer `which aws_completer`
и добавляем в ~/.bashrc строку
```
complete -C /usr/local/bin/aws_completer aws
```
apply configs `source ~/.bashrc`

### aws configure
```
$ aws configure
AWS Access Key ID [None]: ABCDABCDABCDABCD
AWS Secret Access Key [None]: lkmcpwoeipOMDLKejnfpwnp
Default region name [None]: eu-central-1
Default output format [None]: json
```
```
ls ~/.aws/
config  credentials
```

### commands

```
$ aws ec2 create-key-pair --key-name 'mykey' --query 'KeyMaterial' --output text > my_key.pem
```

find the most resent ubuntu image
```
$ aws ec2 describe-images --filters Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64* --query 'Images[*].[ImageId,CreationDate]' --output text | sort -k2 -r | head -n1
ami-006557c7113ab40b6   2021-02-01T19:00:29.000Z
```

show vpcs
```
aws ec2 describe-vpcs
Vpcs:
- CidrBlock: 172.31.0.0/16
  CidrBlockAssociationSet:
  - AssociationId: vpc-cidr-assoc-eff64a84
    CidrBlock: 172.31.0.0/16
    CidrBlockState:
      State: associated
  DhcpOptionsId: dopt-d3ea46b9
  InstanceTenancy: default
  IsDefault: true
  OwnerId: '427284937094'
  State: available
  VpcId: vpc-25238e4f
```
create/delete VPC
```
aws ec2 create-vpc --tag-specifications 'ResourceType=vpc, Tags=[{Key=Name,Value=VPC-TEST}]' --cidr-block 10.10.0.0/16
aws ec2 delete-vpc --vpc-id vpc-05b1b28f5580d7b4e
```
create subnets
```
aws ec2 create-subnet --vpc-id vpc-0560d93e153c131ab --cidr-block 10.10.1.0/24
```

## ECR

### aws login ecr

```
aws ecr get-login-password \
    --region <region> \
| docker login \
    --username AWS \
    --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com
```
