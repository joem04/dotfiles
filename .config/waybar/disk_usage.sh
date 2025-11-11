#!/usr/bin/env bash

# Emit Waybar JSON reporting usage for the root filesystem plus any other mounts
# detected (or explicitly configured via environment variables).

set -u

get_usage() {
    local mount_point="$1"
    local used size line

    line=$(df -B1 --output=used,size "$mount_point" 2>/dev/null | awk 'NR==2 {print $1 " " $2}')
    if [[ -z "${line:-}" ]]; then
        echo "N/A"
        return
    fi

    read -r used size <<<"$line"
    printf "%s / %s" "$(format_bytes "$used")" "$(format_bytes "$size")"
}

declare -a mount_points=()

add_mount() {
    local candidate="$1"

    if [[ -z "${candidate:-}" ]]; then
        return
    fi

    for existing in "${mount_points[@]}"; do
        if [[ "$existing" == "$candidate" ]]; then
            return
        fi
    done

    mount_points+=("$candidate")
}

collect_default_mounts() {
    local -a candidates=()

    if command -v findmnt >/dev/null 2>&1; then
        # Limit to typical block-backed filesystems to avoid pseudo filesystems.
        while IFS= read -r target; do
            candidates+=("$target")
        done < <(findmnt -rn -t ext4,xfs,btrfs,fuseblk,ntfs,vfat,apfs,exfat,zfs -o TARGET)
    else
        while IFS= read -r target; do
            [[ "$target" == "Mounted on" ]] && continue
            candidates+=("$target")
        done < <(df -x tmpfs -x devtmpfs -x squashfs -x overlay -x proc -x sysfs -x cgroup2 --output=target 2>/dev/null)
    fi

    for candidate in "${candidates[@]}"; do
        case "$candidate" in
            ""|/proc*|/sys*|/run*|/dev*|/var/run*|/var/lib/docker*|/var/lib/containers*|/snap*|/var/lib/flatpak*)
                continue
                ;;
        esac
        add_mount "$candidate"
    done
}

escape_json() {
    local text="$1"
    text=${text//\\/\\\\}
    text=${text//\"/\\\"}
    text=${text//$'\n'/\\n}
    echo "$text"
}

format_bytes() {
    local bytes="$1"

    if command -v numfmt >/dev/null 2>&1; then
        numfmt --to=iec --format="%.1f" "$bytes"
        return
    fi

    python3 - "$bytes" <<'PY' || echo "${bytes}B"
import math
import sys

try:
    b = int(sys.argv[1])
except (ValueError, IndexError):
    print("0B")
    raise SystemExit(0)

if b == 0:
    print("0B")
    raise SystemExit(0)

units = ["B", "K", "M", "G", "T", "P", "E", "Z", "Y"]
idx = min(int(math.log(b, 1024)), len(units) - 1)
val = b / (1024 ** idx)
print(f"{val:.1f}{units[idx]}")
PY
}

primary_mount="${DISK_USAGE_PRIMARY:-/}"
manual_mounts="${DISK_USAGE_MOUNTS:-}"

add_mount "$primary_mount"

if [[ -n "$manual_mounts" ]]; then
    IFS=':' read -r -a manual_array <<<"$manual_mounts"
    for mount_point in "${manual_array[@]}"; do
        add_mount "$mount_point"
    done
else
    collect_default_mounts
fi

if [[ ${#mount_points[@]} -eq 0 ]]; then
    mount_points=("$primary_mount")
fi

primary_usage=$(get_usage "$primary_mount")

declare -a tooltip_lines=()
for mount_point in "${mount_points[@]}"; do
    tooltip_lines+=("$(printf "%s: %s" "$mount_point" "$(get_usage "$mount_point")")")
done

tooltip=$(printf "%s\n" "${tooltip_lines[@]}")
tooltip=${tooltip%$'\n'}

text="$primary_usage "

printf '{"text":"%s","tooltip":"%s"}\n' "$(escape_json "$text")" "$(escape_json "$tooltip")"
