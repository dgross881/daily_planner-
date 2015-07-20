export $APP_PWD = root 
db () {
 docker run -t postgres:latest -e POSTGRES_USER=app_user -e POSTGRES_PASSWROD=$APP_PWD
}
action=$1 

${action} 
