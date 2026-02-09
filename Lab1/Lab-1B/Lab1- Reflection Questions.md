# Lab1B- Reflection Questions



##### A) Why might Parameter Store still exist alongside Secrets Manager?



Because not everything is a secret, and not everything should be treated like one.



**Parameter Store exists because:**



* Many values are configuration, not credentials



* Config changes more often than secrets



* Config is often shared across services/environments



Examples:



* DB endpoint



* DB port



* Feature flags



* Environment names



* API base URLs



If you put everything in Secrets Manager:



* You increase cost



* You complicate access control



* You slow down operational changes



Industry reality:



* Parameter Store = “Where does my system connect?”



* Secrets Manager = “How does my system authenticate?”



Using both is a design choice, not redundancy.





##### B) What breaks first during secret rotation?

##### 

**Applications break before databases do.**



Specifically:



* Cached credentials



* Long-liked connections



* Hardcoded secrets



* Services that don’t reload secrets dynamically



Common real-world failure:



1. Secret rotates successfully
   
2. DB accepts new password
   
3. App keeps using old password
   
4. App starts throwing auth failures
   
5. Traffic drops → alarm fires



That’s why:



* Rotation without observability is dangerous



* Rotation without rollback is reckless



Your lab simulates this perfectly by:



* Changing the secret



* Watching the app fail



* Recovering using known-good values



That’s textbook ops engineering.





##### C) Why should alarms be based on symptoms instead of causes?

##### 

**Because you don’t know the cause during an incident.**



Symptoms are:



* DB connection failures



* Error rates



* Timeouts



* 5xx responses



Causes are:



* Bad credentials



* Network issues



* Security group changes



* RDS maintenance



* IAM regression



If you alarm on causes:



* You miss unknown failures



* You create false confidence



* You don’t page when users are impacted



If you alarm on symptoms:



* You catch all failures



* You respond faster



* You investigate intelligently



Golden rule of monitoring:



Users don’t care why it broke — only that it broke.



Your CloudWatch alarm on DB errors is exactly right.





##### D) How does this lab reduce Mean Time To Recovery (MTTR)?



This lab attacks MTTR from four angles:



###### 1\. Faster Detection



* Logs show explicit DB failures



* Alarm fires automatically



* No “is it down?” guessing



###### 2\. Faster Diagnosis



* Logs tell you what failed



* You know whether it’s:



* Auth



* Network



* Endpoint



* No SSH guessing, no blind restarts



###### 3\. Faster Fix



* Correct values already exist



* No redeploy needed



* No rebuild needed



* No infra changes needed



###### 4\. Safer Recovery



* You restore known-good config



* You don’t “try random things”



* You don’t introduce new failures



**Net effect:**

MTTR goes from hours → minutes







##### E) What would you automate next?



Strong answers here show senior thinking. Here are the best next automations, in order of impact:



###### 1\. Automated Secret Rotation with App Reload



* Secrets Manager rotation Lambda



* App reads secrets on startup or periodically



* No manual intervention



###### 2\. Auto-Rollback on Failure



* If alarm fires after rotation:



* Restore previous secret version



* Page humans



* This is real production maturity



###### 3\. Structured Logging + Metrics



* Emit structured JSON logs



* Create metric filters per error type



* Separate auth vs network vs timeout



###### 4\. Health Checks + Synthetic Monitoring



* External canary hits /list



* Confirms user-facing recovery



* Not just internal success



###### 5\. Runbook Automation



CLI scripts that:



* Fetch secrets



* Validate connectivity



* Restore configs



* Reduces human error under pressure



If you said any 2–3 of these in an interview, you’d sound extremely credible.





