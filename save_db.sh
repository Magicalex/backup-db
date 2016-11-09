#!/usr/bin/env bash

# Nom du script .. : save_db.sh
# Version ........ : 1.4.1
# Date ........... : 09/11/2016
# Auteur ......... : Magicalex
#
# Description : Backup script for mysql data.

## Current folder
path="$(dirname "$0")"

## load config.sh if exist
if [ -e "${path}/config.sh" ]; then
    . "${path}/config.sh"
else
    echo "Unable to find file : config.sh"
    exit 1
fi

## date and file log
backup_date="$(date '+%d-%m-%y_%Hh%Mm%Ss')"
## dossier des archives de sauvegarde
local_folder="${path}/${backup_folder}"

## check local folder
if [ ! -d "${local_folder}" ]; then
    mkdir --parents "${local_folder}"
fi

## work in the folder backup
cd "${local_folder}"

## create folder for the tarball
mkdir "${site}"

## Backup databases .sql files
for db in ${bdd_name[*]}; do
    mysqldump --login-path="${bdd_login}" "${db}" > "${site}/${db}_${backup_date}.sql"
done

## Compression data in tar.bz2 ==> tar --create --bzip2 --file == tar -jcf
tar --create --bzip2 --file "${site}_${backup_date}.tar.bz2" "${site}"

## Deleting uncompressed exports
rm -Rf "${site}"

## Secure archives
find "${local_folder}" -type f -exec chmod 600 {} \;

## Delete old backup
nb_save=$(ls | grep .tar.bz2 | wc -l)

if [ "${nb_save}" -gt "${keep_backup}" ]; then
    rm -f $(ls -at | grep .tar.bz2 | tail -1)
fi

## "mirror --delete --reverse" : crée une copie exact.
## -c execute la commande et quit
## -e execute la commande et ne quitte pas
## -u user et mot de passe
lftp ftp://"${ftp_host}" \
    -u "${ftp_user}","${ftp_passwd}" \
    -e "mirror --delete --reverse ${local_folder} ${remote_folder}; quit"

exit 0
