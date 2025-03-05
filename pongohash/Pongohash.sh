#!/bin/bash

# Fonction pour afficher le menu principal
afficher_menu() {
    echo "===================================="
    echo "       Script de Hachage de Fichiers"
    echo "===================================="
    echo "1. Hacher un fichier unique"
    echo "2. Hacher tous les fichiers d'un répertoire"
    echo "3. Hacher un fichier archive"
    echo "4. Quitter"
    echo "===================================="
    echo -n "Choisissez une option: "
}

# Fonction pour afficher les options de hachage
afficher_options_hachage() {
    echo "===================================="
    echo "       Options de Hachage           "
    echo "===================================="
    echo "1. MD5"
    echo "2. SHA-1"
    echo "3. SHA-256"
    echo "4. CRC32"
    echo "5. BLAKE2"
    echo "6. Tous les algorithmes"
    echo "===================================="
    echo -n "Choisissez un algorithme de hachage: "
}

# Fonction pour hacher un fichier avec un algorithme spécifique
hacher_fichier() {
    local chemin_fichier=$1
    local algorithme=$2
    case $algorithme in
        1)
            md5sum "$chemin_fichier"
            ;;
        2)
            sha1sum "$chemin_fichier"
            ;;
        3)
            sha256sum "$chemin_fichier"
            ;;
        4)
            crc32 "$chemin_fichier"
            ;;
        5)
            b2sum "$chemin_fichier"
            ;;
        6)
            echo "MD5:"
            md5sum "$chemin_fichier"
            echo "SHA-1:"
            sha1sum "$chemin_fichier"
            echo "SHA-256:"
            sha256sum "$chemin_fichier"
            echo "CRC32:"
            crc32 "$chemin_fichier"
            echo "BLAKE2:"
            b2sum "$chemin_fichier"
            ;;
        *)
            echo "Option de hachage invalide!"
            ;;
    esac
}

# Fonction pour hacher un fichier unique
hacher_fichier_unique() {
    read -p "Entrez le chemin du fichier: " chemin_fichier
    if [[ -f "$chemin_fichier" ]]; then
        afficher_options_hachage
        read -r choix_hachage
        hacher_fichier "$chemin_fichier" "$choix_hachage"
    else
        echo "Fichier non trouvé!"
    fi
}

# Fonction pour hacher tous les fichiers d'un répertoire
hacher_repertoire() {
    read -p "Entrez le chemin du répertoire: " chemin_repertoire
    if [[ -d "$chemin_repertoire" ]]; then
        afficher_options_hachage
        read -r choix_hachage
        find "$chemin_repertoire" -type f | while read -r chemin_fichier; do
            echo "Hachage du fichier: $chemin_fichier"
            hacher_fichier "$chemin_fichier" "$choix_hachage"
            echo ""
        done
    else
        echo "Répertoire non trouvé!"
    fi
}

# Fonction pour hacher un fichier archive
hacher_archive() {
    read -p "Entrez le chemin du fichier archive: " chemin_archive
    if [[ -f "$chemin_archive" ]]; then
        afficher_options_hachage
        read -r choix_hachage
        hacher_fichier "$chemin_archive" "$choix_hachage"
    else
        echo "Fichier archive non trouvé!"
    fi
}

# Boucle principale du script
while true; do
    afficher_menu
    read -r choix
    case $choix in
        1)
            hacher_fichier_unique
            ;;
        2)
            hacher_repertoire
            ;;
        3)
            hacher_archive
            ;;
        4)
            echo "Sortie..."
            exit 0
            ;;
        *)
            echo "Option invalide! Veuillez réessayer."
            ;;
    esac
    echo ""
done
