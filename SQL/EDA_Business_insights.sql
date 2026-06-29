/* ==================
		EDA
   ================== */ 
   use sales_analytics;
-- 1. What is the total number of orders, customers, and products in the dataset?
	select count(Distinct Order_Id) as Total_orders,
    count(distinct Customer_Id) as Total_Customer,
    count(distinct product_id) as total_Products 
    from superstore_staging;
    # ------ Observation ------
    -- -> There are total of 5009 different order which consists of  793 distinct customers and 1862 distinct products
    
-- 2. What is the time period covered by the dataset (earliest order date to latest order date)?
	select min(Order_Date) as First_order,
	max(order_date) as last_order
    from superstore_staging; 
    # ------- Observation ------ 
    -- -> The superstore received the first order on 3rd January 2014 and the last on 30th December 2017
    
-- 3. What are the total sales, total profit, average sales, average profit, minimum sales, and maximum sales?
	select Round(sum(sales),2) as total_sales,
    Round(Sum(Profit),2) as total_profit,
    round(avg(sales),2) as avg_sales,
    round(avg(profit),2) as avg_profit,
    round(min(sales),2) min_sales,
    round(max(sales),2) max_sales
    from superstore_staging;

    # ------ Observations -------
    -- -> Total sales of superstore is 2296919.49 with an average sales of 229.85. Sales ranges from 0.44 to 22638.48 
	-- -> Total profit is 286409.08  with an average profit of 28.66
    
    # ------- Business Insights ------
	--  -> The company generated total sales of $2.30M approximately with a total profit of $286.41K.
	-- -> The average order value is $229.85, while the average profit per transaction is $28.66.
	-- -> Sales vary significantly, ranging from $0.44 to $22,638.48, indicating a mix of very small and very large orders.
-- 4. How are orders distributed across different product categories?
	select count(distinct order_id) as Orders ,category
    from superstore_staging
    group by category
    order by Orders desc;
    
    #  ------ Observations -----
    -- -> Office supplies contributes the most number of orders followed by Furniture and Technology
    # ----- Business Insights -------
    -- -> Office Supplies is the most frequently purchased  category indicating  high demand.
    -- The company should maintain adequate supply to meet customer demands and avoid stock shortage.
    
-- 5. How are orders distributed across different product sub-categories?
	select sub_category, count(distinct order_id) as orders
    from superstore_staging
    group by Sub_category
    order by orders asc;
    
    # ----- Observations -----
    -- -> Binders, paper and furnishings receive the highest number of order
    -- -> while copiers and machines comparitively fewer orders.
    
-- 6. How are customers distributed across different customer segments?
	 Select segment,count(Distinct Customer_Id) as Total_Customers
     from superstore_staging
     group by segment
     order by Total_Customers desc;
     
     # ----- Observation -----
     -- -> The Consumer segment has the highest number of consumers (409) followed by Corporate (236) and Home Office (148)
-- 7. How are orders distributed across different regions?
		select region,count(distinct Order_Id) as Orders 
        from superstore_staging
        group by region
        order by Orders desc;
        
        ## ----- Observation -----
        -- -> West Region hast highest number of orders (1611), followed by east (1401),central(1175), South(822)
        
-- 8. Which shipping modes are most frequently used?
	select count(order_id)as Orders, ship_mode
    from superstore_staging
    group by ship_mode
    order by Orders desc;
    
    # ----- Observation -----
    -- -> Standard class is the most frequently used shipping mode,followed by second class, First class and Same day
    
-- 9. What is the distribution of discounts offered across all orders?
	select discount, count(*) as total_orders
	from superstore_staging
	group by discount
	order by Total_orders desc;
    
    # ----- Observation -----
	-- -> Most orders are placed without any discount,
	-- -> while 20% discount is the second most frequently offered discount.
	-- -> Higher discount levels are comparatively less common.
    
    
-- 10. What is the average shipping duration between order date  and ship date and How are orders distributed based on shipping duration (in days) ?
	select round(avg(datediff(ship_date , order_date)),2) as Avg_Shipping_Duration
    from superstore_staging;
    
    
    select datediff(ship_date, order_date) as shipping_days,
		count(*) as total_orders,
        round(count(*)*100/sum(count(*))over (),2) as percentage
		from superstore_staging
		group by shipping_days
		order by total_orders desc;
    
    
	# ------ Observation -----
    -- -> The average shipping duration is 4 days approximately.
    -- -> Mostly orders are shipped within 3 to 5 days
    -- -> while very few orders get shipped on the same day or take more than 6 days.
    
    
    /* ==========================================
            BUSINESS INSIGHTS
========================================== */

-- 1. Which are the top 10 states by total sales?
	select state,Round(sum(sales),2) as total_sales
    from superstore_staging
    group by state
    order by total_sales desc
    limit 10;
	
    # ----- Observation -----
	-- -> California contributes highest sales, followed by New York and Texas
    
    # ----- Business Insight -----
    -- -> California is the leading market in terms of sales.
	-- -> Maintaining a strong presence in top-performing states and identifying
	-- -> growth opportunities in other regions can help increase overall revenue.


-- 2. Which are the top 10 cities by total sales?
		select City,Round(sum(sales),2) as Total_sales
        from superstore_staging
        group by city
        order by Total_sales desc limit 10;
        
        # ----- Observations -----
        -- -> New York City contribute highest sales followed by Los Angeles , Seattle, San Francisco, Philadelphia
        -- -> These cities contributes top revenues
        
        # ----- Business Insights -----
        -- -> The superstore has a strong customer base in major metropolitan cities
        -- -> Maintaining inventory, marketing efforts, and customer engagement in these
		-- -> high-performing cities can help sustain revenue while similar urban markets
		-- -> can be targeted for future growth.
        
-- 3. Which region contributes the highest revenue?
		select Region,Round(sum(sales),2) as Total_sales
        from superstore_staging
        group by region
        order by total_sales desc ;
        
        # ----- Observations ---
        -- -> West region contributes the most in sales followed by east, central and south
	
-- 4. Which product category generates the highest sales?
		select Category,sum(sales) as Sales
		from superstore_staging
		group by category
		order by sales desc;
    
		# ----- Observations -----
		-- -> Technology category have the highest sales followed by Furniture and Office Supplies
    
-- 5. Which product sub-category generates the highest sales?
		select sub_category, round(sum(sales),2) as total_sales
        from superstore_staging 
        group by sub_category
        order by total_sales desc;
        
        # ----- Observation ----
        -- -> Phones contributes most in sales followed by chairs and storage
        
-- 6. Which are the top 10 best-selling products based on total sales?
		select product_name, round(sum(sales),2) as sales
        from superstore_staging
        group by product_name
        order by sales desc limit 10;
        # ----- Observation -----
		-- -> Canon imageCLASS 2200 Advanced Copier generated the highest sales,
		-- -> followed by Fellowes PB500 Electric Punch Plastic Comb Binding Machine
		-- -> and Cisco TelePresence System EX90 Videoconferencing Unit.
		-- -> These products are the top revenue contributors in the dataset.

		# ----- Business Insight -----
		-- -> A small group of high-value products contributes significantly to total sales.
		-- -> The company should ensure consistent availability of these products and
		-- -> consider targeted promotions or upselling strategies to maximize revenue.
-- 7. Which states generate the highest profit?
		select state,round(sum(profit),2) as total_profit
        from superstore_staging
        group by state
        order by total_profit desc;
        
        # ----- Observation -----
        -- -> -- California generated the highest profit, followed by the next highest profit-generating states in the dataset.
        
        # ----- Business Insight -----
        -- -> California is the company's most profitable market.
		-- -> Maintaining a strong customer base and expanding high-performing products
		-- -> in this state can help sustain and improve overall profitability.
-- 8. Which states incur the highest losses?
		select state, round(sum(profit),2) as total_loss 
        from superstore_staging
        group by state
        order by total_loss asc;
        
        # ----- Observation -----
		-- Texas recorded the highest loss, followed by Ohio, Pennsylvania,
		-- Illinois, and North Carolina.
		-- Several states generated negative profits, indicating loss-making operations.
        
        # ----- Business Insight -----
		-- States such as Texas and Ohio are negatively impacting overall profitability.
		-- The company should analyze pricing strategies, discount policies, and product
		-- performance in these states to identify the causes of losses and improve margins.
        
-- 9. Which region is the most profitable?
		select region,round(sum(profit),2) profit
        from superstore_staging
        group by region
        order by profit desc ;
        
        # ----- Observation -----
        -- West region generated the highest profit followed by  East, south and Central
        
-- 10. Which product category generates the highest profit?
		select category,round(sum(profit),2) as profits
		from superstore_staging
        group by category 
        order by profits desc;
        
        # ----- Observation -----
        -- Technology generates highest profits followed by Office Supplies and Furniture
        
-- 11. Which product sub-category generates the lowest profit or incurs losses?
		select sub_category,round(sum(profit),2) as profits
		from superstore_staging
        group by sub_category 
        order by profits asc;
        
        # ----- Observation ------
        -- Tables, Bookcases, Supplies incurs losses and Fasteners generates lowest profit follows by Machines and labels. 
        
-- 12. Which are the top 10 most profitable products?
		select product_name, round(sum(profit),2) profits
        from superstore_staging
        group by product_name 
        order by profits desc limit 10;
        
        # ----- Observation -----
		-- Canon imageCLASS 2200 Advanced Copier generated the highest profit,
		-- followed by Fellowes PB500 Electric Punch Plastic Comb Binding Machine
		-- and Hewlett Packard LaserJet 3310 Copier.
		-- These products are the top profit contributors in the dataset.

		# ----- Business Insight -----
		-- A few high-value products contribute a significant share of total profit.
		-- The company should ensure their availability and consider targeted marketing
		-- and cross-selling strategies to further improve profitability.
        
-- 13. Which products consistently generate negative profit?
		select product_name, round(sum(profit),2) profits
        from superstore_staging
        group by product_name 
        order by profits asc;
        
		# ----- Observation -----
		-- Cubify CubeX 3D Printer Double Head Print incurred the highest loss,
		-- followed by Lexmark MX611dhe Monochrome Laser Printer and
		-- Cubify CubeX 3D Printer Triple Head Print.
		-- Several products generated negative profit despite being sold.

		# ----- Business Insight -----
		-- Loss-making products are reducing overall profitability.
		-- The company should review their pricing, discount strategy, and demand,
		-- and consider discontinuing or repricing products that consistently generate losses.

-- 14. Who are the top 10 customers by total sales?
		select customer_id,customer_name,round(sum(sales),2) as sales
        from superstore_staging
        group by customer_id, customer_name
        order by sales desc limit 10;
        
        # ----- Observation -----
		-- Sean Miller generated the highest sales, followed by
		-- Tamara Chand and Raymond Buch.
		-- These customers are the top revenue contributors in the dataset.

		# ----- Business Insight -----
		-- These customers contributes significantly to total sales.
		-- The company should focus on retaining these high-value customers through
		-- loyalty programs, personalized offers, and excellent customer service to
		-- encourage repeat purchases.
        
-- 15. Who are the top 10 customers by total profit?
		select customer_id,customer_name, round(sum(profit),2) as profits
        from superstore_staging
		group by customer_id,customer_name 
        order by profits desc limit 10;
        
        # ---- observation ----- 
        -- Tamara Chand contributes the highest profit followed by Raymond buch and Sanjit Chand
        -- these customer are top profit contributors for the company
        

		
-- 16. Which customer segment contributes the highest profit?
		select segment, round(sum(profit),2) as profits
        from superstore_staging
        group by segment
        order by profits desc;
        
         # ----- Observation ------
        -- Consumer contributes the most in Profits followed by corporate and home office.
        


-- 17. How does discount impact profitability?
		select discount, round(sum(profit),2) as profits
        from superstore_staging
        group by discount
        order by discount asc;
        
        # ----- Observation -----
		-- Orders with no discount generated the highest profit, followed by
		-- orders with a 20% discount. Discounts of 30% and above resulted
		-- in negative profits, with a 70% discount causing the highest loss.

-- 18. Which shipping mode generates the highest sales and profit?
		select ship_mode,
        round(sum(sales),2) as total_sales,
        round(sum(profit),2) as total_profit
        from superstore_staging
        group by ship_mode
        order by total_sales desc;
        
		# ------ Observation -------
        -- Standard class generates the highest sales and highest profit followed by Second Class , First Class
        
        

-- 19. Which product sub-categories generate high sales but low profit?

		select sub_category ,
        round(sum(sales),2) as Sales,
        round(sum(profit),2) as Profits
        from superstore_staging
        group by sub_category
        having sum(profit) < 0
        order by Sales desc;
        
        # ----- Obsevation ----- 
        -- Tables and Bookcases have high number of sales but incurs losses.
        
        # ----- Business Insight ------
        -- High Sales does not implies high profitability 
        -- Tables and BookCases despite having high numbers of sales incurs losses
        -- The company should review pricing, discount , and procurement costs for these sub categories to improve profit margin
        


-- 20. What are the monthly sales and profit trends, and which months consistently perform the best and worst?
		Select monthname(Order_date) Month,
        round(sum(sales),2) Sales,
        round(sum(profit),2) Profits
        from superstore_staging
        group by Month,month(order_date)
        Order by month(order_date);
        
        # ------ Observation ------
        -- November recorded the highest sales followed by December and September
        -- December generates the highest profits followed by September and November
        -- February has the lowest sales , While January generated the lowest profit
        
        # ------ Business Insights -----
        -- Sales and Profitability shows a seasonal trends, where the last quadrant of the year has best performance .
        -- The company should increase inventory, marketing efforts, and staffing before
		-- September to December, while introducing promotional campaigns during January
		-- and February to improve business performance during slower months.
        
        
 /* =================================================
				KEY RECOMMENDATIONS
    =================================================*/
	-- 1. Focus marketing efforts on high-performing states such as California and New York to maximize revenue.
    
	-- 2. Review pricing and discount strategies in loss-making states like Texas and Ohio to improve profitability.
    
	-- 3. Maintain adequate inventory for top-selling and highly profitable products to avoid stock shortages.

	-- 4. Re-evaluate loss-making products and sub-categories such as Tables and Bookcases by optimizing pricing or reducing discounts.

	-- 5. Avoid excessive discounts (30% and above) as they significantly reduce profitability or incurs loss.

	-- 6. Increase inventory and promotional planning before September to December, as these months consistently generate the highest sales and profit.

	-- 7. Launch targeted campaigns during January and February to improve sales during relatively weaker months.

	-- 8. Strengthen relationships with high-value customers through loyalty programs and personalized offers to encourage repeat purchases.