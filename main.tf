# ---------------------------------------------------------------------------------------------------------------------
# Bucket configuration
# ---------------------------------------------------------------------------------------------------------------------

resource "google_storage_bucket" "static-site" {
  project = var.project
  name = "omar-aldakar-lab-innovorder-bucket"
  location = "EU"
  force_destroy = true

  website {
    main_page_suffix = "index.html"
  }
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.static-site.name
  role = "roles/storage.legacyObjectReader"
  member = "allUsers"

  depends_on = [google_storage_bucket.static-site]
}

# ---------------------------------------------------------------------------------------------------------------------
# SSL certificate managed by GCP
# ---------------------------------------------------------------------------------------------------------------------
resource "google_compute_managed_ssl_certificate" "default" { 
  project = var.project
  name = "ssl-certificate"

  managed {
    domains = [var.dns_name]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Load balancer and CDN configuration
# ---------------------------------------------------------------------------------------------------------------------
module "load_balancer" {
  project = var.project
  source = "github.com/gruntwork-io/terraform-google-load-balancer.git//modules/http-load-balancer?ref=v0.3.0"
  name = "omar-aldakar-lab-innovorder-lb"
  url_map = google_compute_url_map.urlmap.self_link
  enable_http = false
  enable_ssl = true
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}


resource "google_compute_url_map" "urlmap" {
  project = var.project
  name        = "om-url-map"
  description = "URL map for a static website"

  default_service = google_compute_backend_bucket.static.self_link
}

resource "google_compute_backend_bucket" "static" {
  project = var.project
  name        = "omar-aldakar-backend"
  bucket_name = google_storage_bucket.static-site.name
  depends_on = [google_storage_bucket.static-site]

  enable_cdn  = true
}


# ---------------------------------------------------------------------------------------------------------------------
# DNS configuration : mapping dns_name to load balancer ip address 
# ---------------------------------------------------------------------------------------------------------------------
resource "google_dns_record_set" "dns" {
  project = var.project
  count   = 1

  name = var.dns_name
  type = "A"
  ttl  = 1800

  managed_zone = var.google_dns_managed_zone_name 

  rrdatas = [module.load_balancer.load_balancer_ip_address]
}


# ---------------------------------------------------------------------------------------------------------------------
# HTTP to HTTPS redirection
# ---------------------------------------------------------------------------------------------------------------------
resource "google_compute_url_map" "http-redirect" {
  project = var.project
  name = "http-redirect"

  default_url_redirect {
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"  
    strip_query            = false
    https_redirect         = true  
  }
}

resource "google_compute_target_http_proxy" "http-redirect" {
  project = var.project
  name    = "http-redirect"
  url_map = google_compute_url_map.http-redirect.self_link
}

resource "google_compute_global_forwarding_rule" "http-redirect" {
  project = var.project
  name       = "http-redirect"
  target     = google_compute_target_http_proxy.http-redirect.self_link
  ip_address = module.load_balancer.load_balancer_ip_address
  port_range = "80"
}
