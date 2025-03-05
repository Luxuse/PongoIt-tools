#!/bin/bash

# Fonction pour afficher le menu principal
show_main_menu() {
    clear
    echo "====================================="
    echo "         Menu Principal              "
    echo "====================================="
    echo "1. Chiffrer du texte"
    echo "2. Déchiffrer du texte"
    echo "3. Quitter"
    echo "====================================="
}

# Fonction pour afficher le menu de chiffrement
show_encrypt_menu() {
    clear
    echo "====================================="
    echo "         Menu de Chiffrement         "
    echo "====================================="
    echo "1. Base64"
    echo "2. Rot13"
    echo "3. Inversion de chaîne"
    echo "4. Retour au menu principal"
    echo "====================================="
}

# Fonction pour afficher le menu de déchiffrement
show_decrypt_menu() {
    clear
    echo "====================================="
    echo "         Menu de Déchiffrement       "
    echo "====================================="
    echo "1. Base64"
    echo "2. Rot13"
    echo "3. Inversion de chaîne"
    echo "4. Retour au menu principal"
    echo "====================================="
}

# Fonction pour chiffrer du texte avec base64
encrypt_base64() {
    echo "Veuillez entrer le texte à chiffrer :"
    read -r plaintext
    encrypted=$(echo "$plaintext" | base64)
    echo "Texte chiffré (base64) :"
    echo "$encrypted"
    echo "Appuyez sur Entrée pour continuer..."
    read -r
}

# Fonction pour déchiffrer du texte avec base64
decrypt_base64() {
    echo "Veuillez entrer le texte chiffré (base64) :"
    read -r encrypted
    decrypted=$(echo "$encrypted" | base64 --decode)
    echo "Texte déchiffré (base64) :"
    echo "$decrypted"
    echo "Appuyez sur Entrée pour continuer..."
    read -r
}

# Fonction pour chiffrer du texte avec rot13
encrypt_rot13() {
    echo "Veuillez entrer le texte à chiffrer :"
    read -r plaintext
    encrypted=$(echo "$plaintext" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
    echo "Texte chiffré (rot13) :"
    echo "$encrypted"
    echo "Appuyez sur Entrée pour continuer..."
    read -r
}

# Fonction pour déchiffrer du texte avec rot13
decrypt_rot13() {
    echo "Veuillez entrer le texte chiffré (rot13) :"
    read -r encrypted
    decrypted=$(echo "$encrypted" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
    echo "Texte déchiffré (rot13) :"
    echo "$decrypted"
    echo "Appuyez sur Entrée pour continuer..."
    read -r
}

# Fonction pour chiffrer du texte en inversant la chaîne
encrypt_reverse() {
    echo "Veuillez entrer le texte à chiffrer :"
    read -r plaintext
    encrypted=$(echo "$plaintext" | rev)
    echo "Texte chiffré (inversé) :"
    echo "$encrypted"
    echo "Appuyez sur Entrée pour continuer..."
    read -r
}

# Fonction pour déchiffrer du texte en inversant la chaîne
decrypt_reverse() {
    echo "Veuillez entrer le texte chiffré (inversé) :"
    read -r encrypted
    decrypted=$(echo "$encrypted" | rev)
    echo "Texte déchiffré (inversé) :"
    echo "$decrypted"
    echo "Appuyez sur Entrée pour continuer..."
    read -r
}

# Boucle principale du menu
while true; do
    show_main_menu
    read -r choice

    case $choice in
        1)
            while true; do
                show_encrypt_menu
                read -r encrypt_choice

                case $encrypt_choice in
                    1)
                        encrypt_base64
                        ;;
                    2)
                        encrypt_rot13
                        ;;
                    3)
                        encrypt_reverse
                        ;;
                    4)
                        break
                        ;;
                    *)
                        echo "Choix invalide. Veuillez réessayer."
                        sleep 2
                        ;;
                esac
            done
            ;;
        2)
            while true; do
                show_decrypt_menu
                read -r decrypt_choice

                case $decrypt_choice in
                    1)
                        decrypt_base64
                        ;;
                    2)
                        decrypt_rot13
                        ;;
                    3)
                        decrypt_reverse
                        ;;
                    4)
                        break
                        ;;
                    *)
                        echo "Choix invalide. Veuillez réessayer."
                        sleep 2
                        ;;
                esac
            done
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
