# Script de sauvegarde des bases de donnée

## Installation

Se connecter en ssh au user
```bash
cd /home/user
git clone git@github.com:Magicalex/backup-db.git backup
cd backup
touch config.sh
```

## Configuration

### Configuration des identifiants mysql

Paramètres de connexion à la base mysql local
configurer son fichier ~/.mylogin.cnf

```bash
mysql_config_editor set --login-path=user_backup --host=127.0.0.1 --user=root --password
```
Commande utile :
```bash
mysql_config_editor print --all // affiche tout
mysql_config_editor remove --login-path=user_backup // supprime le login user_backup
mysql_config_editor reset // remettre à zéro le fichier
```

### Configuration du fichier config.sh

```bash
# vim ~/backup/config.sh

#!/usr/bin/env bash
## fichier config.sh

bdd_login="user_backup"
site="domain.tld"

## Indique les noms des db à sauvegarder dans un tableau
bdd_name=(blog postfix wordpress)

## Dossier de sauvegarde et temps en jour de conservation des sauvegardes
backup_folder="archive-db"
remote_folder="/backup-folder"
keep_backup="15"

## Parametres de connexion au serveur ftp.
# c'est mon ftp perso
ftp_host="backup.domain.tld"
ftp_user="user"
ftp_passwd="password"
```

```bash
cd ~/backup
chmod +x config.sh save_db.sh
```

### Exemple de configuration de la crontab

```bash
# crontab -e

00 01 * * * /home/user/backup/save_db.sh > /dev/null 2>&1
```
