#!/bin/sh

PROJDIR="/Users/rsampaio/workspace/testeCheckout/"                                      #diretório do projeto
PROJECT_NAME="testeCheckout"                                                          #nome do projeto
APPLICATION_NAME="BemVindo"                                                      #nome da aplicação
TARGET_SDK="iphoneos"                                                                   #sdk que vai ser usado
BUILD_HISTORY_DIR="/Users/rsampaio/Desktop"                                             #diretório que vai ser gerado o .ipa
DEVELOPER_NAME="iOS Developer"                                                          #nome do desenvolvedor
PROVISIONING_PROFILE="/Users/rsampaio/Documents/MobileProvisions/teste.mobileprovision" #arquivo do provisioning profile
defines=( DEBUG=1 )

# buildando o projeto

function build {
cd "${PROJDIR}"
xcodebuild -verbose -target "${PROJECT_NAME}" -sdk "${TARGET_SDK}" -configuration $1  \
GCC_PREPROCESSOR_DEFINITIONS='$GCC_PREPROCESSOR_DEFINITIONS '"$(printf '%q ' "${defines[@]}")"

#Checa se a build foi feita
if [ $? != 0 ]
then
exit 1
fi

PROJECT_BUILDDIR="${PROJDIR}/build/$1-iphoneos"                                #diretório onde vamos pegar o .app

#gera o .ipa
/usr/bin/xcrun -sdk iphoneos PackageApplication -v "${PROJECT_BUILDDIR}/${APPLICATION_NAME}$1.app" -o "${BUILD_HISTORY_DIR}/${APPLICATION_NAME}$1.ipa"  --embed "${PROVISIONING_PROFILE}"

}

git checkout $1

build Debug
build Release

got clean -d -f