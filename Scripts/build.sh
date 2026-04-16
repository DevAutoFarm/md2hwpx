#!/bin/bash

# md2hwpx 빌드 스크립트
# Python 패키지 빌드 및 배포

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

echo -e "${BLUE}=== md2hwpx 빌드 시작 ===${NC}"

# 빌드 디렉토리 설정
BUILD_DIR="$SCRIPT_DIR/.build"

# 기존 빌드 정리
echo -e "${YELLOW}기존 빌드 정리 중...${NC}"
rm -rf "$BUILD_DIR"
rm -rf dist/ build/ *.egg-info src/*.egg-info
mkdir -p "$BUILD_DIR"

# 가상환경 확인
if [[ -z "$VIRTUAL_ENV" ]]; then
    echo -e "${YELLOW}가상환경이 활성화되지 않았습니다.${NC}"
    if [[ -d ".venv" ]]; then
        echo -e "${YELLOW}.venv 활성화 중...${NC}"
        source .venv/bin/activate
    else
        echo -e "${RED}가상환경을 찾을 수 없습니다. dev-setup.sh를 먼저 실행하세요.${NC}"
        exit 1
    fi
fi

# 빌드 도구 설치 확인
echo -e "${YELLOW}빌드 도구 확인 중...${NC}"
pip install --quiet build twine

# 패키지 빌드
echo -e "${YELLOW}패키지 빌드 중...${NC}"
python -m build

# 빌드 결과물 이동
echo -e "${YELLOW}빌드 결과물 정리 중...${NC}"
mv dist/* "$BUILD_DIR/"
rm -rf dist/ build/ src/*.egg-info

echo -e "${GREEN}=== 빌드 완료 ===${NC}"
echo -e "빌드 결과물: $BUILD_DIR/"
ls -la "$BUILD_DIR/"

echo ""
echo -e "${BLUE}다음 단계:${NC}"
echo "1. 테스트 PyPI 업로드: twine upload --repository testpypi $BUILD_DIR/*"
echo "2. 실제 PyPI 업로드: twine upload $BUILD_DIR/*"
