@Library('terraform-shared-lib') _

terraformPipeline(
    aws_region: 'us-east-1',
    cluster_name: 'demo-eks-cluster',
    aws_credentials_id: 'aws-jenkins-creds',
    s3_bucket: 'uniquenameintra-demo',
    repo_url: 'https://github.com/chenna333/intraedge-terraform-eks-infra.git',
    branch: 'main',
    git_credentials_id: 'jenkins-creds'
)


