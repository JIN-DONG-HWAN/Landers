#!/bin/bash

# 윤년 판별 함수
is_leap_year() {
    local year=$1
    if (( year % 4 != 0 )); then
        echo 0
    elif (( year % 400 == 0 )); then
        echo 1
    elif (( year % 100 == 0 )); then
        echo 0
    else
        echo 1
    fi
}

# 월을 대문자로 변환하는 함수
convert_month_to_proper_case() {
    local month=$1
    case $month in
        jan|january|1) echo "Jan" ;;
        feb|february|2) echo "Feb" ;;
        mar|march|3) echo "Mar" ;;
        apr|april|4) echo "Apr" ;;
        may|may|5) echo "May" ;;
        jun|june|6) echo "Jun" ;;
        jul|july|7) echo "Jul" ;;
        aug|august|8|8) echo "Aug" ;;
        sep|september|9|9) echo "Sep" ;;
        oct|october|10) echo "Oct" ;;
        nov|november|11) echo "Nov" ;;
        dec|december|12) echo "Dec" ;;
        *) echo "" ;;
    esac
}

# 인자 개수 확인
if [ $# -ne 3 ]; then
    echo "입력값 오류"
    exit 1
fi

month=$1
date=$2
year=$3

# 월 변환
month_proper=$(convert_month_to_proper_case "$month")

# 월 변환 결과 확인
if [ -z "$month_proper" ]; then
    echo "월($month)은 유효하지 않습니다"
    exit 1
fi

# 날짜가 숫자인지 확인
if ! [[ $date =~ ^[0-9]+$ ]]; then
    echo "날짜($date)는 유효하지 않습니다"
    exit 1
fi

# 년도가 숫자인지 확인
if ! [[ $year =~ ^[0-9]+$ ]]; then
    echo "년도($year)는 유효하지 않습니다"
    exit 1
fi

# 월 별 일 수 설정
case $month_proper in
    Jan|Mar|May|Jul|Aug|Oct|Dec) days_in_month=31 ;;
    Apr|Jun|Sep|Nov) days_in_month=30 ;;
    Feb)
        if [ $(is_leap_year $year) -eq 1 ]; then
            days_in_month=29
        else
            days_in_month=28
        fi
        ;;
    *) 
        echo "월($month)은 유효하지 않습니다"
        exit 1
        ;;
esac

# 날짜 유효성 확인
if (( date < 1 || date > days_in_month )); then
    echo "날짜($date)는 유효하지 않습니다"
    exit 1
fi

# 유효한 날짜 출력
echo "$month_proper $date $year"
