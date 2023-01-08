// Set defauld values to variables 
zone           = "ru-central1-a"
cloudName      = "cloud-ie"
ubuntu-version = "ubuntu-2204-lts"
lamp-version   = "lamp"
allowed_zones  = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
is-preemptible = true
my-labels = {
  "owner"  = "vasya",
  "color"  = "brown",
  "policy" = "deny",
  "food"   = "japanese"
}
platformVersion = "standard-v1"
isTest = true