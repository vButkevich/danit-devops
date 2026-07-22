env           = "prod"
aws_region    = "eu-central-1"
vpc_cidr      = "10.0.0.0/20"

subnet_cidr = {
    public_a  = "10.0.0.0/24"
    public_b  = "10.0.1.0/24"
    private_a = "10.0.2.0/24"
    private_b = "10.0.3.0/24"
}