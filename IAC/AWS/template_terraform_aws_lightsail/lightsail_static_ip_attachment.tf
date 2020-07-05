resource "aws_lightsail_static_ip_attachment" "template_attachment" {
  static_ip_name = aws_lightsail_static_ip.template_ip.id
  instance_name  = aws_lightsail_instance.template_instance.id
}
