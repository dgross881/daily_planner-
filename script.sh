db () {
 docker run -P --volumes-from daily_planner_data --name daily_planner_production -e POSTGRES_USER=ENV['DB_ENV_POSTGRESQL_USER'] -e POSTGRES_PASSWROD=ENV['PQ_PASS'] -t postgres:latest
}

app() {
  docker run -p 3000:3000 --link daily_planner_data:postgres davidgross/daily_planner
}

# image is a ruby class 
# container is a ruby object 

action=$1 
${action} 
