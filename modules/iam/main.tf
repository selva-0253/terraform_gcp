resource "google_storage_bucket" "this" {
    name                        =var.name
    namespace                   =var.namespace
    image                       =var.image
    location                    =var.location
    storage.class               =var.storage.class
    force.destroy               =var.force_destroy
    uniform_bucket_level_access =true
    labels                      =var.labels
}