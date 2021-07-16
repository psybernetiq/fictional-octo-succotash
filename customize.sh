  ui_print " "
  ui_print "*******************************"
  ui_print "*       DNSCrypt-Proxy2       *"
  ui_print "*        Magisk Module        *"
  ui_print "*******************************"
  ui_print "*        v2.0.45              *"
  ui_print "*  created by bluemeda        *"
  ui_print "* revived by aleph{א}mercury  *"
  ui_print "*******************************"
  ui_print " "

  if [ "$ARCH" == "arm" ];then
    BINARY_PATH=$TMPDIR/binary/dnscrypt-proxy-android-arm
  elif [ "$ARCH" == "arm64" ];then
    BINARY_PATH=$TMPDIR/binary/dnscrypt-proxy-android-arm64
  elif [ "$ARCH" == "x86" ];then
    BINARY_PATH=$TMPDIR/binary/dnscrypt-proxy-android-i386
  elif [ "$ARCH" == "x64" ];then
    BINARY_PATH=$TMPDIR/binary/dnscrypt-proxy-android-x86_64
  fi

  SCRIPT_FILE=$TMPDIR/data/adb/service.d
  CONFIG_FILE=$TMPDIR/data/media/0/dnscrypt-proxy
  LIST_FILES=$TMPDIR/data/media/0/dnscrypt-proxy/lists
  LOG_FILES=$TMPDIR/data/media/0/dnscrypt-proxy/logs

  unzip -o "$ZIPFILE" 'data/*' 'binary/*' -d $TMPDIR

  ui_print "* Creating binary path"
  mkdir -pv $MODPATH/system/bin

  ui_print "* Creating config, lists and logs paths"
  mkdir -p /data/media/0/dnscrypt-proxy/
  mkdir -p /data/media/0/dnscrypt-proxy/lists
  mkdir -p /data/media/0/dnscrypt-proxy/logs

  if [ -f "$BINARY_PATH" ]; then
    ui_print "* Copying binary for $ARCH"
    cp -afv $BINARY_PATH $MODPATH/system/bin/dnscrypt-proxy
  else
    abort "Binary file for $ARCH is missing!"
  fi

  if [ -d "$CONFIG_FILE" ]; then
    ui_print "* Copying config, list and log files"
    cp -arfv $SCRIPT_FILE/* /data/adb/service.d && chmod 775 /data/adb/service.d/dns-redirect.sh
    cp -arfv $CONFIG_FILE/* /data/media/0/dnscrypt-proxy/
    cp -arfv $LIST_FILES/* /data/media/0/dnscrypt-proxy/lists
    cp -arfv $LOG_FILES/* /data/media/0/dnscrypt-proxy/logs
  else
    abort "Config file is missing!"
  fi

CONFIG_FILE="/data/media/0/dnscrypt-proxy/dnscrypt-proxy.toml"

  if  [ -f "$CONFIG_FILE" ]; then
## v2.8.5
     ui_print "* Backing up config file"
    # cp -afv $CONFIG_FILE $TMPDIR
    # ui_print "* Restoring config files"
    # cp -af $TMPDIR/dnscrypt-proxy.toml $CONFIG_FILE

## v2.8.5
 #   cp -afv /data/media/0/dnscrypt-proxy/example-dnscrypt-proxy.toml $CONFIG_FILE
 #  sed -i -e 's/127.0.0.1:53/127.0.0.1:5354/g' $CONFIG_FILE
#    sed -i -e 's/\[::1\]:53/\[::1\]:5354/g' $CONFIG_FILE

## v2.8.9
cp -afv  $CONFIG_FILE ${CONFIG_FILE}-backup-`date +%Y%m%d%H%M%S`
  fi

cp -afv /data/media/0/dnscrypt-proxy/my-dnscrypt-proxy.toml $CONFIG_FILE

  set_perm_recursive $MODPATH 0 0 0755 0755
  set_perm $MODPATH/system/bin/dnscrypt-proxy 0 0 0755
