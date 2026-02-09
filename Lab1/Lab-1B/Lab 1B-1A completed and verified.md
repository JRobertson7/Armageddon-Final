# Lab 1B-1A completed and verified



(Screenshots Attached)



#####  **Required Incident Report (High-Scoring Example)**



**Incident Summary**



Production application experienced database connectivity failures causing /list endpoint errors. EC2 remained healthy; no deployments occurred.



**Detection**



CloudWatch alarm lab-db-connection-failure transitioned to ALARM and triggered SNS notification. Errors were confirmed via CloudWatch Logs.



**What Failed?**



Database authentication failed between EC2 application and RDS.



**Root Cause**



Credential drift: database password in AWS Secrets Manager did not match the actual RDS password.



**Recovery Actions**



Validated configuration via Parameter Store and Secrets Manager. Restored credential consistency by updating the RDS password to match the stored secret. No infrastructure redeployments were performed.



**Time to Recovery**



~10–15 minutes from alert to service restoration.



###### **Preventive Actions**



To reduce MTTR



* Add structured error codes to logs (auth vs network vs availability).



To prevent recurrence



* Implement Secrets Manager rotation with automatic rollback and application reload support.
