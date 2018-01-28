sshd:
  pkg.installed:
    - name: openssh-server
  service.running:
    - name: ssh