
#!/bin/bash

RUN=true
case "${IF_NO_TOE,,}" in
    no|off|false|disable|disabled)
        RUN=false
    ;;
esac

if [ "$MODE" = start -a "$RUN" = true ]; then
  TOE_OPTIONS="tso"
  for TOE_OPTION in $TOE_OPTIONS; do
    /sbin/ethtool --offload "$IFACE" "$TOE_OPTION" off &>/dev/null || true
  done
fi
