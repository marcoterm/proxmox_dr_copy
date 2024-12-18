#!/bin/sh
## Script che esegue la banale copia su supporto esterno, senza controlli, di Container e VM sottoposti normalmente a Backup VZDUMP
## In modo da disporre di un disaster recovery dei dati, offsite

## Da eseguire il giorno dopo il VZDUMP (in quanto la copia viene fatta sulla base dei file $dataieri


disco=/dev/sde1
mountpoint=/mnt/discousb
backuplocation=/hdd-pool/local-hdd-backup/dump/
dataieri=$(date -d '-1 day' +%Y_%m_%d)
filecheck=discodr.txt

# Monto il disco
mkdir -p $mountpoint
mount $disco $mountpoint
if [ ! -f $mountpoint/$filecheck ]; then
    echo "ATTENZIONE: l'hard disk non risulta più essere associato al device $disco. DR FALLITO!"
    umount $mountpoint
    exit 1
fi

# Svuoto la folder dei backup del disco
rm $mountpoint/dump/*

# Copio tutti i log di ieri
cp $backuplocation/*-$dataieri-*.log $mountpoint/dump/

# Copio tutti i log di ieri
cp $backuplocation/*-$dataieri-*.log $mountpoint/dump/
# Copio tutti i Notes di ieri
cp $backuplocation/*-$dataieri-*.zst.notes $mountpoint/dump/
# Copio tutte le VM di ieri
cp $backuplocation/*-$dataieri-*.vma.zst $mountpoint/dump/
# Copio tutti i CONTAINER di ieri
cp $backuplocation/*-$dataieri-*.tar.zst $mountpoint/dump/

# smonto il disco
umount $mountpoint
