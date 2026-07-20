env           = "dev"
aws_region    = "eu-central-1"
vpc_cidr      = "192.168.0.0/20"

subnet_cidr = {
    public_a  = "192.168.1.0/24"
    public_b  = "192.168.2.0/24"
    private_a = "192.168.3.0/24"
    private_b = "192.168.4.0/24"
}