module "conectividade" {
  source = "./conectividade"
}

module "aplicacao" {
  source = "./aplicacao"
  vpc_id     = module.conectividade.vpc_id
  subnet_app = module.conectividade.subnet_app_id
  subnet_dmz = module.conectividade.subnet_dmz_id
  subnet_bd  = module.conectividade.subnet_bd_id
  instance_type = "t3.micro"
}
