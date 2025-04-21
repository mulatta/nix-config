#!/usr/bin/env bash

DAY_OF_WEEK=$(date +%w)
TODAY=$(( DAY_OF_WEEK == 0 ? 8 : DAY_OF_WEEK + 1 ))

declare -A WEEKDAY_NAMES=(
    [1]="월요일"
    [2]="화요일"
    [3]="수요일"
    [4]="목요일"
    [5]="금요일"
    [6]="토요일"
    [0]="일요일"
)

BASE="https://www.uicoop.ac.kr/main.php?mkey=2&w=2"

declare -A CAFETERIA_NAMES=(
    [1]="학생식당"
    [2]="2호관 식당"
    [3]="제 1기숙사 식당"
    [4]="27호관 식당"
    [5]="사범대 식당"
)

show_help() {
    echo ""
    echo "📌 식당 목록:"
    for i in {1..5}; do
        echo "  $i) ${CAFETERIA_NAMES[$i]}"
    done
    exit 0
}

get_menu() {
    local cafeteria_id=$1
    local url="${BASE}&l=${cafeteria_id}"
    
    # 기본 필터
    local filter="tail -n +5 | head -n -3"

    # 27호관 식당 (4번) → tail -n +3 | head -n -3
    if [[ "$cafeteria_id" -eq 4 ]]; then
        filter="tail -n +3 | head -n -3"
    
    # 사범대 식당 (5번) → tail -n +5 | head -n -2
    elif [[ "$cafeteria_id" -eq 5 ]]; then
        filter="tail -n +5 | head -n -2"
    fi

    # HTML 파싱 및 정리
    curl -k --silent "$url" |
      htmlq "#menuBox td:nth-child(1), td:nth-child(${TODAY})" --remove-nodes '#menuBox:nth-of-type(3)' -t |
      eval "$filter" |
      tr -d '"' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

# 🏷️ 오늘의 요일 표시
echo "📅 오늘은 $(date +%y%m%d) ${WEEKDAY_NAMES[$DAY_OF_WEEK]} 입니다."
echo "------------------------------------"

# 스크립트 인자로 CAFETERIA 값을 받음
CAFETERIA=$1

# 헬프 요청 시 도움말 출력
if [[ "$CAFETERIA" == "-h" || "$CAFETERIA" == "--help" ]]; then
    show_help
fi

# 특정 식당 메뉴 조회
if [[ -n "$CAFETERIA" ]]; then
    if [[ -z "${CAFETERIA_NAMES[$CAFETERIA]}" ]]; then
        echo "❌ 잘못된 값입니다. 1~5 사이의 값을 입력하세요."
        exit 1
    fi

    echo "📌 ${CAFETERIA_NAMES[$CAFETERIA]} (${CAFETERIA}) 메뉴:"
    MENU=$(get_menu "$CAFETERIA")
    echo "$MENU"

# 모든 식당 메뉴 조회
else
    for i in {1..5}; do
        echo "📌 ${CAFETERIA_NAMES[$i]} ($i) 메뉴:"
        MENU=$(get_menu "$i")
        echo "$MENU"
        echo "------------------------------------"
    done
fi
