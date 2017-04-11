#!/bin/bash
# author: botamochi6277
# licence: MIT licence
PROGNAME=$(basename $0)
VERSION="1.0.0"

#ref http://qiita.com/rita_cano_bika/items/9fcb2a61c6f360632541
# ヘルプメッセージ
usage() {
  echo "Usage: $PROGNAME directory_path [options]"
  echo
  echo "Options:"
  echo "  -h, --help            print this message"
  echo "  -v, --version         print ${PROGNAME} version"
  echo "  -o, --output <path>   convert to inputed path"
  echo "  -j, --jpeg <quality>  convert with jpeg compression"
  echo
  exit 1
}
# オプション解析
for OPT in "$@"
do
  case "$OPT" in
    # help massage
    '-h'|'--help' )
      usage
      exit 1
      ;;
    # print version
    '-v'|'--version' )
      echo v$VERSION
      exit 1
      ;;
    # option: -o、--long-o
    '-o'|'--output' )
      FLG_O=true
      # オプションに引数がなかった場合（必須）
      if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
        echo "$PROGNAME:「$1」need argument" 1>&2
        exit 1
      fi
      ARG_O="$2"
      shift 2
      ;;
    # option: -j、--jpeg
    '-j'|'--jpeg' )
      FLG_J=1
      # オプションに引数がなかった場合
      if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
        # echo ARG_J 1
        ARG_J="-compress jpeg"
        shift
      else
        # echo ARG_J 2
        # オプションの引数設定
        ARG_J="-quality ${2} -compress jpeg"
        shift 2
      fi
      ;;
    # option: -s
    '-s'|'--separate' )
      FLG_S=1
      shift 1
      ;;
    '--'|'-' )
      # 「-」か「--」だけ打った時
      shift 1
      param+=( "$@" )
      break
      ;;
    -*)
      echo "$PROGNAME: bad option: -$(echo $1 | sed 's/^-*//')"
      echo "  $PROGNAME -h" 1>&2
      exit 1
      ;;
    *)
      # コマンド引数（オプション以外のパラメータ）
      if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
        param+=( "$1" )
        shift 1
      fi
      ;;
  esac
done


if [ ! $FLG_O ]; then
  if [ ! $FLG_S ]; then
    ARG_O+="${param##*/}"
  fi
fi
for i in "${param[@]}"
do
  ARG_I+=("${i}/*")
  if [ $FLG_S ]; then
    ARG_O+=("${i##*/}")
  fi
done
# To Debug
# echo Input Arguments:
# echo "${ARG_I[@]}"
# echo Output Names:
# echo "${ARG_O[@]}"
# echo "${#param[*]},${#ARG_I[@]},${#ARG_O[@]}"

if [ ${#param[*]} = 0 ]; then
  #statements
  echo Error: No directory path.
  echo ${PROGNAME} '-h'
else

  if [ $FLG_J ]; then
    echo "Now jpeg compressing with \"${ARG_J}\" "

  fi

  if [ $FLG_S ]; then
    for (( i = 0; i < "${#ARG_I[@]}"; i++ )); do
      echo "Now convering images to "${ARG_O[i]}".pdf"
      convert "${ARG_I[i]}" $ARG_J "${ARG_O[i]}".pdf
    done
  else
    echo "Now convering images to "${ARG_O}".pdf"
    convert "${ARG_I[@]}" $ARG_J "${ARG_O}".pdf
  fi
fi
