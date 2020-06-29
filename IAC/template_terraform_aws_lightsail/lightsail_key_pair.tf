resource "aws_lightsail_key_pair" "template_access" {
  name       = "template-access"
  public_key = file("./template-access.pub")
}
