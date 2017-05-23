sshd-ca-known-hosts:
  file.append:
    - name: /etc/ssh/ssh_known_hosts
    - text: "@cert-authority * {{ salt['pillar.get']('ssh:ca_pubkey') }} - managed CA key"
