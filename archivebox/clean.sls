# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``archivebox`` meta-state
    in reverse order, i.e. stops the archivebox, sonic, pihole, pywb services,
    removes their configuration and then removes their containers.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
