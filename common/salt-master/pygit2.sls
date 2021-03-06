{% set proxy = salt['pillar.get']('virl:proxy', salt['grains.get']('proxy', False)) %}
{% set http_proxy = salt['pillar.get']('virl:http_proxy', salt['grains.get']('http_proxy', 'https://proxy.esl.cisco.com:80/')) %}
{% set masterless = salt['pillar.get']('virl:salt_masterless', salt['grains.get']('salt_masterless', false)) %}

libgit2 prereqs:
  pkg.installed:
    - pkgs:
      - cmake
      - python-dev
      - libffi-dev
      - libssh2-1-dev

pygit2 prereq install:
  pip.installed:
{% if proxy %}
    - proxy: {{ http_proxy }}
{% endif %}
    - names:
      - pyopenssl
      - ndg-httpsclient
      - pyasn1


libgit2 pull:
  archive.extracted:
    - name: /tmp/
    - source: 'salt://common/salt-master/files/v0.22.0.tar.gz'
    - source_hash: md5=a8c689d4887cc085295dcf43c46f5f1f
    - archive_format: tar
    - if_missing: /tmp/libgit2-0.22.0
    - unless: test -e /usr/local/lib/libgit2.so.0.22.0
  cmd.run:
    - name: cmake .
    - cwd: /tmp/libgit2-0.22.0
    - require:
      - pkg: libgit2 prereqs
    - onchanges:
      - archive: libgit2 pull

cmake libgit2:
  cmd.run:
    - cwd: /tmp/libgit2-0.22.0
    - onchanges:
      - cmd: libgit2 pull
    - names:
      - 'make -s'
      - 'make -s install'


ldconfig always run:
  cmd.run:
    - name: ldconfig
    - require:
      - cmd: cmake libgit2


pygit2 install:
  pip.installed:
{% if proxy %}
    - proxy: {{ http_proxy }}
{% endif %}
    - name: pygit2 == 0.22.0

remove libgit trash:
  file.absent:
    - name: /tmp/libgit2-0.22.0
