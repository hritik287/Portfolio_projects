SELECT *
FROM `projects`.`task`;



#Check for missing or null values in key columns such as xsell_gsa, xsell_day_exact, and ordercreatedate

SELECT 
    COUNT(*) AS total_rows,
    COUNT(xsell_gsa) AS non_null_xsell_gsa,
    COUNT(xsell_day_exact) AS non_null_xsell_day_exact,
    COUNT(ordercreatedate) AS non_null_ordercreatedate
FROM `projects`.`task`;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN xsell_gsa = 1 THEN 1 END) AS cross_sell_count,  -- count of customers who cross-sell (xsell_gsa = 1)
    COUNT(CASE WHEN xsell_gsa = 0 THEN 1 END) AS no_cross_sell_count,  -- count of customers who don't cross-sell (xsell_gsa = 0)
    COUNT(CASE WHEN xsell_day_exact != 'NA' THEN 1 END) AS non_null_xsell_day_exact  -- count of non-NA values in xsell_day_exact

/* find cross sell rate Cross-Sell Rate= 
Number of Cross-Sell Customers (xsell_gsa = 1)/ Total Number of Customers. */
​

SELECT 
	COUNT(*) AS total_customers,
    COUNT(CASE WHEN xsell_gsa = 1 THEN 1 END) AS cross_sell_count,  -- count of customers who cross-sell (xsell_gsa = 1)
    COUNT(CASE WHEN xsell_gsa = 0 THEN 1 END) AS no_cross_sell_count,  -- count of customers who don't cross-sell (xsell_gsa = 0)
    COUNT(CASE WHEN xsell_gsa = 1 THEN 1 END) * 1.0 / COUNT(*) AS cross_sell_rate
FROM`projects`.`task`;
SELECT 0.16106 * 100 AS Percentage;
# 16.1% 
     #how many customers cross-sell to an ACOM subscription within 120 days after purchasing a DNA product.
SELECT
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN xsell_gsa = 1 AND xsell_day_exact <= 120 AND xsell_day_exact != 'NA' THEN 1 END) AS cross_sell_within,
    COUNT(CASE WHEN xsell_gsa = 1 AND xsell_day_exact > 120 AND xsell_day_exact != 'NA' THEN 1 END) AS cross_sell_after,
     COUNT(CASE WHEN xsell_gsa = 1 AND xsell_day_exact >120 AND xsell_day_exact != 'NA' THEN 1 END) * 1.0 / COUNT(*) AS  cross_rate_after ,
    COUNT(CASE WHEN xsell_gsa = 1 AND xsell_day_exact <= 120 AND xsell_day_exact != 'NA' THEN 1 END) * 1.0 / COUNT(*) AS cross_rate_within
FROM`projects`.`task`;

   # 12.3% within 120 days
   # 0.03716 = 0.3% after 120 days
   
SELECT avg(daystogetresult_grp) as avg_time,
	 COUNT(CASE WHEN xsell_gsa = 1 AND xsell_day_exact <= 120 AND xsell_day_exact != 'NA' THEN 1 END) AS cross_sell_within
FROM`projects`.`task`
    WHERE daystogetresult_grp != '-1' AND daystogetresult_grp != '>10 weeks'
    GROUP BY daystogetresult_grp
	order by daystogetresult_grp;

/* analyzed the daystogetresult_grp (time to receive DNA test results) and 
found NO significant correlation between faster test results and a higher likelihood of cross-sell.
 Most customers had test results in similar timeframes (e.g., 4-6 weeks), with limited variation across the dataset. */

#lets see if data is missing or NA in imp columns

SELECT 
	COUNT(*) as total_rows,
    COUNT(CASE WHEN xsell_gsa IS NULL THEN 1 END) as null_xsell_gsa,
    COUNT(CASE WHEN  xsell_day_exact = 'NA' OR xsell_day_exact IS NULL THEN 1 END) as missing_day_exact,
    COUNT(CASE WHEN daystogetresult_grp = '-1' OR daystogetresult_grp != '>10 weeks' THEN 1 END ) as missing_daystoget
FROM`projects`.`task`;
    
   # Customer Count by Traffic Type 
SELECT dna_visittrafficsubtype, COUNT(DISTINCT prospectid) AS customer_count
FROM`projects`.`task`
GROUP BY dna_visittrafficsubtype
ORDER BY customer_count DESC;

# Cross-Sell Rate by Traffic Type

SELECT dna_visittrafficsubtype as visit_type,
(COUNT(CASE WHEN xsell_gsa = 1 AND xsell_day_exact <= 120 AND xsell_day_exact != 'NA' THEN 1 END) * 1.0 / COUNT(*)) *100 AS cross_rate_within
FROM `projects`.`task`
GROUP BY dna_visittrafficsubtype;


#Traffic Type and Customer Type Group Analysis

SELECT dna_visittrafficsubtype, customer_type_group, 
       COUNT(DISTINCT prospectid) AS customer_count
FROM `projects`.`task`
GROUP BY dna_visittrafficsubtype, customer_type_group
ORDER BY customer_count DESC;


