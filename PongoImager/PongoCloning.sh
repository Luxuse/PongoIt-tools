#!/bin/bash

# Vérification des permissions root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root !"
    exit 1
fi

# Fonction pour calculer le hash MD5 d'un disque
calculer_hash() {
    local DISK=$1
    local HASH_FILE=$(mktemp)
    md5sum "$DISK" > "$HASH_FILE"
    local HASH=$(cat "$HASH_FILE" | awk '{print $1}')
    rm -f "$HASH_FILE"
    echo "$HASH"
}

# Fonction pour cloner un disque
cloner_disque() {
    clear
    echo "====================================="
    echo "         Clonage de disque           "
    echo "====================================="

    echo "Disques disponibles :"
    lsblk -d -o NAME,SIZE,MODEL | grep -E '^sd|nvme'

    read -p "Entrez le nom du disque source (ex: sda, nvme0n1) : " SOURCE_DISK
    SOURCE_DISK="/dev/$SOURCE_DISK"

    if [ ! -b "$SOURCE_DISK" ]; then
        echo "Erreur : Le disque source spécifié n'existe pas !"
        return
    fi

    read -p "Entrez le nom du disque de destination (ex: sdb, nvme1n1) : " DEST_DISK
    DEST_DISK="/dev/$DEST_DISK"

    if [ ! -b "$DEST_DISK" ]; then
        echo "Erreur : Le disque de destination spécifié n'existe pas !"
        return
    fi

    read -p "Attention : Toutes les données sur le disque de destination seront perdues. Continuer ? (y/N) : " CONFIRM
    if [[ "$CONFIRM" != [Yy] ]]; then
        echo "Opération annulée."
        return
    fi

    echo "Clonage en cours..."
    if command -v pv &>/dev/null; then
        dd if="$SOURCE_DISK" | pv -s "$(blockdev --getsize64 $SOURCE_DISK)" | dd of="$DEST_DISK"
    else
        dd if="$SOURCE_DISK" of="$DEST_DISK" bs=4M status=progress
    fi

    echo "Clonage terminé."

    # Vérification des hash
    echo "Vérification des hash..."
    SOURCE_HASH=$(calculer_hash "$SOURCE_DISK")
    DEST_HASH=$(calculer_hash "$DEST_DISK")

    if [ "$SOURCE_HASH" == "$DEST_HASH" ]; then
        echo "Les hash sont identiques. Le clone est une copie exacte du disque source."
    else
        echo "Erreur : Les hash ne correspondent pas. Le clone n'est pas une copie exacte du disque source."
    fi
}

# Menu principal
while true; do
    clear
    echo "====================================="
    echo "         Menu Principal              "
    echo "====================================="
    echo "1. Cloner un disque"
    echo "2. Quitter"
    echo "====================================="
    read -p "Votre choix : " CHOIX

    case $CHOIX in
        1) cloner_disque ;;
        2) echo "Fin du programme."; exit 0 ;;
        *) echo "Choix invalide, veuillez réessayer." ;;
    esac
    read -p "Appuyez sur Entrée pour continuer..."
done
