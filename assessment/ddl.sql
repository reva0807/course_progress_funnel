create schema course_progress_funnel;

set search_path=course_progress_funnel;

-- dim_geo_info
create table dim_geo_info (
id BIGINT PRIMARY KEY,
city VARCHAR(255) NOT NULL,
state VARCHAR(255) NOT NULL,
counry VARCHAR(255) NOT NULL
);

-- dim_learner
create table dim_learner (
id BIGINT PRIMARY KEY,
email VARCHAR(255) NOT NULL,
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255) NOT NULL,
birthday DATE,
gender VARCHAR(10),
geo_id INT REFERENCES dim_geo(id),
registration_time timestamp with time zone NOT NULL,
is_active BOOLEAN DEFAULT TRUE NOT NULL,
created_at timestamp with time zone NOT NULL,
updated_at timestamp with time zone NOT NULL
);


-- dim_instructor
create table dim_instructor (
id BIGINT PRIMARY KEY,
email VARCHAR(255),
first_name VARCHAR(255),
last_name VARCHAR(255),
institution VARCHAR(255),
created_at timestamp with time zone NOT NULL,
updated_at timestamp with time zone NOT NULL
);

-- dim_course
create table dim_course (
id VARCHAR(255) primary key,
title VARCHAR(255) NOT NULL,
instructor_id BIGINT NOT NULL REFERENCES dim_instructor(id),
category VARCHAR(255),
created_at timestamp with time zone NOT NULL,
updated_at timestamp with time zone NOT NULL
);


-- dim_module
create table dim_module(
id VARCHAR(50) PRIMARY KEY,
title VARCHAR(255) NOT NULL,
ordinal_position INT NOT NULL,
course_id VARCHAR(255) NOT NULL REFERENCES dim_course(id),
publish_timestampt timestamp with time zone NOT NULL,
created_at timestamp with time zone NOT NULL,
updated_at timestamp with time zone NOT NULL
);

-- dim_item
create table dim_item (
id VARCHAR(50) PRIMARY KEY,
title VARCHAR(255) NOT NULL,
ordinal_position INT NOT NULL,
module_id VARCHAR(50) NOT NULL REFERENCES dim_module(id),
item_type VARCHAR(50) NOT NULL,
estimated_finish_time INT DEFAULT 10 NOT NULL,
publish_timestamp timestamp with time zone NOT NULL,
created_at timestamp with time zone NOT NULL,
updated_at timestamp with time zone NOT NULL
);


-- fct_item_activity
CREATE TABLE fct_item_activity (
  ID GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  learner_id BIGINT NOT NULL REFERENCES dim_learner(id),
  item_id VARCHAR(50) NOT NULL REFERENCES dim_item(id),
  action VARCHAR(255),
  result VARCHAR(255),
  start_timestamp timestamp with time zone NOT NULL,
  end_timestamp timestamp with time zone
);

-- fct_enrollment
create table fct_enrollment (
id GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
learner_id BIGINT NOT NULL REFERENCES dim_learner(id),
course_id VARCHAR(255) NOT NULL REFERENCES dim_course(id),
enrollment_timestamp timestamp with time zone NOT NULL
);











