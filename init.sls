sshd:
  pkg.installed:
    - name: openssh-server
  service.running:
    - name: ssh

{% set ca_key = pillar.ssh.ca_pubkey %}

sshd-ca-known-hosts:
  file.append:
    - name: /etc/ssh/ssh_known_hosts
    - text: "@cert-authority * {{ ca_key }} - managed CA key"
    - watch_in:
      - service: sshd

sshd-ca-trusted-users:
  file.append:
    - name: /etc/ssh/trusted_user_ca_keys
    - text: {{ ca_key }} - managed CA key
    - watch_in:
      - service: sshd

sshd-ca-trusted-users-option:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: .*TrustedUserCAKeys.*
    - repl: TrustedUserCAKeys /etc/ssh/trusted_user_ca_keys
    - append_if_not_found: true
    - require:
      - file: sshd-ca-trusted-users
    - watch_in:
      - service: sshd