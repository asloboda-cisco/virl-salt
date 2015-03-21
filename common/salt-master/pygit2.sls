{% set proxy = salt['pillar.get']('virl:proxy', salt['grains.get']('proxy', False)) %}
{% set http_proxy = salt['pillar.get']('virl:http_proxy', salt['grains.get']('http_proxy', 'https://proxy.esl.cisco.com:80/')) %}

libgit2 prereqs:
  pkg.installed:
    - pkgs:
      - cmake
      - python-dev
      - libffi-dev
      - libssh2-1-dev


libgit2 pull:
  archive.extracted:
    - name: /tmp/
    - source: http://github.com/libgit2/libgit2/archive/v0.22.0.tar.gz
    - source_hash: md5=a8c689d4887cc085295dcf43c46f5f1f
    - archive_format: tar
    - if_missing: /tmp/libgit2-0.22.0

cmake libgit2:
  cmd.run:
    - cwd: /tmp/libgit2-0.22.0
    - require:
      - pkg: libgit2 prereqs
      - archive: libgit2 pull
    - names:
      - cmake .
      - make
      - make install
      - ldconfig


pygit2 install:
  pip.installed:
{% if proxy == true %}
    - proxy: {{ http_proxy }}
{% endif %}
    - name: pygit2