locals {
  name_prefix = "${local.name_prefix}-lt"
}


block_device_mapping{
  device_name  = tolist(data.aws_ami.ubuntu_26_04.block_device_mapping)[0].device_name
  ebs={
    volume_size= var.volume_size
    volume_type = "gp3"
  }
  ebs_optimize=true
  image_id = data.aws_ami.ubuntu_26_04.id
  instance_type = var.instance_type
  key_name = ""


  user_data = base64encode(templatefile("${path.module}/files/ci.sh",
  {
    token = var.token
  }))
}