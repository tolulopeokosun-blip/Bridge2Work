output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "private_subnets" {
  value = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "ec2_public_ips" {
  value = [aws_instance.web_a.public_ip, aws_instance.web_b.public_ip]
}

output "db_endpoints" {
  value = [aws_db_instance.db_a.endpoint, aws_db_instance.db_b.endpoint]
}


output "eks_cluster_a_endpoint" {
  value = aws_eks_cluster.cluster_a.endpoint
}

output "eks_cluster_b_endpoint" {
  value = aws_eks_cluster.cluster_b.endpoint
}

output "eks_cluster_a_name" {
  value = aws_eks_cluster.cluster_a.name
}

output "eks_cluster_b_name" {
  value = aws_eks_cluster.cluster_b.name
}
