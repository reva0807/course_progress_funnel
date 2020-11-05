
with dim_date as (
        SELECT date(d) as date_value
        FROM generate_series('2016-01-01', '2016-12-31', '1 day'::interval) d ),
dim_course as (select distinct(course_id) from course_activity),
active_user_in_course as (select distinct
                                user_id,
                                course_id,
                                date(item_start_ts) as item_start_date
                                from course_activity)
select d.date_value,
       c.course_id,
       count(distinct cwp.user_id),
       count(distinct pwp.user_id)
from dim_date d
  cross join dim_course c
  left join active_user_in_course cwp on cwp.course_id=c.course_id
  and cwp.item_start_date between d.date_value-6 and d.date_value
  left join active_user_in_course pwp on pwp.course_id=c.course_id
  and pwp.item_start_date between d.date_value-13 and d.date_value-7
group by d.date_value,c.course_id
;
