$ aws ec2 run-instances --image-id ami-cb5266fb --region us-west-2
A client error (OptInRequired) occurred when calling the RunInstances operation: In order to use this AWS Marketplace product you need to accept terms and subscribe. To do so please visit http://aws.amazon.com/marketplace/pp?sku=g95kdbra5uml4ccyv41bbg3z

$ open http://aws.amazon.com/marketplace/pp?sku=g95kdbra5uml4ccyv41bbg3z

$ aws ec2 create-security-group --group-name my-lb-group --description "for https load balancer" --region us-west-2
{
    "GroupId": "sg-88bea5ed"
}
$ aws ec2 authorize-security-group-ingress --group-id sg-88bea5ed --protocol tcp --port 80 --cidr 0.0.0.0/0 --region us-west-2
$ aws ec2 authorize-security-group-ingress --group-id sg-88bea5ed --protocol tcp --port 443 --cidr 0.0.0.0/0 --region us-west-2

$ aws ec2 run-instances --image-id ami-cb5266fb --security-group-ids sg-88bea5ed --subnet subnet-891ca3fe --region us-west-2 
{
    "OwnerId": "901416387788", 
    "ReservationId": "r-79486f75", 
    "Groups": [], 
    "Instances": [
        {
            "Monitoring": {
                "State": "disabled"
            }, 
            "PublicDnsName": null, 
            "KernelId": "aki-fc8f11cc", 
            "State": {
                "Code": 0, 
                "Name": "pending"
            }, 
            "EbsOptimized": false, 
            "LaunchTime": "2015-05-21T23:41:35.000Z", 
            "PrivateIpAddress": "172.31.33.159", 
            "ProductCodes": [], 
            "VpcId": "vpc-26199843", 
            "StateTransitionReason": null, 
            "InstanceId": "i-bec48f48", 
            "ImageId": "ami-cb5266fb", 
            "PrivateDnsName": "ip-172-31-33-159.us-west-2.compute.internal", 
            "SecurityGroups": [
                {
                    "GroupName": "my-lb-group", 
                    "GroupId": "sg-88bea5ed"
                }
            ], 
            "ClientToken": null, 
            "SubnetId": "subnet-891ca3fe", 
            "InstanceType": "m1.small", 
            "NetworkInterfaces": [
                {
                    "Status": "in-use", 
                    "MacAddress": "06:c7:74:9e:c7:5f", 
                    "SourceDestCheck": true, 
                    "VpcId": "vpc-26199843", 
                    "Description": null, 
                    "NetworkInterfaceId": "eni-46968c30", 
                    "PrivateIpAddresses": [
                        {
                            "PrivateDnsName": "ip-172-31-33-159.us-west-2.compute.internal", 
                            "Primary": true, 
                            "PrivateIpAddress": "172.31.33.159"
                        }
                    ], 
                    "PrivateDnsName": "ip-172-31-33-159.us-west-2.compute.internal", 
                    "Attachment": {
                        "Status": "attaching", 
                        "DeviceIndex": 0, 
                        "DeleteOnTermination": true, 
                        "AttachmentId": "eni-attach-d508bdf4", 
                        "AttachTime": "2015-05-21T23:41:35.000Z"
                    }, 
                    "Groups": [
                        {
                            "GroupName": "my-lb-group", 
                            "GroupId": "sg-88bea5ed"
                        }
                    ], 
                    "SubnetId": "subnet-891ca3fe", 
                    "OwnerId": "901416387788", 
                    "PrivateIpAddress": "172.31.33.159"
                }
            ], 
            "SourceDestCheck": true, 
            "Placement": {
                "Tenancy": "default", 
                "GroupName": null, 
                "AvailabilityZone": "us-west-2b"
            }, 
            "Hypervisor": "xen", 
            "BlockDeviceMappings": [], 
            "Architecture": "x86_64", 
            "StateReason": {
                "Message": "pending", 
                "Code": "pending"
            }, 
            "RootDeviceName": "/dev/sda1", 
            "VirtualizationType": "paravirtual", 
            "RootDeviceType": "ebs", 
            "AmiLaunchIndex": 0
        }
    ]
}

$ openssl genrsa -out my-private-key.pem 2048
Generating RSA private key, 2048 bit long modulus
...................+++
..............................+++
e is 65537 (0x10001)

$ openssl req -sha256 -new -key my-private-key.pem -out csr.pem
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:US
State or Province Name (full name) [Some-State]:California
Locality Name (eg, city) []:San Francisco
Organization Name (eg, company) [Internet Widgits Pty Ltd]:AWS by Example
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:*.mycompany.com
Email Address []:nzoschke@gmail.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:

$ openssl x509 -req -days 365 -in csr.pem -signkey my-private-key.pem -out my-certificate.pem
Signature ok
subject=/C=US/ST=California/L=San Francisco/O=AWS by Example/CN=*.mycompany.com/emailAddress=nzoschke@gmail.com
Getting Private key

$ aws iam upload-server-certificate --server-certificate-name cert --certificate-body file://my-certificate.pem --private-key file://my-private-key.pem --region us-west-2
{
    "ServerCertificateMetadata": {
        "ServerCertificateId": "ASCAIL5DIDMALNA3IDRG2", 
        "ServerCertificateName": "cert", 
        "Expiration": "2016-05-20T23:14:55Z", 
        "Path": "/", 
        "Arn": "arn:aws:iam::901416387788:server-certificate/cert", 
        "UploadDate": "2015-05-21T23:22:38.951Z"
    }
}

$ aws elb create-load-balancer --load-balancer-name mylb --listeners Protocol=http,LoadBalancerPort=80,InstanceProtocol=http,InstancePort=80 Protocol=https,LoadBalancerPort=443,InstanceProtocol=http,InstancePort=80,SSLCertificateId=arn:aws:iam::901416387788:server-certificate/cert --subnets subnet-891ca3fe --security-groups sg-88bea5ed --region us-west-2
{
    "DNSName": "mylb-69570503.us-west-2.elb.amazonaws.com"
}

$ aws elb configure-health-check --load-balancer-name mylb --health-check Target=HTTP:80/,Interval=30,UnhealthyThreshold=2,HealthyThreshold=2,Timeout=3 --region us-west-2
{
    "HealthCheck": {
        "HealthyThreshold": 2, 
        "Interval": 30, 
        "Target": "HTTP:80/", 
        "Timeout": 3, 
        "UnhealthyThreshold": 2
    }
}

$ aws elb register-instances-with-load-balancer --load-balancer-name mylb --instances i-bec48f48 --region us-west-2
{
    "Instances": [
        {
            "InstanceId": "i-bec48f48"
        }
    ]
}

$ curl -s http://mylb-69570503.us-west-2.elb.amazonaws.com/ | grep Congrat
          <h1>Congratulations!</h1>

$ curl -svk https://mylb-69570503.us-west-2.elb.amazonaws.com/ | grep Congrat
* Hostname was NOT found in DNS cache
*   Trying 52.25.181.57...
* Connected to mylb-69570503.us-west-2.elb.amazonaws.com (52.25.181.57) port 443 (#0)
* TLS 1.2 connection using TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256
* Server certificate: *.mycompany.com
> GET / HTTP/1.1
> User-Agent: curl/7.37.1
> Host: mylb-69570503.us-west-2.elb.amazonaws.com
> Accept: */*
> 
< HTTP/1.1 200 OK
< Accept-Ranges: bytes
< Cache-Control: max-age=0, no-cache
< Content-Type: text/html; charset=utf-8
< Date: Fri, 22 May 2015 00:04:53 GMT
* Server Apache is not blacklisted
< Server: Apache
< Vary: Accept-Encoding
< X-Frame-Options: SAMEORIGIN
< X-Mod-Pagespeed: 1.9.32.3-4523
< Content-Length: 3599
< Connection: keep-alive
< 
{ [data not shown]
* Connection #0 to host mylb-69570503.us-west-2.elb.amazonaws.com left intact
          <h1>Congratulations!</h1>

