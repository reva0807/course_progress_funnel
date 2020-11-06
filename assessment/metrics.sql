with dim_date as (
        SELECT date(d) as date_value
        FROM generate_series('2016-01-01', '2016-12-31', '1 day'::interval) d ),
dim_course as (
  select distinct(course_id) from course_activity
),
active_user_in_course as (select distinct
                                user_id,
                                course_id,
                                date(item_start_ts) as item_start_date
                                from course_activity),
user_sort_completed_ts  as (select distinct
                            user_id,
                            item_id,
                            module_id,
                            course_id,
                            item_complete_ts,
                            ROW_NUMBER() over (partition by user_id,module_id
                            order by item_complete_ts NULLS LAST)
                            as item_complete_order
                            from course_activity
                          ),
user_module_completed as (select user_id,
                                 module_id,
                                 course_id,
                                 item_complete_ts as module_complete_ts,
                                 ROW_NUMBER() over (partition by user_id,course_id
                                              order by item_complete_ts) as module_complete_order
                          from user_sort_completed_ts
                          where item_complete_order=4
                          and item_complete_ts is not null),
user_course_completd as ( select user_id,
                                 course_id,
                                 date(module_complete_ts) as course_complete_date
                          from user_module_completed
                          where module_complete_order=4
),
user_course_progressed as (select distinct ca.user_id,ca.course_id,date(ca.item_start_ts) as item_start_date
                           from course_activity ca
                           inner join (select distinct user_id from user_course_completd) uc
                           on ca.user_id=uc.user_id
                           left join user_module_completed umc
                             on umc.user_id=ca.user_id
                           and umc.module_id=ca.module_id
                          where umc.user_id is null)
select d.date_value,
       c.course_id,
       count(distinct cwp.user_id) as weekly_course_active,
       count(distinct case when cwp.user_id is NULL then NULL else pwp.user_id end) as weekly_course_retained_learners,
       count(distinct ucp.user_id) as weekly_course_progressed_learners,
       count(distinct ucc.user_id) as weekly_course_passed_learners
from dim_date d
  cross join dim_course c
  left join active_user_in_course cwp on cwp.course_id=c.course_id
  and cwp.item_start_date between d.date_value-6 and d.date_value

  left join active_user_in_course pwp on pwp.course_id=c.course_id
  and pwp.item_start_date between d.date_value-13 and d.date_value-7
  and cwp.user_id=pwp.user_id

  left join user_course_progressed ucp on ucp.course_id=c.course_id
  and  ucp.item_start_date between d.date_value-6 and d.date_value

  left join user_course_completd ucc on ucc.course_id=c.course_id
  and ucc.course_complete_date between d.date_value-6 and d.date_value

group by d.date_value,c.course_id
;


