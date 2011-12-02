#!/bin/bash
# -------------------------------------------------------------
# SUBS: sostituisce il pattern riportato nel file di 
#       inizializzazione nel file di template per
#       generare un file CSS
#
#
# F.Cermelli                                 snds - 2 dec 2011
# -------------------------------------------------------------
FILE_DEF="azienda.def"
FILE_INI="azienda.ini"
FILE_TMP="azienda.tmp"

FILE_TPL="azienda.tpl"

# ----------------------
function LoopFileDef
{
  (( index_d = 0 ))
  IFS=":"
  while read ID VAL
  do
    INI_VAL=$(grep ${ID} ${FILE_INI})
    if [[ $? != 0 ]]
    then
      echo "${ID}:${VAL}" >> ${FILE_TMP}
    else
      echo "${INI_VAL}" >> ${FILE_TMP}
    fi
  done < ${FILE_DEF}
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
  (( index = 0 ))
  for i in ${arr_id[*]}
  do
    CMD_LINE="${CMD_LINE} -e 's/${arr_id[$index]}/${arr_va[$index]}/g'"
    if [[ $index < $index_i ]]
    then
      CMD_LINE="${CMD_LINE} \\"
    fi
    (( index = index + 1 ))
  done
  echo "sed ${CMD_LINE} ${FILE_TPL} > ${FILE_OUT}"
  sed ${CMD_LINE} ${FILE_TPL} > ${FILE_OUT}
}

# -- MAIN --------------------
SITE_NAME=$1

FILE_OUT="${SITE_NAME}.css"

LoopFileDef
BuildArray
Substitute
