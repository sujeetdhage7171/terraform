variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "demo-gke-cluster"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 1
}

variable "node_machine_type" {
  description = "Machine type for the GKE nodes"
  type        = string
  default     = "e2-medium"
}
