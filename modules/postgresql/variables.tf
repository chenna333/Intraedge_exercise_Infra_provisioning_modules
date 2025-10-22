variable "db_identifier" {
  description = "Database identifier name"
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15.3"
}

variable "instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage size in GB"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "username" {
  description = "Master DB username"
  type        = string
  default     = "admin"
}

variable "publicly_accessible" {
  description = "Whether DB is public"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID for RDS"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for DB subnet group"
  type        = list(string)
}

variable "create_sg" {
  description = "Whether to create a new security group"
  type        = bool
  default     = true
}

variable "allowed_cidrs" {
  description = "Allowed CIDRs for DB access"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "vpc_security_group_ids" {
  description = "Existing SG IDs (if not creating new one)"
  type        = list(string)
  default     = []
}

