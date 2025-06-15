run "test_web_app_deploy" {
  command = apply

  # Test the availability_zone is in lower case and one of a, b, and c.
  assert {
    condition = alltrue([
      for zone in local.availability_zones : contains(["a", "b", "c"], zone)
    ])
    error_message = "availability_zone should be a, b or c in lowercase"
  }


  # Test the public_ip output of the module.
  assert {
    condition = alltrue([
      for ip in module.deploy_web_app.web_app_public_ip : strcontains(ip, ".")
    ])
    error_message = "Public IP output is not valid"
  }
}




