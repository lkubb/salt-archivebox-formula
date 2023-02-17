# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as archivebox with context %}

include:
  - {{ sls_config_clean }}

{%- if archivebox.install.autoupdate_service %}

Podman autoupdate service is disabled for ArchiveBox:
{%-   if archivebox.install.rootless %}
  compose.systemd_service_disabled:
    - user: {{ archivebox.lookup.user.name }}
{%-   else %}
  service.disabled:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}

ArchiveBox is absent:
  compose.removed:
    - name: {{ archivebox.lookup.paths.compose }}
    - volumes: {{ archivebox.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if archivebox.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ archivebox.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if archivebox.install.rootless %}
    - user: {{ archivebox.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

ArchiveBox compose file is absent:
  file.absent:
    - name: {{ archivebox.lookup.paths.compose }}
    - require:
      - ArchiveBox is absent

{%- if archivebox.install.podman_api %}

ArchiveBox podman API is unavailable:
  compose.systemd_service_dead:
    - name: podman
    - user: {{ archivebox.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ archivebox.lookup.user.name }}

ArchiveBox podman API is disabled:
  compose.systemd_service_disabled:
    - name: podman
    - user: {{ archivebox.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ archivebox.lookup.user.name }}
{%- endif %}

ArchiveBox user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ archivebox.lookup.user.name }}
    - enable: false
    - onlyif:
      - fun: user.info
        name: {{ archivebox.lookup.user.name }}

ArchiveBox user account is absent:
  user.absent:
    - name: {{ archivebox.lookup.user.name }}
    - purge: {{ archivebox.install.remove_all_data_for_sure }}
    - require:
      - ArchiveBox is absent
    - retry:
        attempts: 5
        interval: 2

{%- if archivebox.install.remove_all_data_for_sure %}

ArchiveBox paths are absent:
  file.absent:
    - names:
      - {{ archivebox.lookup.paths.base }}
    - require:
      - ArchiveBox is absent
{%- endif %}
