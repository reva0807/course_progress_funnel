docker-compose up -d

docker cp ./ddl.sql my_postgres:/ddl.sql

docker cp ./prepare_course_activity_table.sql my_postgres:/prepare_course_activity_table.sql

docker cp ./metrics.sql my_postgres:/metrics.sql

docker cp ./data/course_funnel_assignment.csv my_postgres:/data.csv

docker exec -it my_postgres psql -U postgres

