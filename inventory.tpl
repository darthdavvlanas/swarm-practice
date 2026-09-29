[managers]
%{ for name, ip in managers ~}
${name} ansible_host=${ip} ansible_user=davlanas
%{ endfor ~}

[workers]
%{ for name, ip in workers ~}
${name} ansible_host=${ip} ansible_user=davlanas
%{ endfor ~}

[all:children]
managers
workers