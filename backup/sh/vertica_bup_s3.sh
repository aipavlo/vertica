docker exec -it vertica-ce bash
opt/vertica/bin/vbr --task init -c backup_configs/db_backup.ini
# run init task with --s3-force-init or --cloud-force-init flag to regenerate the identity files

export VBR_BACKUP_STORAGE_ACCESS_KEY_ID=<key>
export VBR_BACKUP_STORAGE_SECRET_ACCESS_KEY=<secret-key>

opt/vertica/bin/vbr --task backup -c backup_configs/db_backup.ini
##### to create folders if not exists with regeneration of the identity files
# opt/vertica/bin/vbr --task backup -c backup_configs/db_backup.ini --s3-force-init
