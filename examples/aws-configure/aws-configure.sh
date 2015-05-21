# To interact with AWS via the Command Line Interface
# (CLI), configure credentials with `aws configure`
$ aws configure
AWS Access Key ID [None]: <Paste Access Key ID>
AWS Secret Access Key [None]: <Paste Secret Access Key>
Default region name [None]: us-east-1
Default output format [None]: json

# Credentials are stored in our home directory:
$ cat ~/.aws/config
[default]
aws_access_key_id = AKIA...
aws_secret_access_key = SFoH...

# We can then manage AWS resources with the CLI.
$ aws ec2 describe-instances
{
    "Reservations": []
}

# Now that we can interact with the AWS APIs with the
# CLI, let's learn more about the numerous infrastructure
# services.
