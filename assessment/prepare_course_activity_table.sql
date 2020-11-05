set search_path=public;

drop table IF EXISTS course_activity_temp;
CREATE TABLE course_activity_temp (
  user_id varchar(255),
  course_id varchar(255),
  item_id varchar(50),
  module_id varchar(50),
  item_start_ts varchar(255),
  item_complete_ts varchar(255),
  module_order varchar(255)
);

drop table IF EXISTS course_activity;
CREATE TABLE course_activity (
  user_id INTEGER,
  course_id varchar(255),
  item_id varchar(50),
  module_id varchar(50),
  item_start_ts TIMESTAMP,
  item_complete_ts TIMESTAMP,
  module_order INTEGER
);

COPY course_activity_temp (user_id, course_id, item_id, module_id, item_start_ts, item_complete_ts, module_order)
FROM '/data.csv'
DELIMITER ','
CSV HEADER;


insert into course_activity (select user_id::integer,
                                    course_id,
                                    item_id,
                                    module_id,
                                    item_start_ts::timestamp,
                                    case when item_complete_ts='[NULL]' then NULL else item_complete_ts::timestamp end,
                                    module_order::integer
                                    from course_activity_temp);

