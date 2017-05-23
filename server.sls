sshd:
  pkg.installed:
    - name: openssh-server
  service.running:
    - name: ssh

sshd-ca-trusted-users:
  file.append:
    - name: /etc/ssh/trusted_user_ca_keys
    - text: {{ salt['pillar.get']('ssh:ca_pubkey') }} - managed CA key
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
