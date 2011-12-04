#!/bin/bash
# -------------------------------------------------------------
# SUBS: sostituisce il pattern riportato nel file di 
#       inizializzazione nel file di template per
#       generare un file CSS
#
#
# F.Cermelli                                 snds - 2 dec 2011
# -------------------------------------------------------------
PATH_ROOT="${HOME}/public_html/skin/frontend/snds"
#PATH_ROOT="${HOME}/magento-css" # DEVELOP
PATH_HOME="${HOME}/magento-css"
PATH_DEF="${PATH_HOME}/default/css"

INI="styles.ini"
CSS="styles.css"


FILE_DEF="${PATH_DEF}/${CSS}"
FILE_INI="${PATH_DEF}/${INI}"

FILE_TMP="/tmp/temporary.tmp"
FILE_TMP1="/tmp/template1.tmp"
FILE_TMP2="/tmp/template2.tmp"


# ----------------------
function SetFileSite
{
  PATH_OUT="${PATH_ROOT}/${SITE_NAME}/css"
  FILE_SOUT="${PATH_OUT}/${CSS}"
  PATH_SINI="${PATH_HOME}/${SITE_NAME}/css"
  FILE_SINI="${PATH_SINI}/${INI}"
  if [[ ! -r  ${FILE_SINI} ]]
  then
    "File Not Found: ${FILE_SINI}"
    exit 2
  fi
}



# ----------------------
function LoopFileDef
{
  (( index_d = 0 ))
  IFS=":"
  while read ID VAL
  do
    INI_VAL=$(grep ${ID} ${FILE_SINI})
    if [[ $? != 0 ]]
    then
      echo "${ID}:${VAL}" >> ${FILE_TMP}
    else
      echo "${INI_VAL}" >> ${FILE_TMP}
    fi
  done < ${FILE_INI}
}


# ----------------------
function BuildArray
{
  (( index = 0 ))
  while read ID VAL
  do
    arr_id[$index]=$ID
    arr_va[$index]=$VAL
    (( index = index + 1 ))
  done < ${FILE_TMP}
  rm ${FILE_TMP}

}

# ----------------------
function Substitute
{
  cp -f ${FILE_DEF} ${FILE_TMP1}
  chmod 666 ${FILE_TMP1}
  (( index = 0 ))
  for i in ${arr_id[*]}
  do
    sed -e s/${arr_id[$index]}/${arr_va[$index]}/g ${FILE_TMP1} > ${FILE_TMP2}
    cp ${FILE_TMP2} ${FILE_TMP1}
    (( index = index + 1 ))
  done
  cp ${FILE_TMP1} ${FILE_SOUT}
}


# -- MAIN --------------------
if [[ $# != 1 ]]
then
  echo "USAGE: $0 [site name]"
  exit 1
else
  SITE_NAME=$1
fi

SetFileSite

LoopFileDef
BuildArray
Substitute
