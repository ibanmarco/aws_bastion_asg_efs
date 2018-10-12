# Bastion + ASG + EFS

(will be updated ASAP)

- PL* variables should be passed from each stage of the Pipeline.
- This solution is scalable, so you can easily add new variable files per stage and region.
- This code has been created to be used with the profile configured on ~/.aws/credentials. You can easily modified this code to assume a role if you are using a Pipeline with cross-accounts and also add a buildspec file to perform this code.
