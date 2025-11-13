

resource "aws_efs_file_system" "this" {
  creation_token = "${var.cluster_name}-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"


  encrypted = true

  tags = {
    Name = "${var.cluster_name}-efs"

  }
}


resource "aws_efs_mount_target" "this" {
  #for_each = toset(var.subnet_ids)
  for_each = { for idx, id in var.subnet_ids : idx => id }


  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = [var.security_group_id]
}
