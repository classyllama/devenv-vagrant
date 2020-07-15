# AWS CLI Tool

  https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
  
    sudo -i
    cd ~/
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install
    # or specify install dir and binary dir
    ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
    
    aws --version
    
    aws configure
    aws s3 ls

  If you receive the error:
  
    # An error occurred (RequestTimeTooSkewed) when calling the ListBuckets operation: The difference between the request time and the current time is too large.

  You may need to update the system clock

  If you receive the error:
  
    # An error occurred (AccessDenied) when calling the ListBuckets operation: Access Denied
  
  You should try specifing the bucket name you are trying to list the contents of

    aws s3 ls s3://<bucket_name>
  
  Using a named profile (using named profiles does not work with rclone)
  
    aws s3 ls s3://iac-fof-backup --profile iac_fof_backup
