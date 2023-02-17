# vim: ft=sls

{#-
    *Meta-state*.

    This installs the archivebox, sonic, pihole, pywb containers,
    manages their configuration and starts their services.
#}

include:
  - .package
  - .config
  - .service
