{% set public_ip = salt['pillar.get']('virl:static_ip', salt['grains.get']('static_ip', '127.0.0.1' )) %}
{% set serstart = salt['pillar.get']('virl:start_of_serial_port_range', salt['grains.get']('start_of_serial_port_range', '17000')) %}
{% set serend = salt['pillar.get']('virl:end_of_serial_port_range', salt['grains.get']('end_of_serial_port_range', '18000')) %}
{% set ramdisk = salt['pillar.get']('virl:ramdisk', salt['grains.get']('ramdisk', False)) %}
{% set hostname = salt['pillar.get']('virl:hostname', salt['grains.get']('hostname', 'virl')) %}
{% set mypassword = salt['pillar.get']('virl:mysql_password', salt['grains.get']('mysql_password', 'password')) %}
{% set ospassword = salt['pillar.get']('virl:password', salt['grains.get']('password', 'password')) %}
{% set rabbitpassword = salt['pillar.get']('virl:rabbitpassword', salt['grains.get']('password', 'password')) %}
{% set neutronpassword = salt['pillar.get']('virl:neutronpassword', salt['grains.get']('password', 'password')) %}
{% set novapassword = salt['pillar.get']('virl:novapassword', salt['grains.get']('password', 'password')) %}
{% set iscontroller = salt['pillar.get']('virl:iscontroller', salt['grains.get']('iscontroller', True)) %}
{% set controllerip = salt['pillar.get']('virl:internalnet_controller_IP',salt['grains.get']('internalnet_controller_ip', '172.16.10.250')) %}
{% set controllerhostname = salt['pillar.get']('virl:internalnet_controller_hostname',salt['grains.get']('internalnet_controller_hostname', 'controller')) %}
{% set masterless = salt['pillar.get']('virl:salt_masterless', salt['grains.get']('salt_masterless', false)) %}
{% set http_proxy = salt['pillar.get']('virl:http_proxy', salt['grains.get']('http_proxy', 'https://proxy.esl.cisco.com:80/')) %}
{% set proxy = salt['pillar.get']('virl:proxy', salt['grains.get']('proxy', False)) %}
{% set kilo = salt['pillar.get']('virl:kilo', salt['grains.get']('kilo', false)) %}

include:
  - virl.ramdisk
  - common.kvm

nova-api:
  pkg.installed:
    - name: nova-api
    - refresh: true

nova-pkgs:
  pkg.installed:
    - refresh: False
    - require:
      - pkg: nova-api
    - names:
      - nova-cert
      - nova-conductor
      - nova-compute
      - python-guestfs
      - nova-consoleauth
      - nova-novncproxy
      - nova-scheduler
      - nova-serialproxy
      - python-novaclient

{% if not kilo %}
oslo messaging 11 prevent:
  pip.installed:
{% if proxy == true %}
    - proxy: {{ http_proxy }}
{% endif %}
    - require:
      - pkg: nova-pkgs
    - names:
      - oslo.messaging == 1.6.0
      - oslo.config == 1.6.0
      - pbr == 0.10.8
{% endif %}

/etc/nova:
  file.directory:
    - dir_mode: 755

/etc/nova/nova.conf:
  file.managed:
    - mode: 755
    - template: jinja
    {% if kilo %}
    - source: "salt://openstack/nova/files/kilo.nova.conf"
    {% else %}
    - source: "salt://openstack/nova/files/nova.conf"
    {% endif %}
    - require:
      - pkg: nova-pkgs

add libvirt-qemu to nova:
  group.present:
    - name: nova
    - delusers:
      - libvirt-qemu

{% if kilo %}
/usr/lib/python2.7/dist-packages/nova/cmd/serialproxy.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/serialproxy.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/cmd/serialproxy.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/cmd/serialproxy.py

/usr/lib/python2.7/dist-packages/nova/cmd/baseproxy.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/baseproxy.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/cmd/baseproxy.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/cmd/baseproxy.py


/usr/lib/python2.7/dist-packages/nova/api/openstack/compute/contrib/consoles.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/consoles.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/api/openstack/compute/contrib/consoles.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/api/openstack/compute/contrib/consoles.py

/usr/lib/python2.7/dist-packages/nova/api/openstack/compute/plugins/v3/remote_consoles.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/plugin.remote_consoles.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/api/openstack/compute/plugins/v3/remote_consoles.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/api/openstack/compute/plugins/v3/remote_consoles.py

/usr/lib/python2.7/dist-packages/nova/api/openstack/compute/schemas/v3/remote_consoles.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/schemas.remote_consoles.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/api/openstack/compute/schemas/v3/remote_consoles.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/api/openstack/compute/schemas/v3/remote_consoles.py

/usr/lib/python2.7/dist-packages/nova/compute/api.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/api.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/compute/api.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/compute/api.py

/usr/lib/python2.7/dist-packages/nova/compute/cells_api.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/cells_api.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/compute/cells_api.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/compute/cells_api.py

/usr/lib/python2.7/dist-packages/nova/compute/manager.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/manager.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/compute/manager.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/compute/manager.py

/usr/lib/python2.7/dist-packages/nova/compute/rpcapi.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/rpcapi.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/compute/rpcapi.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/compute/rpcapi.py

/usr/lib/python2.7/dist-packages/nova/console/websocketproxy.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/websocketproxy.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/console/websocketproxy.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/console/websocketproxy.py

/usr/lib/python2.7/dist-packages/nova/exception.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/exception.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/exception.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/exception.py

/usr/lib/python2.7/dist-packages/nova/network/model.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/model.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/network/model.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/network/model.py

/usr/lib/python2.7/dist-packages/nova/virt/configdrive.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/configdrive.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/virt/configdrive.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/virt/configdrive.py

/usr/lib/python2.7/dist-packages/nova/virt/driver.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/virt.driver.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/virt/driver.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/virt/driver.py

/usr/lib/python2.7/dist-packages/nova/virt/libvirt/driver.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/libvirt.driver.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/virt/libvirt/driver.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/virt/libvirt/driver.py

/usr/lib/python2.7/dist-packages/nova/virt/hardware.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/hardware.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/virt/hardware.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/virt/hardware.py

/usr/lib/python2.7/dist-packages/nova/virt/libvirt/config.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/config.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/virt/libvirt/config.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/virt/libvirt/config.py

/usr/lib/python2.7/dist-packages/nova/virt/libvirt/vif.py:
  file.managed:
    - source: salt://openstack/nova/files/kilo/vif.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/virt/libvirt/vif.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/virt/libvirt/vif.py

{% for each in ['cert','api','serialproxy','conductor','compute','scheduler','novncproxy','consoleauth'] %}
nova-{{each}} conf:
  file.replace:
    - name: /etc/init/nova-{{each}}.conf
    - pattern: '^start on runlevel \[2345\]'
    - repl: 'start on (rabbitmq-server-running or started rabbitmq-server)'
{% endfor %}


{% else %}
cmd/serialproxy.py replace:
  file.managed:
    - source: salt://openstack/nova/patch/serialproxy.py
    - name: /usr/lib/python2.7/dist-packages/nova/cmd/serialproxy.py
    - require:
      - pkg: nova-pkgs
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/cmd/serialproxy.py
    - watch:
      - file: cmd/serialproxy.py replace


/srv/salt/openstack/nova/patch/driver.diff:
  file.managed:
    - makedirs: True
    - mode: 755
    - contents: |
        --- driver.py	2014-07-10 13:22:21.000000000 +0000
        +++ driver_new.py	2015-03-11 08:21:52.874891547 +0000
        @@ -56,7 +56,6 @@
         from eventlet import greenthread
         from eventlet import patcher
         from eventlet import tpool
        -from eventlet import util as eventlet_util
         from lxml import etree
         from oslo.config import cfg

        @@ -622,12 +621,10 @@
                 except (ImportError, NotImplementedError):
                     # This is Windows compatibility -- use a socket instead
                     #  of a pipe because pipes don't really exist on Windows.
        -            sock = eventlet_util.__original_socket__(socket.AF_INET,
        -                                                     socket.SOCK_STREAM)
        +            sock = native_socket.socket(socket.AF_INET,socket.SOCK_STREAM)
                     sock.bind(('localhost', 0))
                     sock.listen(50)
        -            csock = eventlet_util.__original_socket__(socket.AF_INET,
        -                                                      socket.SOCK_STREAM)
        +            csock = native_socket.socket(socket.AF_INET,socket.SOCK_STREAM)
                     csock.connect(('localhost', sock.getsockname()[1]))
                     nsock, addr = sock.accept()
                     self._event_notify_send = nsock.makefile('wb', 0)
        @@ -2448,6 +2445,8 @@
                     return None

                 host = CONF.serial_port_proxyclient_address
        +        if host == '0.0.0.0':
        +            host = utils.get_my_ipv4_address()

                 # Return a descriptor for a raw TCP socket
                 return {'host': host, 'port': tcp_port, 'internal_access_path': None}

libvirt/driver.py patch:
  file.patch:
    - name: /usr/lib/python2.7/dist-packages/nova/virt/libvirt/driver.py
    - source: file:///srv/salt/openstack/nova/patch/driver.diff
    - hash: md5=df19fdc44c86233f098e5b44d64e21bb
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/virl/libvirt/driver.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/nova/virt/libvirt/driver.py
    - require:
      - file: /srv/salt/openstack/nova/patch/driver.diff
      - pkg: nova-pkgs

libvirt/driver.py replace:
  file.managed:
    - source: salt://openstack/nova/patch/driver.py
    - name: /usr/lib/python2.7/dist-packages/nova/virt/libvirt/driver.py
    - onfail:
      - file: libvirt/driver.py patch
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/nova/virl/libvirt/driver.py
    - watch:
      - file: libvirt/driver.py replace

{% endif %}
## if needs to go here for non controller
{% if iscontroller == False %}

nova-conn:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: 'database'
    - parameter: 'connection'
    - value: 'mysql://nova:{{ mypassword }}@{{ controllerhostname }}/nova'
    - require:
      - file: /etc/nova/nova.conf

nova-hostname1:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: 'DEFAULT'
    - parameter: 'neutron_url'
    - value: 'http://{{ controllerhostname }}:9696'
    - require:
      - file: /etc/nova/nova.conf

nova-hostname2:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: 'DEFAULT'
    - parameter: 'neutron_admin_auth_url'
    - value: 'http://{{ controllerhostname }}:35357/v2.0'
    - require:
      - file: /etc/nova/nova.conf

nova-hostname3:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: 'DEFAULT'
    - parameter: 'rabbit_host'
    - value: '{{ controllerhostname }}'
    - require:
      - file: /etc/nova/nova.conf

nova-hostname4:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: 'keystone_authtoken'
    - parameter: 'auth_uri'
    - value: 'http://{{ controllerhostname }}:5000'
    - require:
      - file: /etc/nova/nova.conf

nova-hostname5:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: 'keystone_authtoken'
    - parameter: 'auth_host'
    - value: '{{ controllerhostname }}'
    - require:
      - file: /etc/nova/nova.conf

{% endif %}

{% if kilo %}
/etc/nova/policy.json:
  file.managed:
    - source: "salt://openstack/nova/files/kilo.policy.json"
    - user: nova
    - group: nova
    - mode: 0640
    - require:
      - pkg: nova-pkgs

/usr/share/nova-serial/serial.html:
  file.managed:
    - source: "salt://openstack/nova/files/kilo.serial.html"
    - makedirs: True
    - user: nova
    - group: nova
    - mode: 0644
    - require:
      - pkg: nova-pkgs

/usr/lib/python2.7/dist-packages/nova/console/serial.html:
  file.managed:
    - source: "salt://openstack/nova/files/kilo.serial.html"
    - user: nova
    - group: nova
    - mode: 0644
    - require:
      - pkg: nova-pkgs

/usr/share/nova-serial/term.js:
  file.managed:
    - source: "salt://openstack/nova/files/term.js"
    - makedirs: True
    - user: nova
    - group: nova
    - mode: 0644
    - require:
      - pkg: nova-pkgs

/usr/lib/python2.7/dist-packages/nova/console/term.js:
  file.managed:
    - source: "salt://openstack/nova/files/term.js"
    - user: nova
    - group: nova
    - mode: 0644
    - require:
      - pkg: nova-pkgs

{% else %}



/etc/nova/policy.json:
  file.managed:
    - source: "salt://openstack/nova/files/policy.json"
    - user: nova
    - group: nova
    - mode: 0640
    - require:
      - pkg: nova-pkgs

/usr/share/nova-serial/serial.html:
  file.managed:
    - source: "salt://openstack/nova/files/serial.html"
    - user: nova
    - group: nova
    - mode: 0644
    - require:
      - pkg: nova-pkgs

/usr/lib/python2.7/dist-packages/nova/console/serial.html:
  file.managed:
    - source: "salt://openstack/nova/files/serial.html"
    - user: nova
    - group: nova
    - mode: 0644
    - require:
      - pkg: nova-pkgs

{% endif %}
/etc/init.d/nova-serialproxy:
  file.managed:
    - source: "salt://openstack/nova/files/nova-serialproxy"
    - force: True
    - mode: 0755
    - require:
      - pkg: nova-pkgs

nova-compute serial:
  openstack_config.present:
    - filename: /etc/nova/nova-compute.conf
    - section: 'libvirt'
    - parameter: 'serial_port_range'
    - value: '{{ serstart }}:{{ serend }}'
    - require:
      - file: /etc/nova/nova.conf

/etc/rc2.d/S98nova-serialproxy:
  file.absent

/usr/share/novnc/vnc_auto.html:
  file.managed:
    - source: "salt://openstack/nova/files/vnc_auto.html"
    - user: nova
    - group: nova
    - mode: 0644
    - require:
      - pkg: nova-pkgs

/home/virl/.novaclient:
  file.directory:
    - user: virl
    - group: virl
    - recurse:
      - user
      - group

nova-restart:
  cmd.run:
    - order: last
    - require:
      - pkg: nova-pkgs
      - file: /etc/nova/nova.conf
      - file: /etc/init.d/nova-serialproxy
    - name: |
        su -s /bin/sh -c "glance-manage db_sync" glance
        su -s /bin/sh -c "nova-manage db sync" nova
        'dpkg-statoverride  --update --add root root 0644 /boot/vmlinuz-$(uname -r)'
        service nova-cert restart
        service nova-api restart
        service nova-consoleauth restart
        service nova-scheduler restart
        service nova-conductor restart
        service nova-compute restart
        service nova-novncproxy restart
        service nova-serialproxy restart
