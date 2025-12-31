with retail_data as  (
    select * from {{ ref ('stg_retail__transactions' )}}
)
,
aggregated as 
(
    select
    {{ dbt_utils.generate_surrogate_key(['order_id', 'product_id']) }} as orderline_id,
    order_id,
    order_date,
    order_datetime,
    product_id,
    sum(price*quantity)/sum(quantity) as price,
    sum(quantity) as quantity,
    sum(gross_amount) as gross_amount,
    customer_id,
    country,
    is_cancelled,
    max(is_refund) as is_refund --covered in tests
    from retail_data
    group by all
)
select * from aggregated