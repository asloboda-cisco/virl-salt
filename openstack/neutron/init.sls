{% set rabbitpassword = salt['pillar.get']('virl:rabbitpassword', salt['grains.get']('password', 'password')) %}
{% set metapassword = salt['pillar.get']('virl:metapassword', salt['grains.get']('password', 'password')) %}
{% set ospassword = salt['pillar.get']('virl:password', salt['grains.get']('password', 'password')) %}
{% set mypassword = salt['pillar.get']('virl:mysql_password', salt['grains.get']('mysql_password', 'password')) %}
{% set neutronpassword = salt['pillar.get']('virl:neutronpassword', salt['grains.get']('password', 'password')) %}
{% set hostname = salt['pillar.get']('virl:hostname', salt['grains.get']('hostname', 'virl')) %}
{% set public_ip = salt['pillar.get']('virl:static_ip', salt['grains.get']('static_ip', '127.0.0.1' )) %}
{% set controllerip = salt['pillar.get']('virl:internalnet_controller_IP', salt['grains.get']('internalnet_controller_IP', '172.16.10.250')) %}
{% set l2_port2_enabled = salt['pillar.get']('virl:l2_port2_enabled', salt['grains.get']('l2_port2_enabled', 'True' )) %}
{% set l2_port = salt['pillar.get']('virl:l2_port', salt['grains.get']('l2_port', 'eth1' )) %}
{% set l2_network = salt['pillar.get']('virl:l2_network', salt['grains.get']('l2_network', '172.16.1.0/24' )) %}
{% set l2_gateway = salt['pillar.get']('virl:l2_network_gateway', salt['grains.get']('l2_network_gateway', '172.16.1.1' )) %}
{% set l2_start_address = salt['pillar.get']('virl:l2_start_address', salt['grains.get']('l2_start_address', '172.16.1.50' )) %}
{% set l2_end_address = salt['pillar.get']('virl:l2_end_address', salt['grains.get']('l2_end_address', '172.16.1.253' )) %}
{% set l2_address = salt['pillar.get']('virl:l2_address', salt['grains.get']('l2_address', '172.16.1.254' )) %}
{% set l2_address2 = salt['pillar.get']('virl:l2_address2', salt['grains.get']('l2_address2', '172.16.2.254' )) %}
{% set l3_port = salt['pillar.get']('virl:l3_port', salt['grains.get']('l3_port', 'eth3' )) %}
{% set l3_network = salt['pillar.get']('virl:l3_mask', salt['grains.get']('l3_network', '172.16.3.0/24' )) %}
{% set l3_mask = salt['pillar.get']('virl:l3_mask', salt['grains.get']('l3_mask', '255.255.255.0' )) %}
{% set l3_network_gateway = salt['pillar.get']('virl:l3_network_gateway', salt['grains.get']('l3_network_gateway', '172.16.3.1' )) %}
{% set l3_floating_start_address = salt['pillar.get']('virl:l3_floating_start_address', salt['grains.get']('l3_floating_start_address', '172.16.3.50' )) %}
{% set l3_floating_end_address = salt['pillar.get']('virl:l3_floating_end_address', salt['grains.get']('l3_floating_end_address', '172.16.3.253' )) %}
{% set l3_address = salt['pillar.get']('virl:l3_address', salt['grains.get']('l3_address', '172.16.3.254/24' )) %}
{% set l2_port2 = salt['pillar.get']('virl:l2_port2', salt['grains.get']('l2_port2', 'eth2' )) %}
{% set first_snat_nameserver = salt['pillar.get']('virl:first_snat_nameserver', salt['grains.get']('first_snat_nameserver', '8.8.8.8' )) %}
{% set second_snat_nameserver = salt['pillar.get']('virl:second_snat_nameserver', salt['grains.get']('second_snat_nameserver', '8.8.8.8' )) %}

{% set jumbo_frames = salt['pillar.get']('virl:jumbo_frames', salt['grains.get']('jumbo_frames', False )) %}
{% set neutid = salt['grains.get']('neutron_guestid', ' ') %}
{% set controllerip = salt['pillar.get']('virl:internalnet_controller_IP',salt['grains.get']('internalnet_controller_ip', '172.16.10.250')) %}
{% set controllerhostname = salt['pillar.get']('virl:internalnet_controller_hostname',salt['grains.get']('internalnet_controller_hostname', 'controller')) %}
{% set iscontroller = salt['pillar.get']('virl:iscontroller', salt['grains.get']('iscontroller', True)) %}
{% set masterless = salt['pillar.get']('virl:salt_masterless', salt['grains.get']('salt_masterless', false)) %}
{% set proxy = salt['pillar.get']('virl:proxy', salt['grains.get']('proxy', False)) %}
{% set http_proxy = salt['pillar.get']('virl:http_proxy', salt['grains.get']('http_proxy', 'https://proxy.esl.cisco.com:80/')) %}
{% set kilo = salt['pillar.get']('virl:kilo', salt['grains.get']('kilo', false)) %}

include:
  - openstack.keystone.setup

neutron linuxbridge unhold:
  module.run:
    - name: pkg.unhold
    - m_name: neutron-plugin-linuxbridge-agent

neutron-pkgs:
  pkg.installed:
    - force_yes: True
    - pkgs:
    {% if kilo %}
      - neutron-common: '1:2015.1.1-0ubuntu2~cloud2'
      - neutron-dhcp-agent: '1:2015.1.1-0ubuntu2~cloud2'
      - neutron-l3-agent: '1:2015.1.1-0ubuntu2~cloud2'
      - neutron-metadata-agent: '1:2015.1.1-0ubuntu2~cloud2'
      - neutron-plugin-linuxbridge-agent: '1:2015.1.1-0ubuntu2~cloud2'
      - neutron-plugin-linuxbridge: '1:2015.1.1-0ubuntu2~cloud2'
      - neutron-plugin-ml2: '1:2015.1.1-0ubuntu2~cloud2'
      - neutron-server: '1:2015.1.1-0ubuntu2~cloud2'
      - python-neutron: '1:2015.1.1-0ubuntu2~cloud2'
    {% else %}
      - neutron-common: '=1:2014.1.3-0ubuntu1.1'
      - neutron-dhcp-agent: '=1:2014.1.3-0ubuntu1.1'
      - neutron-l3-agent: '=1:2014.1.3-0ubuntu1.1'
      - neutron-metadata-agent: '=1:2014.1.3-0ubuntu1.1'
      - neutron-plugin-linuxbridge-agent: '=1:2014.1.3-0ubuntu1.1'
      - neutron-plugin-linuxbridge: '=1:2014.1.3-0ubuntu1.1'
      - neutron-plugin-ml2: '=1:2014.1.3-0ubuntu1.1'
      - neutron-server: '=1:2014.1.3-0ubuntu1.1'
      - python-neutron: '=1:2014.1.3-0ubuntu1.1'
    {% endif %}
  apt.held:
    - name: neutron-plugin-linuxbridge-agent

{% if not kilo %}

oslo prereq pin of hate:
  pip.installed:
{% if proxy == true %}
    - proxy: {{ http_proxy }}
{% endif %}
    - require:
      - pkg: neutron-pkgs
    - names:
      - oslo.messaging == 1.6.0
      - oslo.config == 1.6.0
      - pbr == 0.10.8
      - netaddr==0.7.15

{% endif %}

/etc/neutron/neutron.conf:
  file.managed:
    - template: jinja
    - makedirs: True
    - mode: 755
    {% if kilo %}
    - source: "salt://openstack/neutron/files/kilo.neutron.conf"
    {% else %}
    - source: "salt://openstack/neutron/files/neutron.conf"
    {% endif %}
    - require:
      - pkg: neutron-pkgs

{% if not kilo %}

/etc/neutron/plugins/linuxbridge/linuxbridge_conf.ini:
  file.managed:
    - template: jinja
    - mode: 755
    - makedirs: True
    {% if masterless %}
    - source: "file:///srv/salt/openstack/neutron/files/plugins/linuxbridge/linuxbridge_conf.ini"
    {% else %}
    - source: "salt://openstack/neutron/files/plugins/linuxbridge/linuxbridge_conf.ini"
    {% endif %}
    - require:
      - pkg: neutron-pkgs

{% endif %}

/etc/neutron/plugins/ml2/ml2_conf.ini:
  file.managed:
    - mode: 755
    - template: jinja
    - makedirs: True
    {% if kilo %}
    - source: "salt://openstack/neutron/files/plugins/ml2/kilo.ml2_conf.ini"
    {% else %}
    - source: "salt://openstack/neutron/files/plugins/ml2/ml2_conf.ini"
    {% endif %}
    - require:
      - pkg: neutron-pkgs

/etc/init/neutron-server.conf:
  file.managed:
    - mode: 644
    - makedirs: True
    {% if kilo %}
    - source: "salt://openstack/neutron/files/kilo.neutron-server.conf"
    {% else %}
    - source: "salt://openstack/neutron/files/neutron-server.conf"
    {% endif %}
    - require:
      - pkg: neutron-pkgs

neutron-sysctl:
  file.replace:
    - name: /etc/sysctl.conf
    - pattern: '#net.ipv4.conf.default.rp_filter=1'
    - repl: 'net.ipv4.conf.default.rp_filter=0'

neutron-sysctl2:
  file.replace:
    - name: /etc/sysctl.conf
    - pattern: '#net.ipv4.conf.all.rp_filter=1'
    - repl: 'net.ipv4.conf.all.rp_filter=0'

neutron-sysctlforward:
  file.replace:
    - name: /etc/sysctl.conf
    - pattern: '#net.ipv4.ip_forward=1'
    - repl: 'net.ipv4.ip_forward=1'


{% if jumbo_frames == True %}
neutron-mtu:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: 'DEFAULT'
    - parameter: 'network_device_mtu'
    - value: '9100'
    - require:
      - file: /etc/neutron/neutron.conf
{% endif %}


{% if l2_port2_enabled == false %}
neutron-provider-networks:
  openstack_config.present:
  {% if kilo %}
    - filename: /etc/neutron/neutron.conf
  {% else %}
    - filename: /etc/neutron/plugins/linuxbridge/linuxbridge_conf.ini
  {% endif %}
    - section: 'vlans'
    - parameter: 'network_vlan_ranges'
    - value: 'flat,ext-net'
    - require:
      - file: /etc/neutron/neutron.conf

neutron-provider-networks-phymap:
  openstack_config.present:
  {% if kilo %}
    - filename: /etc/neutron/neutron.conf
  {% else %}
    - filename: /etc/neutron/plugins/linuxbridge/linuxbridge_conf.ini
  {% endif %}
    - section: 'linux_bridge'
    - parameter: 'physical_interface_mappings'
    - value: 'flat:{{ l2_port }},ext-net:{{ l3_port }}'
{% endif %}

## if needs to go here for non controller
{% if iscontroller == False %}

neutron-hostname:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: 'DEFAULT'
    - parameter: 'nova_url'
    - value: 'http://{{ controllerhostname }}:8774/v2'
    - require:
      - file: /etc/neutron/neutron.conf

neutron-hostname2:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: 'DEFAULT'
    - parameter: 'nova_admin_auth_url'
    - value: 'http://{{ controllerhostname }}:35357/v2.0'
    - require:
      - file: /etc/neutron/neutron.conf

neutron-hostname3:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: 'keystone_authtoken'
    - parameter: 'auth_uri'
    {% if kilo %}
    - value: 'http://{{ controllerhostname }}:35357/v2.0/'
    {% else %}
    - value: 'http://{{ controllerhostname }}:5000'
    {% endif %}
    - require:
      - file: /etc/neutron/neutron.conf

  {% if kilo %}
neutron-hostname-indentity:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: 'keystone_authtoken'
    - parameter: 'identity_uri'
    - value: 'http://{{ controllerhostname }}:5000'
    - require:
      - file: /etc/neutron/neutron.conf
  {% endif %}

neutron-hostname4:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: 'keystone_authtoken'
    - parameter: 'auth_host'
    - value: '{{ controllerhostname }}'
    - require:
      - file: /etc/neutron/neutron.conf


{% endif %}

neutron-dhcp-nameserver:
  openstack_config.present:
    - filename: /etc/neutron/dhcp_agent.ini
    - section: 'DEFAULT'
    - parameter: 'dnsmasq_dns_servers'
    - value: '{{ first_snat_nameserver }},{{ second_snat_nameserver }}'
    - require:
      - file: /etc/neutron/neutron.conf

meta-tenname:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: 'DEFAULT'
    - parameter: 'admin_tenant_name'
    - value: 'service'
    - require:
      - pkg: neutron-pkgs

meta-user:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: 'DEFAULT'
    - parameter: 'admin_user'
    - value: 'neutron'
    - require:
      - pkg: neutron-pkgs

meta-pass:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: 'DEFAULT'
    - parameter: 'admin_password'
    - value: '{{ ospassword }}'
    - require:
      - pkg: neutron-pkgs

meta-meta:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: 'DEFAULT'
    - parameter: 'nova_metadata_ip'
    - value: ' {{ public_ip }}'
    - require:
      - pkg: neutron-pkgs

l3-interface:
  openstack_config.present:
    - filename: /etc/neutron/l3_agent.ini
    - section: 'DEFAULT'
    - parameter: 'interface_driver'
    - value: ' neutron.agent.linux.interface.BridgeInterfaceDriver'
    - require:
      - pkg: neutron-pkgs

l3-agent:
  openstack_config.present:
    - filename: /etc/neutron/l3_agent.ini
    - section: 'DEFAULT'
    - parameter: 'l3_agent_manager'
    - value: ' neutron.agent.l3_agent.L3NATAgentWithStateReport'
    - require:
      - pkg: neutron-pkgs

l3-mtu:
  openstack_config.present:
    - filename: /etc/neutron/l3_agent.ini
    - section: 'DEFAULT'
    - parameter: 'network_device_mtu'
    - value: '1500'
    - require:
      - pkg: neutron-pkgs


dhcp-interface:
  openstack_config.present:
    - filename: /etc/neutron/dhcp_agent.ini
    - section: DEFAULT
    - parameter: 'interface_driver'
    - value: ' neutron.agent.linux.interface.BridgeInterfaceDriver'
    - require:
      - pkg: neutron-pkgs

dhcp-namespace:
  openstack_config.present:
    - filename: /etc/neutron/dhcp_agent.ini
    - section: DEFAULT
    - parameter: 'use_namespaces'
    - value: ' True'
    - require:
      - pkg: neutron-pkgs

dhcp-driver:
  openstack_config.present:
    - filename: /etc/neutron/dhcp_agent.ini
    - section: DEFAULT
    - parameter: 'dhcp_driver'
    - value: ' neutron.agent.linux.dhcp.Dnsmasq'
    - require:
      - pkg: neutron-pkgs

l3-namespace:
  openstack_config.present:
    - filename: /etc/neutron/l3_agent.ini
    - section: 'DEFAULT'
    - parameter: 'use_namespaces'
    - value: ' True'
    - require:
      - pkg: neutron-pkgs

l3-dhcp:
  openstack_config.present:
    - filename: /etc/neutron/l3_agent.ini
    - section: 'DEFAULT'
    - parameter: 'dhcp_driver'
    - value: ' neutron.agent.linux.dhcp.Dnsmasq'
    - require:
      - pkg: neutron-pkgs

l3-netbridge:
  openstack_config.present:
    - filename: /etc/neutron/l3_agent.ini
    - section: 'DEFAULT'
    - parameter: 'external_network_bridge'
    - value: ' '
    - require:
      - pkg: neutron-pkgs

l3-gateway:
  openstack_config.present:
    - filename: /etc/neutron/l3_agent.ini
    - section: 'DEFAULT'
    - parameter: 'gateway_external_network_id'
    - value: ' '
    - require:
      - pkg: neutron-pkgs

{% if kilo %}
/etc/neutron/rootwrap.d/linuxbridge-plugin.filters:
  file.managed:
    - source: "salt://openstack/neutron/files/kilo.linuxbridge-plugin.filters"
    - require:
      - pkg: neutron-pkgs

/usr/lib/python2.7/dist-packages/neutron/agent/linux/ip_lib.py:
  file.managed:
    - source: salt://openstack/neutron/files/kilo/ip_lib.py
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/neutron/agent/linux/ip_lib.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/neutron/agent/linux/ip_lib.py
    - require:
      - pkg: neutron-pkgs

/usr/lib/python2.7/dist-packages/neutron/plugins/linuxbridge/agent/linuxbridge_neutron_agent.py:
  file.managed:
    - source: salt://openstack/neutron/files/kilo/linuxbridge_neutron_agent.py
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/neutron/plugins/linuxbridge/agent/linuxbridge_neutron_agent.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/neutron/plugins/linuxbridge/agent/linuxbridge_neutron_agent.py
    - require:
      - pkg: neutron-pkgs

/usr/lib/python2.7/dist-packages/neutron/plugins/linuxbridge/common/config.py:
  file.managed:
    - source: salt://openstack/neutron/files/kilo/config.py
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/neutron/plugins/linuxbridge/common/config.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/neutron/plugins/linuxbridge/common/config.py
    - require:
      - pkg: neutron-pkgs

/usr/lib/python2.7/dist-packages/neutron/plugins/ml2/plugin.py:
  file.managed:
    - source: salt://openstack/neutron/files/kilo/plugin.py
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/neutron/plugins/ml2/plugin.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/neutron/plugins/ml2/plugin.py
    - require:
      - pkg: neutron-pkgs

/usr/lib/python2.7/dist-packages/neutron/plugins/ml2/rpc.py:
  file.managed:
    - source: salt://openstack/neutron/files/kilo/rpc.py
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/neutron/plugins/ml2/rpc.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/neutron/plugins/ml2/rpc.py
    - require:
      - pkg: neutron-pkgs

{% for each in ['server','dhcp-agent','l3-agent','metadata-agent','plugin-linuxbridge-agent'] %}
neutron-{{each}} conf:
  file.replace:
    - name: /etc/init/neutron-{{each}}.conf
    - pattern: '^start on runlevel \[2345\]'
    - repl: 'start on (rabbitmq-server-running or started rabbitmq-server)'
{% endfor %}

{% else %}

/srv/salt/openstack/neutron/files/lb_neutron_plugin.py.diff:
  file.managed:
    - makedirs: True
    - mode: 755
    - contents: |
        102a103,105
        >                      'device_id': port['device_id'],
        >                      'device_owner': port['device_owner'],
        >                      'mac_address': port['mac_address'],
        112a116
        >         LOG.info('RPC returning %s', entry)


/srv/salt/openstack/neutron/files/l3.py.diff:
  file.managed:
    - makedirs: True
    - mode: 755
    - contents: |
        --- a/extensions/l3.py  2014-07-10 12:28:49.715740324 +0200
        +++ b/extensions/l3.py  2014-07-03 15:15:51.414240207 +0200
        @@ -107,7 +107,8 @@
                        'validate': {'type:uuid': None},
                        'is_visible': True,
                        'primary_key': True},
        -        'floating_ip_address': {'allow_post': False, 'allow_put': False,
        +        'floating_ip_address': {'allow_post': True, 'allow_put': False,
        +                                'default': attr.ATTR_NOT_SPECIFIED,
                                         'validate': {'type:ip_address_or_none': None},
                                         'is_visible': True},
                 'floating_network_id': {'allow_post': True, 'allow_put': False,


/srv/salt/openstack/neutron/files/l3_db.diff:
  file.managed:
    - makedirs: True
    - mode: 755
    - contents: |
        --- a/db/l3_db.py       2014-07-10 12:27:57.230986451 +0200
        +++ b/db/l3_db.py       2014-07-03 15:15:52.438764715 +0200
        @@ -614,6 +614,10 @@
                     msg = _("Network %s is not a valid external network") % f_net_id
                     raise n_exc.BadRequest(resource='floatingip', msg=msg)

        +        floating_ip_address = fip['floating_ip_address']
        +        if floating_ip_address is not attributes.ATTR_NOT_SPECIFIED:
        +            floating_ip_address = [{'ip_address': floating_ip_address}]
        +
                 with context.session.begin(subtransactions=True):
                     # This external port is never exposed to the tenant.
                     # it is used purely for internal system and admin use when
        @@ -623,7 +627,7 @@
                         {'tenant_id': '',  # tenant intentionally not set
                          'network_id': f_net_id,
                          'mac_address': attributes.ATTR_NOT_SPECIFIED,
        -                 'fixed_ips': attributes.ATTR_NOT_SPECIFIED,
        +                 'fixed_ips': floating_ip_address,
                          'admin_state_up': True,
                          'device_id': fip_id,
                          'device_owner': DEVICE_OWNER_FLOATINGIP,



/srv/salt/openstack/neutron/files/ml2_rpc.diff:
  file.managed:
    - makedirs: True
    - mode: 755
    - contents: |
        149a150,152
        >                      'device_id': port.device_id,
        >                      'device_owner': port.device_owner,
        >                      'mac_address': port.mac_address,


/usr/lib/python2.7/dist-packages/neutron/plugins/linuxbridge/lb_neutron_plugin.py:
  file.patch:
    - source: file:///srv/salt/openstack/neutron/files/lb_neutron_plugin.py.diff
    - hash: md5=7560254626099a5dec158518f47b2d87
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/neutron/plugins/linuxbridge/lb_neutron_plugin.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/neutron/plugins/linuxbridge/lb_neutron_plugin.py
    - require:
      - pkg: neutron-pkgs
      - file: /srv/salt/openstack/neutron/files/lb_neutron_plugin.py.diff


/usr/lib/python2.7/dist-packages/neutron/plugins/ml2/rpc.py:
  file.managed:
    - source: salt://openstack/neutron/files/plugins/ml2/rpc.py
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/neutron/plugins/ml2/rpc.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/neutron/plugins/ml2/rpc.py
    - require:
      - pkg: neutron-pkgs


/etc/neutron/rootwrap.d/linuxbridge-plugin.filters:
  file.managed:
    - source: "salt://openstack/neutron/files/linuxbridge-plugin.filters"
    - require:
      - pkg: neutron-pkgs

linuxbridge_neutron_agent:
  file.managed:
    - source: "salt://openstack/neutron/files/linuxbridge_neutron_agent.py"
    - name: /usr/lib/python2.7/dist-packages/neutron/plugins/linuxbridge/agent/linuxbridge_neutron_agent.py

ip_lib for mtu:
  file.managed:
    - source: "salt://openstack/neutron/files/ip_lib.py"
    - name: /usr/lib/python2.7/dist-packages/neutron/agent/linux/ip_lib.py
  cmd.run:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/neutron/agent/linux/ip_lib.py

config.py for multicast bridge:
  file.managed:
    - source: "salt://openstack/neutron/files/plugins/linuxbridge/config.py"
    - name: /usr/lib/python2.7/dist-packages/neutron/plugins/linuxbridge/common/config.py
  cmd.run:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/neutron/plugins/linuxbridge/common/config.py


compile linuxbridge:
  cmd.run:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/neutron/plugins/linuxbridge/agent/linuxbridge_neutron_agent.py
    - onchanges:
      - file: linuxbridge_neutron_agent


/usr/lib/python2.7/dist-packages/neutron/extensions/l3.py:
  file.patch:
    - source: file:///srv/salt/openstack/neutron/files/l3.py.diff
    - hash: md5=3739e6a7463a3e2102b76d1cc3ebeff6
    - require:
      - pkg: neutron-pkgs
      - file: /srv/salt/openstack/neutron/files/l3.py.diff
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/neutron/extensions/l3.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/neutron/extensions/l3.py



/usr/lib/python2.7/dist-packages/neutron/db/l3_db.py:
  file.patch:
    - source: file:///srv/salt/openstack/neutron/files/l3_db.diff
    - hash: md5=c99c80ba6aa209fcd046a972af51a914
    - require:
      - pkg: neutron-pkgs
      - file: /srv/salt/openstack/neutron/files/l3_db.diff
  cmd.wait:
    - names:
      - python -m compileall /usr/lib/python2.7/dist-packages/neutron/db/l3_db.py
    - watch:
      - file: /usr/lib/python2.7/dist-packages/neutron/db/l3_db.py
{% endif %}

linuxbridge hold:
  apt.held:
    - name: neutron-plugin-linuxbridge-agent
    - require:
      - pkg: neutron-pkgs

neutron lxc bridge off in init:
  file.replace:
    - name: /etc/init/lxc-net.conf
    - pattern: '^USE_LXC_BRIDGE="true"'
    - repl: 'USE_LXC_BRIDGE="false"'

neutron lxc bridge off in default:
  file.replace:
    - name: /etc/default/lxc-net
    - pattern: '^USE_LXC_BRIDGE="true"'
    - repl: 'USE_LXC_BRIDGE="false"'

{% if kilo %}

neutron restart:
  cmd.run:
    - order: last
    - name: |
        su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade kilo" neutron
        service neutron-server restart | at now + 1 min
        service neutron-dhcp-agent restart | at now + 1 min
        service neutron-l3-agent restart | at now + 1 min
        service neutron-metadata-agent restart | at now + 1 min
        service neutron-plugin-linuxbridge-agent restart | at now + 1 min
        sleep 65
{% else %}
neutron restart:
  cmd.run:
    - order: last
    - name: |
        service neutron-server restart
        service neutron-dhcp-agent restart
        service neutron-l3-agent restart
        service neutron-metadata-agent restart
        service neutron-plugin-linuxbridge-agent restart
{% endif %}
neutron sysctl:
  cmd.run:
    - name: 'sysctl -p'
    - onchanges:
      - file: /etc/sysctl.conf
