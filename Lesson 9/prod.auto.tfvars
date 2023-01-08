// Set defauld values to variables 
zone           = "ru-central1-b"
cloudName      = "cloud-ie"
ubuntu-version = "ubuntu-2204-lts"
lamp-version   = "lamp"
allowed_zones  = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
is-preemptible = false
my-labels = {
  "owner"  = "vasya",
  "color"  = "brown",
  "policy" = "allow",
  "food"   = "russian"
}
platformVersion = "standard-v3"
isTest = false