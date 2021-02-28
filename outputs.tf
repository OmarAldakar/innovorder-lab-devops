# ------------------------------------------------------------------------------
# LOAD BALANCER OUTPUTS
# ------------------------------------------------------------------------------

output "load_balancer_ip_address" {
  description = "IP address of the Cloud Load Balancer"
  value       = module.load_balancer.load_balancer_ip_address
}
