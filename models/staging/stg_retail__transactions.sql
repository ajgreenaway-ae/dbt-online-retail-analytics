With source as   
(
    select *
    from {{ source('retail', 'Transactions_All') }}
)
,

renamed as   
(
select 
    invoice as order_id,
    CAST(InvoiceDate as date) as order_date,
    CAST(InvoiceDate as datetime) as order_datetime,
    Stockcode as product_id,
    Description as description,
    cast(Price as numeric) as price,
    cast(quantity as int) as quantity,
    cast(cast(quantity as int)*cast(Price as numeric) as numeric) as gross_amount,
    cast(`Customer ID` as int) as customer_id,
    Country as country,
    case when left(invoice, 1) = "C" then True else False end as is_cancelled,
    case when cast(price as numeric) < 0 then True else False end as is_refund
    from source
)

select * from renamed