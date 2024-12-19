output "capa_controller_roles" {
  value = {for k, v in module.capa_controller_role : k => v}
}
