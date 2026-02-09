Cloud Shell Outputs
List ALL security groups

-----------------------------------------------------------------
|                    DescribeSecurityGroups                     |
+-----------------------+-------------+-------------------------+
|        GroupId        |    Name     |          VpcId          |
+-----------------------+-------------+-------------------------+
|  sg-028c2bee59869c69f |  sg.rds-lab |  vpc-0ed86053d1c90c017  |
|  sg-0b4da2fb27c29d923 |  default    |  vpc-0ed86053d1c90c017  |
|  sg-0dcd2ea92c8769f7b |  sg.ec2-lab |  vpc-0ed86053d1c90c017  |
+-----------------------+-------------+-------------------------+

Inspect a specific security group (inbound & outbound rules)
(EC2):

{
    "SecurityGroups": [
        {
            "GroupId": "sg-0dcd2ea92c8769f7b",
            "IpPermissionsEgress": [
                {
                    "IpProtocol": "-1",
                    "UserIdGroupPairs": [],
                    "IpRanges": [
                        {
                            "CidrIp": "0.0.0.0/0"
                        }
                    ],
                    "Ipv6Ranges": [],
                    "PrefixListIds": []
                }
            ],
            "VpcId": "vpc-0ed86053d1c90c017",
            "SecurityGroupArn": "arn:aws:ec2:us-east-1:385109576397:security-group/sg-0dcd2ea92c8769f7b",
            "OwnerId": "385109576397",
            "GroupName": "sg.ec2-lab",
            "Description": "sg for ec2",
            "IpPermissions": [
                {
                    "IpProtocol": "tcp",
                    "FromPort": 80,
                    "ToPort": 80,
                    "UserIdGroupPairs": [],
                    "IpRanges": [
                        {
                            "CidrIp": "0.0.0.0/0"
                        }
                    ],
                    "Ipv6Ranges": [],
                    "PrefixListIds": []

(RDS):

  {
                    "IpProtocol": "tcp",
                    "FromPort": 22,
                    "ToPort": 22,
                    "UserIdGroupPairs": [],
                    "IpRanges": [
                        {
                            "CidrIp": "73.191.193.93/32"
                        }
                    ],
                    "Ipv6Ranges": [],
                    "PrefixListIds": []
                },
                {
                    "IpProtocol": "tcp",
                    "FromPort": 5000,
                    "ToPort": 5000,
                    "UserIdGroupPairs": [],
                    "IpRanges": [
                        {
                            "CidrIp": "0.0.0.0/0"
                        }
                    ],
                    "Ipv6Ranges": [],
                    "PrefixListIds": []
                }
            ]
        }
    ]
}
Use old bottom of screen behavior  (press RETURN)


Verify which EC2 instances use this SG

-------------------------
|   DescribeInstances   |
+-----------------------+
|  i-0fc8c3bc930a3fda5  |
+-----------------------+

Verify which RDS instances use this SG

---------------------
|DescribeDBInstances|
+-------------------+
|  jr-lab-mysql     |
+-------------------+

List ALL RDS instances (big picture)

---------------------------------------------------------------
|                     DescribeDBInstances                     |
+---------------+---------+---------+-------------------------+
|      DB       | Engine  | Public  |           Vpc           |
+---------------+---------+---------+-------------------------+
|  jr-lab-mysql |  mysql  |  False  |  vpc-0ed86053d1c90c017  |
+---------------+---------+---------+-------------------------+

Inspect ONE RDS instance deeply

{
    "DBInstances": [
        {
            "DBInstanceIdentifier": "jr-lab-mysql",
            "DBInstanceClass": "db.t4g.micro",
            "Engine": "mysql",
            "DBInstanceStatus": "available",
            "MasterUsername": "admin",
            "Endpoint": {
                "Address": "jr-lab-mysql.cwh6yoyeihx9.us-east-1.rds.amazonaws.com",
                "Port": 3306,
                "HostedZoneId": "Z2R2ITUGPM61AM"
            },
            "AllocatedStorage": 20,
            "InstanceCreateTime": "2026-01-25T05:09:33.763000+00:00",
            "PreferredBackupWindow": "06:14-06:44",
            "BackupRetentionPeriod": 1,
            "DBSecurityGroups": [],
            "VpcSecurityGroups": [
                {
                    "VpcSecurityGroupId": "sg-028c2bee59869c69f",
                    "Status": "active"
                }
            ],
            "DBParameterGroups": [
                {
                    "DBParameterGroupName": "default.mysql8.4",
                    "ParameterApplyStatus": "in-sync"
                }
            ],
            "AvailabilityZone": "us-east-1f",
            "DBSubnetGroup": {
                "DBSubnetGroupName": "default-vpc-0ed86053d1c90c017",
                "DBSubnetGroupDescription": "Created from the RDS Management Console",
                "VpcId": "vpc-0ed86053d1c90c017",

Explicitly list RDS security groups

         "SubnetGroupStatus": "Complete",
                "Subnets": [
                    {
                        "SubnetIdentifier": "subnet-0331b525ededfa61c",
                        "SubnetAvailabilityZone": {
                            "Name": "us-east-1e"
                        },
                        "SubnetOutpost": {},
                        "SubnetStatus": "Active"
                    },
                    {
                        "SubnetIdentifier": "subnet-0cace1042a7e23768",
                        "SubnetAvailabilityZone": {
                            "Name": "us-east-1d"
                        },
                        "SubnetOutpost": {},
                        "SubnetStatus": "Active"
                    },
                    {
                        "SubnetIdentifier": "subnet-00ce0af067aefd418",
                        "SubnetAvailabilityZone": {
                            "Name": "us-east-1b"
                        },
                        "SubnetOutpost": {},
                        "SubnetStatus": "Active"
                    },
                    {
                        "SubnetIdentifier": "subnet-05f69f32d59b9efa2",
                        "SubnetAvailabilityZone": {
                            "Name": "us-east-1f"
                        },
                        "SubnetOutpost": {},
                        "SubnetStatus": "Active"
                    },
                    {
                        "SubnetIdentifier": "subnet-0fda7d0799421f559",
                        "SubnetAvailabilityZone": {
                            "Name": "us-east-1a"
                        },
                        "SubnetOutpost": {},
                        "SubnetStatus": "Active"
                    },
                    {
                        "SubnetIdentifier": "subnet-0b3e8bb74aea3272a",
                        "SubnetAvailabilityZone": {
                            "Name": "us-east-1c"
                        },
                        "SubnetOutpost": {},
                        "SubnetStatus": "Active"
                    }
                ]
            },
            "PreferredMaintenanceWindow": "sat:07:20-sat:07:50",
            "UpgradeRolloutOrder": "second",
            "PendingModifiedValues": {},
            "LatestRestorableTime": "2026-01-25T08:00:01+00:00",
            "MultiAZ": false,
            "EngineVersion": "8.4.7",
            "AutoMinorVersionUpgrade": true,
            "ReadReplicaDBInstanceIdentifiers": [],
            "LicenseModel": "general-public-license",
            "StorageThroughput": 0,
            "OptionGroupMemberships": [
                {
                    "OptionGroupName": "default:mysql-8-4",
                    "Status": "in-sync"
                }
            ],
            "PubliclyAccessible": false,
            "StorageType": "gp2",
            "DbInstancePort": 0,
            "StorageEncrypted": true,
            "KmsKeyId": "arn:aws:kms:us-east-1:385109576397:key/ba8763fa-70f3-48da-b78b-f5747dbddd98",
            "DbiResourceId": "db-IIVKB4TICUAEKSAJMCP3C4GY4A",
            "CACertificateIdentifier": "rds-ca-rsa2048-g1",
            "DomainMemberships": [],
            "CopyTagsToSnapshot": true,
            "MonitoringInterval": 0,
            "DBInstanceArn": "arn:aws:rds:us-east-1:385109576397:db:jr-lab-mysql",
            "IAMDatabaseAuthenticationEnabled": false,
            "DatabaseInsightsMode": "standard",
            "PerformanceInsightsEnabled": false,
            "DeletionProtection": false,
            "AssociatedRoles": [],
            "MaxAllocatedStorage": 1000,
            "TagList": [],
            "CustomerOwnedIpEnabled": false,
            "NetworkType": "IPV4",
            "ActivityStreamStatus": "stopped",
            "BackupTarget": "region",
            "CertificateDetails": {
                "CAIdentifier": "rds-ca-rsa2048-g1",
                "ValidTill": "2027-01-25T05:08:09+00:00"
            },
            "DedicatedLogVolume": false,
            "IsStorageConfigUpgradeAvailable": false,
            "EngineLifecycleSupport": "open-source-rds-extended-support-disabled"
        }
    ]
}
(END)

Verify RDS subnet placement (private networking)

------------------------------------------------------------
|                  DescribeDBSubnetGroups                  |
+--------------------------------+-------------------------+
|              Name              |           Vpc           |
+--------------------------------+-------------------------+
|  default-vpc-0ed86053d1c90c017 |  vpc-0ed86053d1c90c017  |
+--------------------------------+-------------------------+
||                         Subnets                        ||
|+--------------------------------------------------------+|
||  subnet-0331b525ededfa61c                              ||
||  subnet-0cace1042a7e23768                              ||
||  subnet-00ce0af067aefd418                              ||
||  subnet-05f69f32d59b9efa2                              ||
||  subnet-0fda7d0799421f559                              ||
||  subnet-0b3e8bb74aea3272a                              ||
|+--------------------------------------------------------+|

Fast public exposure check (one-liner)

False

Secrets Manager verification

------------------------------------------------------------------------------------------------------------
|                                                ListSecrets                                               |
+----------------------------------------------------------------------------+----------------+------------+
|                                     ARN                                    |     Name       | Rotation   |
+----------------------------------------------------------------------------+----------------+------------+
|  arn:aws:secretsmanager:us-east-1:385109576397:secret:lab/rds/mysql-QS5rbk |  lab/rds/mysql |  None      |
+----------------------------------------------------------------------------+----------------+------------+

Describe a secret (SAFE)

{
    "ARN": "arn:aws:secretsmanager:us-east-1:385109576397:secret:lab/rds/mysql-QS5rbk",
    "Name": "lab/rds/mysql",
    "LastChangedDate": "2026-01-25T05:35:20.378000+00:00",
    "LastAccessedDate": "2026-01-25T00:00:00+00:00",
    "Tags": [],
    "VersionIdsToStages": {
        "d4f4d6be-6256-40f1-b335-36ad12d6ff2d": [
            "AWSCURRENT"
        ]
    },
    "CreatedDate": "2026-01-25T05:35:20.343000+00:00"
}
 
Check who can access the secret

{
    "ARN": "arn:aws:secretsmanager:us-east-1:385109576397:secret:lab/rds/mysql-QS5rbk",
    "Name": "lab/rds/mysql"
}

Verify IAM role attached to EC2

Step 1: Find the instance:

i-0fc8c3bc930a3fda5

Step 2: See attached instance profile:

arn:aws:iam::385109576397:instance-profile/lab-ec2-secrets-role

Step 3: Resolve instance profile → role:

lab-ec2-secrets-role

Managed policies

----------------------------------------------------------------------------------
|                            ListAttachedRolePolicies                            |
+--------------------------------------------------------------------------------+
||                               AttachedPolicies                               ||
|+--------------------------------------------------+---------------------------+|
||                     PolicyArn                    |        PolicyName         ||
|+--------------------------------------------------+---------------------------+|
||  arn:aws:iam::aws:policy/SecretsManagerReadWrite |  SecretsManagerReadWrite  ||
|+--------------------------------------------------+---------------------------+|

Inline policies

------------------
|ListRolePolicies|
+----------------+

Inspect a managed policy & Verify EC2 → RDS access path (SG to SG)

{
{
    "PolicyVersion": {
        "Document": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": [
                        "secretsmanager:*",
                        "cloudformation:CreateChangeSet",
                        "cloudformation:DescribeChangeSet",
                        "cloudformation:DescribeStackResource",
                        "cloudformation:DescribeStacks",
                        "cloudformation:ExecuteChangeSet",
                        "ec2:DescribeSecurityGroups",
                        "ec2:DescribeSubnets",
                        "ec2:DescribeVpcs",
                        "kms:DescribeKey",
                        "kms:ListAliases",
                        "kms:ListKeys",
                        "lambda:ListFunctions",
                        "rds:DescribeDBInstances",
                        "tag:GetResources"
                    ],
                    "Effect": "Allow",
                    "Resource": "*"
                },
                {
                    "Action": [
                        "lambda:AddPermission",
                        "lambda:CreateFunction",
                        "lambda:GetFunction",
                        "lambda:InvokeFunction",
                        "lambda:UpdateFunctionConfiguration"
                    ],
                    "Effect": "Allow",
                    "Resource": "arn:aws:lambda:*:*:function:SecretsManager*"
                },
                {
                    "Action": [
                        "serverlessrepo:CreateCloudFormationChangeSet"
                    ],
                    "Effect": "Allow",
                    "Resource": "arn:aws:serverlessrepo:*:*:applications/SecretsManager*"
                },
                {
                    "Action": [
                        "s3:GetObject"
                    ],
                    "Effect": "Allow",
                    "Resource": "arn:aws:s3:::awsserverlessrepo-changesets*"
                }
            ]
        },
        "VersionId": "v1",
        "IsDefaultVersion": false,
        "CreateDate": "2018-04-04T18:05:29+00:00"
    }
}
(END)


Final proof: test FROM EC2
Inside EC2:

{
    "UserId": "AIDAVTKSRZLGYPDJKHDQ3",
    "Account": "385109576397",
    "Arn": "arn:aws:iam::385109576397:user/AWSCLI"
}

Then:

{
    "ARN": "arn:aws:secretsmanager:us-east-1:385109576397:secret:lab/rds/mysql-QS5rbk",
    "Name": "lab/rds/mysql",
    "LastChangedDate": "2026-01-25T05:35:20.378000+00:00",
    "LastAccessedDate": "2026-01-25T00:00:00+00:00",
    "Tags": [],
    "VersionIdsToStages": {
        "d4f4d6be-6256-40f1-b335-36ad12d6ff2d": [
            "AWSCURRENT"
        ]
    },
    "CreatedDate": "2026-01-25T05:35:20.343000+00:00"
}










 

