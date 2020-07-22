resource "lxd_container" "control" {
  name      = "control"
  image     = "focal"
  profiles  = ["ubuntu-profile"]
  ephemeral = false

  config = {
    "boot.autostart" = true
    "user.user-data" = file("./cloud_init/ubuntu-generic-clean.yml")
  }

  limits = {
    cpu = 1
  }
}

resource "lxd_container" "cargo" {
  name      = "cargo"
  image     = "focal"
  profiles  = ["ubuntu-profile"]
  ephemeral = false

  config = {
    "boot.autostart" = true
    "user.user-data" = file("./cloud_init/ubuntu-generic-clean.yml")
  }

  limits = {
    cpu = 1
  }
}
