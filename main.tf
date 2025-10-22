module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  region          = var.region
}

module "iam" {
  source        = "./modules/iam"
  cluster_name  = var.cluster_name
}

module "eks" {
  source        = "./modules/eks"
  cluster_name  = var.cluster_name
  subnet_ids    = module.vpc.private_subnet_ids
  vpc_id        = module.vpc.vpc_id
  role_arn      = module.iam.eks_role_arn
  node_role_arn = module.iam.eks_node_role_arn   # New
}

