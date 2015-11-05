{% set nxosv9k = salt['pillar.get']('routervms:nxosv9k', False) %}
{% set nxosv9kpref = salt['pillar.get']('virl:nxosv9k', salt['grains.get']('nxosv9k', True)) %}

{% if nxosv9k and nxosv9kpref %}

get_efibios:
  file.managed:
    - name: /usr/share/qemu/n9kbios.bin
    - makedirs: True
    - source:
      - salt://virl/files/n9kbios.bin
    - source_hash: 776934a17d88b515355c072533f66464

{% endif %}
