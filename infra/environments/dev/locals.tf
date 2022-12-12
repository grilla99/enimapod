locals {
  aws_ecr_url   = "${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-west-2.amazonaws.com"
  aws_vpc_id    = aws_vpc.main.id
  aws_ig_id     = aws_internet_gateway.gw[0].id
  aws_rt_id     = aws_route_table.public[0].id
  aws_pub_ids   = [for sub in aws_subnet.pub_subnets : "${sub.id}"]
  lb_tg_arn     = module.alb.lb_tg_arn
  lb_tg_api_arn = module.alb.lb_tg_api_arn
}