output "vpc-id" {
  value = aws_vpc.vpc[0].id
}

### OUTPUT SUBNET CONTROL PLANE PER CLUSTER EKS ###

output "subnet-cp-private-a-id" {
  value = aws_subnet.cp-private-a[0].id
}

output "subnet-cp-private-b-id" {
  value = aws_subnet.cp-private-b[0].id
}

output "subnet-cp-private-c-id" {
  value = aws_subnet.cp-private-c[0].id
}

### OUTPUT SUBNET PUBBLICHE PER ELEMENTI COME BASTION/WS ###

output "subnet-public-a-id" {
  value = aws_subnet.public-a[0].id
}

output "subnet-public-b-id" {
  value = aws_subnet.public-b[0].id
}

output "subnet-public-c-id" {
  value = aws_subnet.public-c[0].id
}

### OUTPUT SUBNET PRIVATE PER ELEMENTI COME DB AURORA ###

output "subnet-private-a-id" {
  value = aws_subnet.private-a[0].id
}

output "subnet-private-b-id" {
  value = aws_subnet.private-b[0].id
}

output "subnet-private-c-id" {
  value = aws_subnet.private-c[0].id
}

### OUTPUT SUBNET PRIVATE PER WORKER NODE E PODS ###

output "subnet-worker-private-a-id" {
  value = aws_subnet.worker-private-a[0].id
}

output "subnet-worker-private-b-id" {
  value = aws_subnet.worker-private-b[0].id
}

output "subnet-worker-private-c-id" {
  value = aws_subnet.worker-private-c[0].id
}
