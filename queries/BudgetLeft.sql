
WITH last_7day_usage as (
SELECT DATE(usage_start_time) as date, round(sum(cost),2) as cost
FROM `{project}.{dataset}.{table}`
WHERE DATE(usage_start_time) BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY) AND DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)
group by 1
),
avg_last_7day_usage as (
SELECT avg(cost) as avg_cost from last_7day_usage
),
budget_usage as (
SELECT round(sum(cost),2) as cost, round(sum(cost)/500 * 100,2) as budget_usage_percentage
FROM `{project}.{dataset}.{table}`
)
select *, round((500-cost)/avg_cost) as total_day_lefts from budget_usage, avg_last_7day_usage 
  