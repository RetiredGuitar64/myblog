#!/usr/bin/env bash
set -euo pipefail
umask 077

# script/db_backup.sh backup
# script/db_backup.sh restore /path/to/backup.dump

container=${DB_CONTAINER:-crystal_china_pg}
database=${DB_NAME:-$(podman exec "$container" printenv POSTGRES_DB)}
user=$(podman exec "$container" printenv POSTGRES_USER)
backup_dir=${DB_BACKUP_DIR:-"$HOME/crystal_china_backups"}

backup() {
    local file=${1:-"$backup_dir/$database-$(date +%Y%m%d-%H%M%S).dump"}
    local temporary

    if [ -e "$file" ]; then
        echo "文件已存在: $file" >&2
        return 1
    fi

    mkdir -p "$(dirname "$file")"
    temporary=$(mktemp "${file}.XXXXXX")

    if ! podman exec "$container" pg_dump -U "$user" -d "$database" -Fc > "$temporary" ||
       ! podman exec -i "$container" pg_restore -l < "$temporary" > /dev/null; then
        rm -f "$temporary"
        return 1
    fi

    mv "$temporary" "$file"
    echo "备份完成: $file"
}

case ${1:-} in
    backup)
        backup "${2:-}"
        ;;
    restore)
        file=${2:?请提供备份文件路径}
        [ -f "$file" ] || { echo "文件不存在: $file" >&2; exit 1; }
        podman exec -i "$container" pg_restore -l < "$file" > /dev/null

        echo "将用 $file 覆盖 $container 中的数据库 $database。请先停止网站服务。"
        read -r -p "输入数据库名确认: " answer < /dev/tty
        [ "$answer" = "$database" ] || exit 1
        read -r -p "再输入 RESTORE 确认: " answer < /dev/tty
        [ "$answer" = RESTORE ] || exit 1

        backup
        podman exec "$container" dropdb -U "$user" "$database"
        podman exec "$container" createdb -U "$user" "$database"
        podman exec -i "$container" pg_restore -U "$user" -d "$database" --no-owner --no-acl --exit-on-error < "$file"
        echo "恢复完成: $database"
        ;;
    *)
        echo "用法: $0 backup [文件路径] | restore <文件路径>" >&2
        exit 1
        ;;
esac
