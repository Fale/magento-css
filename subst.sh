#!/usr/bin/ksh
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
FILE_TMP1="template1.tmp"
FILE_TMP2="template2.tmp"

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
      print "${ID}:${VAL}" >> ${FILE_TMP}
    else
      print "${INI_VAL}" >> ${FILE_TMP}
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
  cp ${FILE_TPL} ${FILE_TMP1}
  (( index = 0 ))
  for i in ${arr_id[*]}
  do
    sed -e  s/${arr_id[$index]}/${arr_va[$index]}/g ${FILE_TMP1} > ${FILE_TMP2}
    mv ${FILE_TMP2} ${FILE_TMP1}
    (( index = index + 1 ))
  done
  mv ${FILE_TMP1} ${FILE_OUT}
}


# -- MAIN --------------------
SITE_NAME=$1

FILE_OUT="${SITE_NAME}.css"

LoopFileDef
BuildArray
Substitute
