#!/bin/bash

# Fonction pour générer un mot de passe aléatoire
generate_password() {
    local length=$1
    local use_special=$2
    local characters="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

    if [ "$use_special" = true ]; then
        characters+="!@#$%^&*()-_=+"
    fi

    password=$(< /dev/urandom tr -dc "$characters" | head -c "$length")
    echo "$password"
}

# Fonction pour créer une passphrase à partir de trois mots
create_passphrase() {
    echo "Veuillez entrer le premier mot :"
    read -r word1
    echo "Veuillez entrer le deuxième mot :"
    read -r word2
    echo "Veuillez entrer le troisième mot :"
    read -r word3

    passphrase="$word1-$word2-$word3"
    echo "Passphrase générée : $passphrase"
}

# Menu principal
while true; do
    echo "====================================="
    echo "         Générateur de Mots de Passe         "
    echo "====================================="
    echo "1. Générer un mot de passe aléatoire"
    echo "2. Créer une passphrase à partir de trois mots"
    echo "3. Quitter"
    echo "====================================="
    read -r choice

    case $choice in
        1)
            echo "Veuillez entrer la longueur du mot de passe :"
            read -r length
            echo "Inclure des caractères spéciaux ? (oui/non)"
            read -r use_special

            if [ "$use_special" = "oui" ]; then
                use_special=true
            else
                use_special=false
            fi

            password=$(generate_password "$length" "$use_special")
            echo "Mot de passe généré : $password"
            echo "Appuyez sur Entrée pour continuer..."
            read -r
            ;;
        2)
            create_passphrase
            echo "Appuyez sur Entrée pour continuer..."
            read -r
            ;;
        3)
            echo "Au revoir !"
            exit 0
            ;;
        *)
            echo "Choix invalide. Veuillez réessayer."
            sleep 2
            ;;
    esac
done
