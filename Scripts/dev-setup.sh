#!/bin/bash

# md2hwpx 개발 환경 설정 스크립트

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 스크립트 디렉토리
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$SCRIPT_DIR/.."
cd "$PROJECT_DIR"

echo -e "${BLUE}=== md2hwpx 개발 환경 설정 ===${NC}"

# Python 버전 확인
echo -e "${YELLOW}Python 버전 확인 중...${NC}"
PYTHON_VERSION=$(python3 --version 2>&1)
echo -e "  ${GREEN}[OK]${NC} $PYTHON_VERSION"

# 가상환경 생성
if [[ ! -d ".venv" ]]; then
    echo -e "${YELLOW}가상환경 생성 중...${NC}"
    python3 -m venv .venv
    echo -e "  ${GREEN}[OK]${NC} 가상환경 생성 완료"
else
    echo -e "  ${GREEN}[OK]${NC} 가상환경 이미 존재"
fi

# 가상환경 활성화
echo -e "${YELLOW}가상환경 활성화 중...${NC}"
source .venv/bin/activate
echo -e "  ${GREEN}[OK]${NC} 가상환경 활성화 완료"

# pip 업그레이드
echo -e "${YELLOW}pip 업그레이드 중...${NC}"
pip install --upgrade pip --quiet
echo -e "  ${GREEN}[OK]${NC} pip 업그레이드 완료"

# 개발 의존성 설치
echo -e "${YELLOW}개발 의존성 설치 중...${NC}"
pip install -e ".[dev]" --quiet 2>/dev/null || pip install -e . --quiet
pip install pytest pytest-cov build twine --quiet
echo -e "  ${GREEN}[OK]${NC} 의존성 설치 완료"

echo -e "${GREEN}=== 개발 환경 설정 완료 ===${NC}"
echo ""
echo -e "${BLUE}사용 방법:${NC}"
echo "1. 가상환경 활성화: source .venv/bin/activate"
echo "2. 테스트 실행: pytest"
echo "3. 패키지 빌드: ./Scripts/build.sh"
