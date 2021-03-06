{% set masterless = salt['pillar.get']('virl:salt_masterless', salt['grains.get']('salt_masterless', false)) %}
{% set http_proxy = salt['pillar.get']('virl:http_proxy', salt['grains.get']('http_proxy', 'https://proxy.esl.cisco.com:80/')) %}
{% set ifproxy = salt['pillar.get']('virl:proxy', salt['grains.get']('proxy', False)) %}
{% set kilo = salt['pillar.get']('virl:kilo', salt['grains.get']('kilo', false)) %}

include:
  - common.ubuntu
  - common.salt-minion
  - virl.vinstall
  - openstack.repo
  - common.kvm
  - virl.scripts
  - virl.vextra
  - virl.openvpn

mypkgs:
  pkg.installed:
    - skip_verify: True
    - refresh: False
    - pkgs:
      - debconf-utils
      - dkms
      - kexec-tools
      - qemu-kvm
      - cpu-checker
      - openssl
      - apt-show-versions
      - apache2
      - libapache2-mod-wsgi
      - mtools
      - socat
      - lxc
      - python-dulwich
      - virt-what
      - virtinst

qemu common virl hold:
  apt.held:
    - name: qemu-kvm
    - require:
      - pkg: mypkgs

{% if not masterless %}
vinstall wheels:
  file.recurse:
    - name: /tmp/wheels
    - source: salt://files/wheels
{% endif %}

{% for pyreq in 'wheel','envoy','docopt','sh' %}
{{ pyreq }}:
  pip.installed:
    - require:
      - pkg: pip on the box
      - file: /usr/local/bin/vinstall
      {% if not masterless %}
      - file: vinstall wheels
      {% endif %}
    - use_wheel: True
    - pre_releases: True
    - no_deps: True
    {% if not masterless %}
    - no_index: True
    - find_links: "file:///tmp/wheels"
    {% endif %}
{% endfor %}

configparserus:
  pip.installed:
    {% if ifproxy == True %}
    {% set proxy = salt['grains.get']('http_proxy', 'None') %}
    - proxy: {{ proxy }}
    {% endif %}
    - name: configparser>=3.3.0r2

configparser fallback:
  pip.installed:
    {% if ifproxy == True %}
    {% set proxy = salt['grains.get']('http_proxy', 'None') %}
    - proxy: {{ proxy }}
    {% endif %}
    - name: configparser>=3.3.0.post2
    - onfail:
      - pip: configparserus

download dir exists:
  file.directory:
    - name: /var/www/download
    - order: 1
    - mode: 755
    - makedirs: True

html dir exists:
  file.directory:
    - name: /var/www/html
    - order: 1
    - mode: 755
    - makedirs: True

add virl to libvirtd:
  group.present:
    - name: libvirtd
    - addusers: 
      - 'virl'

salt-minion nohold:
  file.absent:
    - name: /etc/apt/preferences.d/salt-minion

/proc/sys/kernel/numa_balancing:
  cmd.run:
    - name: echo 0 > /proc/sys/kernel/numa_balancing
    - onlyif: grep 1 /proc/sys/kernel/numa_balancing

/usr/local/bin/v6off jinja:
  file.managed:
    - name: /usr/local/bin/adjust-ipv6-sysctl.sh
    - mode: 755
    - source: salt://virl/files/adjust-ipv6-sysctl.sh
    - template: jinja

avahi no upstart:
  file.managed:
    - name: /etc/init/avahi-daemon.override
    - contents: |
        start on manual
        stop on manual

{% if salt['pillar.get']('virl:using_dhcp_on_the_public_port', salt['grains.get']('using_dhcp_on_the_public_port', True )) %}
network-manager no upstart:
  file.managed:
    - name: /etc/init/network-manager.override
    - contents: |
        start on manual
        stop on manual
{% else %}
network-manager no upstart:
  file.managed:
    - name: /etc/init/network-manager.override
    - contents: |
        start on manual
        stop on manual
{% endif %}

v6off-rclocal:
  file.blockreplace:
    - name: /etc/rc.local
    - require:
      - file: /usr/local/bin/v6off jinja
    - marker_start: "# 002s v6off"
    - marker_end: "# 002e"
    - content: |
             /usr/local/bin/adjust-ipv6-sysctl.sh

lxc bridge off in init:
  file.replace:
    - name: /etc/init/lxc-net.conf
    - pattern: '^USE_LXC_BRIDGE="true"'
    - repl: 'USE_LXC_BRIDGE="false"'

lxc bridge off in default:
  file.replace:
    - name: /etc/default/lxc-net
    - pattern: '^USE_LXC_BRIDGE="true"'
    - repl: 'USE_LXC_BRIDGE="false"'



