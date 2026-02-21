ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  # Agregamos /32 para que sea una IP única (la tuya)
  cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"]
}
