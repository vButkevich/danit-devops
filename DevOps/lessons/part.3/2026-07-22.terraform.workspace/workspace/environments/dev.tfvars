env="dev"

vpc_cidr="10.0.0.0/20"


variable "subnets_cidr" {
  default = {
    public_a  = "10.0.1.0/24"
    public_b  = "10.0.2.0/24"
    private_a = "10.0.3.0/24"
    private_b = "10.0.4.0/24"
  }
}
