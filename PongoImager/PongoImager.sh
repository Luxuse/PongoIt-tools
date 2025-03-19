#!/bin/bash

# Vérification des permissions root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root !"
    exit 1
fi

# Fonction pour créer une image ISO
creer_image() {
    clear
    echo "====================================="
    echo "      Création d'une image ISO       "
    echo "====================================="

    echo "Disques disponibles :"
    lsblk -d -o NAME,SIZE,MODEL | grep -E '^sd|nvme'

    read -p "Entrez le nom du disque à cloner (ex: sda, nvme0n1) : " DISK
    SOURCE_DISK="/dev/$DISK"

    if [ ! -b "$SOURCE_DISK" ]; then
        echo "Erreur : Le disque spécifié n'existe pas !"
        return
    fi

    read -p "Nom de l'image ISO (sans extension) : " ISO_NAME
    read -p "Entrez le chemin où enregistrer l'image ISO (laissez vide pour le répertoire courant) : " ISO_PATH

    if [ -z "$ISO_PATH" ]; then
        ISO_PATH="./${ISO_NAME}.iso"
    else
        ISO_PATH="${ISO_PATH}/${ISO_NAME}.iso"
    fi

    echo "Création de l'image ISO..."
    if command -v pv &>/dev/null; then
        dd if="$SOURCE_DISK" | pv -s "$(blockdev --getsize64 $SOURCE_DISK)" | dd of="$ISO_PATH"
    else
        dd if="$SOURCE_DISK" of="$ISO_PATH" bs=4M status=progress
    fi

    echo "Image ISO créée : $ISO_PATH"

    read -p "Voulez-vous compresser l'image ? (y/N) : " COMPRESS
    if [[ "$COMPRESS" =~ ^[Yy]$ ]]; then
        gzip "$ISO_PATH"
        echo "Image compressée : ${ISO_PATH}.gz"
    fi
}

# Fonction pour restaurer une image ISO vers un disque
restaurer_image() {
    clear
    echo "====================================="
    echo "      Restauration d'une image       "
    echo "====================================="

    read -p "Entrez le chemin de l'image ISO à restaurer : " ISO_PATH
    if [ ! -f "$ISO_PATH" ]; then
        echo "Erreur : Fichier introuvable !"
        return
    fi

    echo "Disques disponibles :"
    lsblk -d -o NAME,SIZE,MODEL | grep -E '^sd|nvme'

    read -p "Entrez le disque de destination (ex: sda, nvme0n1) : " DISK
    DEST_DISK="/dev/$DISK"

    if [ ! -b "$DEST_DISK" ]; then
        echo "Erreur : Le disque spécifié n'existe pas !"
        return
    fi

    echo "Restauration en cours..."
    dd if="$ISO_PATH" of="$DEST_DISK" bs=4M status=progress

    echo "Restauration terminée."
}

# Menu principal
while true; do
    clear
    echo "====================================="
    echo "         Menu Principal              "
    echo "====================================="
    echo "1. Créer une image ISO"
    echo "2. Restaurer une image ISO"
    echo "3. Quitter"
    echo "====================================="
    read -p "Votre choix : " CHOIX

    case $CHOIX in
        1) creer_image ;;
        2) restaurer_image ;;
        3) echo "Fin du programme."; exit 0 ;;
        *) echo "Choix invalide, veuillez réessayer." ;;
    esac
    read -p "Appuyez sur Entrée pour continuer..."
done
