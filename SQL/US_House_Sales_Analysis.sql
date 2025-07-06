--Total Pendapatan dari Rumah yang Terjual
select
	sum(cast(replace(replace("Price", '$', ''),',', '')as int)) as "Total Pendapatan"
from us_house_sales_data uhsd
where "Status" = 'Sold';

-- Jumlah Rumah yang Terjual, Belum Terjual, dan Masih Tertunda per State
select
	distinct "State",
	count(distinct case when "Status" = 'For Sale' then "MLS ID" end) as "For Sale",
	count(distinct case when "Status" = 'Sold' then "MLS ID" end) as "Sold",
	count(distinct case when "Status" = 'Pending' then "MLS ID" end) as "Pending",
	round(count(distinct case when "Status" = 'For Sale' then "MLS ID" end) / cast(count(distinct "MLS ID") as decimal) * 100, 1) as "% Belum Terjual",
	round(count(distinct case when "Status" = 'Sold' then "MLS ID" end) / cast(count(distinct "MLS ID") as decimal) * 100, 1) as "% Terjual",
	round(count(distinct case when "Status" = 'Pending' then "MLS ID" end) / cast(count(distinct "MLS ID") as decimal) * 100, 1) as "% Tertunda"
from us_house_sales_data uhsd
group by "State"
order by "For Sale" desc;

--Per city
select
	"City",
	count(distinct case when "Status" = 'For Sale' then "MLS ID" end) as "For Sale",
	count(distinct case when "Status" = 'Sold' then "MLS ID" end) as "Sold",
	count(distinct case when "Status" = 'Pending' then "MLS ID" end) as "Pending",
	round(count(distinct case when "Status" = 'For Sale' then "MLS ID" end) / cast(count(distinct "MLS ID") as decimal) * 100, 1) as "% Belum Terjual",
	round(count(distinct case when "Status" = 'Sold' then "MLS ID" end) / cast(count(distinct "MLS ID") as decimal) * 100, 1) as "% Terjual",
	round(count(distinct case when "Status" = 'Pending' then "MLS ID" end) / cast(count(distinct "MLS ID") as decimal) * 100, 1) as "% Tertunda"
from us_house_sales_data uhsd
group by "City"
order by "For Sale" desc;

--Jumlah Rumah Terjual per Agen
select 
	distinct "Listing Agent",
	count(distinct "MLS ID") as "Jumlah Proyek yang Dipegang",
	count(distinct case when "Status" = 'Sold' then "MLS ID" end) as "Sold",
	round(count(distinct case when "Status" = 'Sold' then "MLS ID" end) / cast(count(distinct "MLS ID") as decimal) * 100,1) as "% Terjual dari Sales"
from us_house_sales_data uhsd 
group by "Listing Agent";

--Rumah yang belum laku lama
select 
	count(case when "Status" <> 'Sold' and "Days on Market" < 
	(
	select avg("Days on Market") from us_house_sales_data
	where "Status" = 'Sold'
	)then "MLS ID" end) as "Belum Melewati Batas Waktu",
	count(case when "Status" <> 'Sold' and "Days on Market" > 
	(
	select avg("Days on Market") from us_house_sales_data
	where "Status" = 'Sold'
	)then "MLS ID" end) as "Melewati Batas Waktu", 
	
	round (
    100.0 * count(case when "Status" <> 'Sold' and "Days on Market" < (
        select avg("Days on Market") 
        from us_house_sales_data 
        where "Status" = 'Sold'
    ) then "MLS ID" end)
    / nullif(count(case when "Status" <> 'Sold' then "MLS ID" END), 0)
  , 2) as "Belum Melewati Batas Waktu (%)",
  round(
    100.0 * count(case when "Status" <> 'Sold' and "Days on Market" > (
        select avg("Days on Market") 
        from us_house_sales_data 
        where "Status" = 'Sold'
    ) then "MLS ID" end)
    / nullif(count(case when "Status" <> 'Sold' then "MLS ID" END), 0)
  , 2) as "Melewati Batas Waktu (%)"     
from us_house_sales_data uhsd;

-- Penjualan Berdasarkan Tahun Dibangun Rumah
select
	concat(floor("Year Built" / 10) *10,'s') as "Dekade",
	count(case when "Status" = 'Sold' then "MLS ID" end) as "Terjual",
	count(case when "Status" = 'For Sale' then "MLS ID" end) as "Belum Terjual",
	count(case when "Status" = 'Pending' then "MLS ID" end) as "Tertunda",
	ROUND(count(case when "Status" = 'Sold' then "MLS ID" end) * 100.0 / count("MLS ID"),1) as "% Terjual"
from us_house_sales_data uhsd
group by concat(floor("Year Built" / 10) *10,'s')
order by "Dekade";

--Tipe Properti yang paling banyak dibeli
select
  "Property Type",
  count(case when "Status" = 'Sold' then "MLS ID" END) as "Terjual",
  round(count(case when "Status" = 'Sold' then "MLS ID" END) * 100.0 / count("MLS ID"),1) as "% Terjual"
from us_house_sales_data
group by "Property Type";

--Rata-rata harga per Tipe Properti
select
	"Property Type",
	round(avg(cast(replace(replace("Price", '$', ''), ',', '') as int)),0) as "Rata-rata Harga Jual ($)"
from us_house_sales_data uhsd
group by "Property Type";

--Kepadatan Bangunan Rumaah yang masih dijual
select 
	distinct "Address",
	"Property Type",
	round(cast(replace("Area (Sqft)", ' sqft', '') as decimal) / cast(replace("Lot Size", ' sqft', '')as decimal), 2) as "Kepadatan Bangunan",
	"Status",
	"Price"
from us_house_sales_data uhsd
where "Status" = 'For Sale';

--Jumlah Rumah dari kombinasi bedroom dan bathroom
SELECT DISTINCT
  cast(replace("Bedrooms", ' bds', '') as int) as "Jumlah Kamar Tidur",
  cast(replace("Bathrooms", ' ba', '') AS INT) as "Jumlah Kamar Mandi",
  count(case when "Status" = 'Sold' then "MLS ID" end) as "Jumlah Terjual"
from us_house_sales_data
group by cast(replace("Bedrooms", ' bds', '') as int), cast(replace("Bathrooms", ' ba', '') AS INT);

select
	avg("Days on Market")
from us_house_sales_data uhsd 
where "Status" = 'Sold';