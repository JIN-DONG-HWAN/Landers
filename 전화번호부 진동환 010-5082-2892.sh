#!/bin/bash

# 지역번호 정의
declare -A AREA_CODES=(
    ["960"]="육군본부"
    ["973"]="지상작전사령부"
    ["972"]="제2작전사령부"
    ["987"]="제7기동군단"
    ["835"]="제35보병사단"
)

# 전화번호부 파일 경로
PHONEBOOK="phonebook.txt"

# 인수 개수 확인
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 이름 전화번호"
    exit 1
fi

# 인수 할당
name=$1
phone_number=$2

# 전화번호 형식 확인
if [[ ! "$phone_number" =~ ^[0-9]{2,4}-[0-9]{3,4}-[0-9]{4}$ ]]; then
    echo "잘못된 전화번호 형식입니다. 전화번호는 'xxxx-xxxx-xxxx' 형식이어야 합니다."
    exit 1
fi

# 지역번호 추출 및 확인
area_code=$(echo $phone_number | cut -d'-' -f1)
if [[ -z "${AREA_CODES[$area_code]}" ]]; then
    echo "알 수 없는 지역번호입니다."
    exit 1
fi
region=${AREA_CODES[$area_code]}

# 기존 전화번호부 파일이 없으면 생성
if [ ! -f "$PHONEBOOK" ]; then
    touch "$PHONEBOOK"
fi

# 전화번호부 검색 및 업데이트
if grep -q "^$name " "$PHONEBOOK"; then
    existing_phone_number=$(grep "^$name " "$PHONEBOOK" | awk '{print $2}')
    if [ "$existing_phone_number" == "$phone_number" ]; then
        echo "동일한 전화번호가 이미 존재합니다."
        exit 0
    else
        echo "업데이트된 전화번호로 추가합니다."
        grep -v "^$name " "$PHONEBOOK" > temp && mv temp "$PHONEBOOK"
    fi
fi

# 새로운 정보 추가
echo "$name $phone_number $region" >> "$PHONEBOOK"

# 이름순으로 정렬
sort -o "$PHONEBOOK" "$PHONEBOOK"

echo "전화번호부가 업데이트되었습니다."