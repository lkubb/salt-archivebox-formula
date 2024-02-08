# vim: ft=yaml
---
archivebox:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    compose:
      create_pod: null
      pod_args: null
      project_name: archivebox
      remove_orphans: true
      build: false
      build_args: null
      pull: false
      service:
        container_prefix: null
        ephemeral: true
        pod_prefix: null
        restart_policy: on-failure
        restart_sec: 2
        separator: null
        stop_timeout: null
    paths:
      base: /opt/containers/archivebox
      compose: docker-compose.yml
      config_archivebox: archivebox.env
      config_sonic: sonic.env
      config_pihole: pihole.env
      config_pywb: pywb.env
      data: data
      data_archive: archive
      data_dnsmasq: dnsmasq
      data_pihole: pihole
      data_pywb: pywb
      data_sonic: sonic
      sonic_cfg: sonic.cfg
    user:
      groups: []
      home: null
      name: archivebox
      shell: /usr/sbin/nologin
      uid: null
      gid: null
    containers:
      archivebox:
        image: docker.io/archivebox/archivebox:latest
      pihole:
        image: docker.io/pihole/pihole:latest
      pywb:
        image: docker.io/webrecorder/pywb:latest
      sonic:
        image: docker.io/valeriansaliou/sonic:v1.3.1
  install:
    rootless: true
    autoupdate: true
    autoupdate_service: false
    remove_all_data_for_sure: false
    podman_api: true
  config:
    search_backend:
      search_backend_host_name: sonic
      search_backend_password: null
    server:
      bind_addr: 0.0.0.0:4180
      secret_key: null
  pihole:
    config:
      webpassword: null
    enable: false
    webui_port: 1073
  pywb:
    enable: false
  sonic:
    config:
      channel:
        auth_password: ${env.SEARCH_BACKEND_PASSWORD}
        inet: 0.0.0.0:1491
        search:
          query_alternates_try: 10
          query_limit_default: 65535
          query_limit_maximum: 65535
          suggest_limit_default: 5
          suggest_limit_maximum: 20
        tcp_timeout: 300
      server:
        log_level: warn
      store:
        fst:
          graph:
            consolidate_after: 180
            max_size: 2048
            max_words: 250000
          path: /var/lib/sonic/store/fst/
          pool:
            inactive_after: 300
        kv:
          database:
            compress: true
            flush_after: 900
            max_compactions: 1
            max_files: 100
            max_flushes: 1
            parallelism: 2
            write_ahead_log: true
            write_buffer: 16384
          path: /var/lib/sonic/store/kv/
          pool:
            inactive_after: 1800
          retain_word_objects: 100000
    enable: true
  wget_dns_fix_disable_ipv6: false

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://archivebox/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   archivebox-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      ArchiveBox environment file is managed:
      - archivebox.env.j2

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
