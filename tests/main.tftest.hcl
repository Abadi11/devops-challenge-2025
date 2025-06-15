run "test_web_app_deploy" {
  command = apply

  # Test the availability_zone is in lower case and one of a, b, and c.
  assert {
    condition     = contains(["a", "b", "c"], local.availability_zone)
    error_message = "availability_zone should be a, b or c in lowercase"
  }


  # Test the public_ip output of the module.
  assert {
    condition     = strcontains(module.deploy_web_app.web_app_public_ip, ".")
    error_message = "Public IP output is not valid"
  }
}




