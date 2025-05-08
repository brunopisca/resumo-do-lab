#!/bin/bash

# Função para validar o número pelo algoritmo de Luhn
luhn_check() {
    local number=$1
    local sum=0
    local alt=0

    for (( i=${#number}-1; i>=0; i-- )); do
        n=${number:$i:1}
        if (( alt )); then
            n=$(( n * 2 ))
            if (( n > 9 )); then
                n=$(( n - 9 ))
            fi
        fi
        sum=$(( sum + n ))
        alt=$(( 1 - alt ))
    done

    (( sum % 10 == 0 ))
}

# Função para identificar a bandeira
get_brand() {
    local number=$1

    if [[ $number =~ ^4[0-9]{12}(?:[0-9]{3})?$ ]]; then
        echo "Visa"
    elif [[ $number =~ ^5[1-5][0-9]{14}$ ]]; then
        echo "MasterCard"
    elif [[ $number =~ ^3[47][0-9]{13}$ ]]; then
        echo "American Express"
    elif [[ $number =~ ^3(?:0[0-5]|[68][0-9])[0-9]{11}$ ]]; then
        echo "Diners Club"
    elif [[ $number =~ ^6(?:011|5[0-9]{2})[0-9]{12}$ ]]; then
        echo "Discover"
    elif [[ $number =~ ^(?:2014|2149)[0-9]{11}$ ]]; then
        echo "EnRoute"
    elif [[ $number =~ ^35[2-8][0-9]{13}$ ]]; then
        echo "JCB"
    elif [[ $number =~ ^8699[0-9]{11}$ ]]; then
        echo "Voyager"
    elif [[ $number =~ ^606282[0-9]{10,12}$ ]]; then
        echo "HiperCard"
    elif [[ $number =~ ^50[0-9]{14,17}$ ]]; then
        echo "Aura"
    else
        echo "Desconhecida"
    fi
}

# Verificação
read -p "Digite o número do cartão: " card

# Remove espaços
card=$(echo "$card" | tr -d ' ')

brand=$(get_brand "$card")

if [[ "$brand" == "Desconhecida" ]]; then
    echo "Bandeira não reconhecida."
    exit 1
fi

if luhn_check "$card"; then
    echo "Cartão válido. Bandeira: $brand"
else
    echo "Cartão inválido. Possível erro de dígito verificador (Luhn)."
fi
