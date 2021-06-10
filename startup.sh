set -e

export DATABASE_URL="postgresql://$db_db_user:$db_db_password@$db_db_host/$db_db_name"

bash -lc "bundle exec rails s -b 0.0.0.0"
