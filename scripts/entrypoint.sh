#!/usr/bin/env bash
set -e

# Variables
P4_USER="perforce"
PUID=${UID:-1028}
PGID=${GID:-50}

# Functions
map_ids() {
    echo "Configuring user '$P4_USER' to UID $PUID and GID $PGID..."

    # Check if a group with this GID already exists
    EXISTING_GROUP=$(getent group "$PGID" | cut -d: -f1)
    if [ -n "$EXISTING_GROUP" ]; then
        echo "GID $PGID already assigned to group: $EXISTING_GROUP. Mapping '$P4_USER' to it."
        usermod -g "$PGID" "$P4_USER"
    else
        groupmod -g "$PGID" "$P4_USER"
    fi

    # Update User UID
    usermod -u "$PUID" "$P4_USER"
}

create_dirs() {
    mkdir -p "$P4ROOT" "$P4_DEPOTS"

    echo "Adjusting permissions..."
    chown "$P4_USER:$PGID" "$P4ROOT" "$P4_DEPOTS"
}

initialize() {
    if [ ! -f "$P4ROOT/db.counters" ]; then
        echo "Initializing new Perforce Server..."
        gosu "$P4_USER" /usr/sbin/p4d -r "$P4ROOT" -p "$P4_PORT" -C1 -xi
    fi
}

# Logic
map_ids
create_dirs
initialize

echo "Starting Perforce Server on $P4_PORT..."
exec gosu "$P4_USER" /usr/sbin/p4d -r "$P4ROOT" -p "$P4_PORT" -L "${P4_LOG:-$P4ROOT/p4d.log}" -v server=3