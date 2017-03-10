#!/bin/bash
# author: botamochi6277
# licence: MIT licence
PROGNAME=$(basename $0)
VERSION="0.0.1"
HELP_MSG="'$PROGNAME -h'と指定することでヘルプを見ることができます"


#ref http://qiita.com/rita_cano_bika/items/9fcb2a61c6f360632541
# ヘルプメッセージ
usage() {
  echo "Usage: $PROGNAME [options] directory_path"
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
    # ヘルプメッセージ
    '-h'|'--help' )
      usage
      exit 1
      ;;
    # バージョンメッセージ
    '-v'|'--version' )
      echo v$VERSION
      exit 1
      ;;
    # オプション-o、--long-o
    '-o'|'--output' )
      FLG_O=1
      # オプションに引数がなかった場合（必須）
      if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
        echo "$PROGNAME:「$1」need argument" 1>&2
        exit 1
      fi
      ARG_O="$2"
      shift 2
      ;;
    # オプション-j、--jpeg
    '-j'|'--jpeg' )
      FLG_J=1
      # オプションに引数がなかった場合
      if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
        # echo ARG_J 1
        shift
      else
        # echo ARG_J 2
        # オプションの引数設定
        ARG_J="$2"
        shift 2
      fi
      ;;
    # オプション-c
    '-c'|'--long-c' )
      # オプション指定のみなのでフラグだけ設定（引数がないタイプ）
      # 今のところはなし，将来的に追加するかも
      FLG_C=1
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

if [ $FLG_O ]; then
  echo Now convering images to "${ARG_O}".pdf
  convert "${param}"/* "${ARG_O}".pdf
  exit 1
elif [ $FLG_J ]; then
  #statements
  if [ $ARG_J ]; then
    echo $ARG_J
    echo Now jpeg compressing at $ARG_J \% quality
    convert "${param}"/* -quality $ARG_J -compress jpeg "${param##*/}".pdf
  fi
  echo Now jpeg compressing
  convert "${param}"/* -compress jpeg "${param##*/}".pdf
  exit 1
elif [ ${#param[*]} = 0 ]; then
  #statements
  echo Error: No directory path.
  echo ${PROGNAME} '-h'
else
  echo Now convering images to \'"${param##*/}".pdf\'
  convert "${param}"/* "${param##*/}".pdf
fi
