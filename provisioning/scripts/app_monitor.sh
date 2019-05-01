# Variables
NGINX_URL="https://app.lab-example-exp-m2-elasticsearch-cluster.cllabs.io/nginx_status/"
NGINX_CURL_RESOLVE="app.lab-example-exp-m2-elasticsearch-cluster.cllabs.io:443:127.0.0.1"
PHP_FPM_URL="http://localhost:8080/php-status?json"

TIME_PAD='                      '
PADDING='        '

# Header info
CUR_TIME='timestamp'
CPU_USAGE="cpu%"
CPU_60S_LOAD="load"
MEM_USAGE="mem%"
PHP_FPM_ACTIVE_PROCESSES="php-fpm"
NGINX_ACTIVE_CONNECTIONS="nginx"

CUR_PROC_STAT=$(grep 'cpu ' /proc/stat)

ECHO_HEADER=1
while true; do
  [ ${ECHO_HEADER} -eq 1 ] && ECHO_HEADER=0 && printf "%s %s %s %s %s %s %s %s %s %s %s %s\n" ${CUR_TIME} "${TIME_PAD:${#CUR_TIME}}" ${CPU_USAGE} "${PADDING:${#CPU_USAGE}}" ${CPU_60S_LOAD} "${PADDING:${#CPU_60S_LOAD}}" ${MEM_USAGE} "${PADDING:${#MEM_USAGE}}" ${PHP_FPM_ACTIVE_PROCESSES} "${PADDING:${#PHP_FPM_ACTIVE_PROCESSES}}" ${NGINX_ACTIVE_CONNECTIONS} "${PADDING:${#NGINX_ACTIVE_CONNECTIONS}}"
  CUR_TIME=$(date '+%Y-%m-%d %H:%M:%S')
  LAST_PROC_STAT=${CUR_PROC_STAT}
  CUR_PROC_STAT=$(grep 'cpu ' /proc/stat)
  CPU_USAGE=$(cat <(echo "${LAST_PROC_STAT}") <(echo "${CUR_PROC_STAT}") | awk -v RS="" '{printf "%.2f%%", ($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5) }')
  CPU_60S_LOAD=$(cat /proc/loadavg | cut -d" " -f1)
  MEM_USAGE=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
  PHP_FPM_STATUS=$(curl -s ${PHP_FPM_URL})
  PHP_FPM_ACTIVE_PROCESSES=$(echo "${PHP_FPM_STATUS}" | jq '."active processes"')
  NGINX_STATUS=$(curl -sk --resolve "${NGINX_CURL_RESOLVE}" ${NGINX_URL})
  NGINX_ACTIVE_CONNECTIONS=$(echo "${NGINX_STATUS}" | grep "Active connections: " | cut -d":" -f2)
  NGINX_ACTIVE_CONNECTIONS="${NGINX_ACTIVE_CONNECTIONS##*( )}"
  printf "%s %s %s %s %s %s %s %s %s %s %s %s" ${CUR_TIME} "${TIME_PAD:${#CUR_TIME}}" ${CPU_USAGE} "${PADDING:${#CPU_USAGE}}" ${CPU_60S_LOAD} "${PADDING:${#CPU_60S_LOAD}}" ${MEM_USAGE} "${PADDING:${#MEM_USAGE}}" ${PHP_FPM_ACTIVE_PROCESSES} "${PADDING:${#PHP_FPM_ACTIVE_PROCESSES}}" ${NGINX_ACTIVE_CONNECTIONS} "${PADDING:${#NGINX_ACTIVE_CONNECTIONS}}"
  printf "\n"
  sleep 5
done
