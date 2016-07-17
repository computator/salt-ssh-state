sshd:
  pkg.installed:
    - name: openssh-server
  service.running:
    - name: ssh

{% set ca_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfqshlfRmeWr7HMot9d4uJC8xbgUchi9Mc7ObVJnGWCvY4hVzxlvxtmwssj+57DMEq8n0DdDuA5mSYH65BSCvUWOE8FM401KKojVMn7xT6iFJ22zYcp+/YpKFYiRoOFfXNTp1ntZVYMORWNods7O2OPm25C7WZvTnB52E3Xu7zGrf4l0hA26lxd1WbldO+DHEW28WlAjd4MFStb8y6+6ppZbRaH3+9Md79wZOj0dK6Y02dnPoZB3rlZB045OUfRD0Q1QB37d9o4CK7jacRvlKbFQUss4b2M5hcH9oRR1+XS1Ej1ZfoXMrY5S0acQ9LmYBSjB6eM1SdYykAuqVsH4Y7 ssh-ca" %}

sshd-ca-known-hosts:
  file.managed:
    - name: /etc/ssh/ssh_known_hosts
    - contents: "@cert-authority * {{ ca_key }}"
    - replace: false
    - watch_in:
      - service: sshd

sshd-ca-trusted-users:
  file.managed:
    - name: /etc/ssh/trusted_user_ca_keys
    - contents: {{ ca_key }}
    - replace: false
    - watch_in:
      - service: sshd

sshd-ca-trusted-users-option:
  file.append:
    - name: /etc/ssh/sshd_config
    - text: TrustedUserCAKeys /etc/ssh/trusted_user_ca_keys
    - require:
      - file: sshd-ca-trusted-users
    - watch_in:
      - service: sshd