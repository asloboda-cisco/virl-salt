{% set csr1000vpref = salt['pillar.get']('virl:csr1000v', salt['grains.get']('csr1000v', True)) %}
{% set csr1000v = salt['pillar.get']('routervms:csr1000v', False) %}

include:
  - virl.routervms.virl-core-sync

{% if csr1000v and csr1000vpref %}
CSR1000v:
  glance.image_present:
  - profile: virl
  - name: 'CSR1000v'
  - container_format: bare
  - min_disk: 8
  - min_ram: 0
  - is_public: True
  - checksum: d787607cf197aa19be8d4ab0a1b376f1
  - protected: False
  - disk_format: qcow2
  - copy_from: salt://images/salt/csr1000v-universalk9.03.16.00.S.155-3.S-ext.vmdk
  - property-config_disk_type: cdrom
  - property-hw_cdrom_type: ide
  - property-hw_disk_bus: virtio
  - property-hw_vif_model: e1000
  - property-release: 3.16
  - property-serial: 2
  - property-subtype: CSR1000v

CSR1000v flavor delete:
  cmd.run:
    - name: 'source /usr/local/bin/virl-openrc.sh ;nova flavor-delete "CSR1000v"'
    - onlyif: source /usr/local/bin/virl-openrc.sh ;nova flavor-show "CSR1000v"
    - onchanges:
      - glance: CSR1000v

CSR1000v flavor create:
  module.run:
    - name: nova.flavor_create
    - m_name: 'CSR1000v'
    - ram: 3072
    - disk: 0
    - vcpus: 1
    - onchanges:
      - glance: CSR1000v
    - require:
      - cmd: CSR1000v flavor delete

{% else %}

CSR1000v gone:
  glance.image_absent:
  - profile: virl
  - name: 'CSR1000v'

CSR1000v flavor absent:
  cmd.run:
    - name: 'source /usr/local/bin/virl-openrc.sh ;nova flavor-delete "CSR1000v"'
    - onlyif: source /usr/local/bin/virl-openrc.sh ;nova flavor-list | grep -w "CSR1000v"
{% endif %}
