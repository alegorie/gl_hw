usage() {
  echo -e "Usage: $0 [-i <path>] [-a <path>] [-o <path>]\n"\
       "where\n"\
       "-i defines an input flights path\n"\
       "-o defines an output path\n"\
       "-a defines an input airlines path\n"\
       "-e defines an executor - yarn (default) / hadoop\n"\
       "\n"\
        1>&2
  exit 1
}


while getopts ":i:a::o:t:e:" opt; do
    case "$opt" in
        i)  INPUT_PATH=${OPTARG} ;;
        o)  OUTPUT_PATH=${OPTARG} ;;
        a)  AIRLINES_PATH=${OPTARG} ;;
        e)  EXECUTOR=${OPTARG} ;;
        *)  usage ;;
    esac
done

if [[ -z "$INPUT_PATH" ]];
then
  INPUT_PATH="/bdpc/hadoop_mr/airlines/input"
fi

if [[ -z "$AIRLINES_PATH" ]];
then
  AIRLINES_PATH="/bdpc/hadoop_mr/airlines/airlines.csv"
fi

if [[ -z "$OUTPUT_PATH" ]];
then
  OUTPUT_PATH="/bdpc/hadoop_mr/airlines/output"
fi

if [[ -z "$EXECUTOR" ]];
then
  EXECUTOR="yarn"
fi

hadoop fs -rm -R $OUTPUT_PATH
hdfs dfs -ls ${INPUT_PATH}

THIS_FILE=$(readlink -f "$0")
THIS_PATH=$(dirname "$THIS_FILE")
BASE_PATH=$(readlink -f "$THIS_PATH/../")
APP_PATH="$THIS_PATH/delays-1.0.jar"

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "THIS_FILE = $THIS_FILE"
echo "THIS_PATH = $THIS_PATH"
echo "BASE_PATH = $BASE_PATH"
echo "APP_PATH = $APP_PATH"
echo "-------------------------------------"
echo "INPUT_PATH = $INPUT_PATH"
echo "AIRLINES_PATH = $AIRLINES_PATH"
echo "OUTPUT_PUTH = $OUTPUT_PATH"
echo "-------------------------------------"

mapReduceArguments=(
  "$APP_PATH"
  "$INPUT_PATH"
  "$OUTPUT_PATH"
  "$AIRLINES_PATH"
)

SUBMIT_CMD="${EXECUTOR} jar ${mapReduceArguments[@]}"
echo "$SUBMIT_CMD"
${SUBMIT_CMD}

echo "You should find results here: 'hadoop fs -ls $OUTPUT_PATH'"
