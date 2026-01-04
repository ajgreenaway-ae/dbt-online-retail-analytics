with orderline_data as  (
    select * from {{ ref ('fct_order_items' )}}
)
,
aggregated as 
(
    select order_id,
    min(order_date) as order_date,
    min(order_datetime) as order_datetime,
    sum(case when quantity > 0 then quantity else 0 end) as gross_items_in_order,
    sum(quantity) as net_items_in_order,
    sum(case when quantity > 0 then gross_amount else 0 end) as gross_revenue,
    sum(case when quantity < 0 then gross_amount else 0 end) as refund_amount,
    sum(gross_amount) as net_revenue,
    customer_id,
    country,
    is_cancelled
    from orderline_data
    group by all
)
select * from aggregated