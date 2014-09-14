-- -----------------------------------------------------------------------------------------------------

-- ----------- query to obtain the operative details for a client in a given period of time ------------
WITH

stocks_from_enterprise AS
(
	SELECT
		time_stamp,
		buyer_id,
		seller_id,
		volume,
		total
	FROM 
		infosel_stock_actions JOIN enterprises ON (stock_owner_id = enterprise_id)
	WHERE
		enterprise_ticker = 'AZTECA'
),

-- -------------------------------------------------------------

enterprise_stocks_in_time_range AS
(
	SELECT
		*
	FROM
		stocks_from_enterprise
	WHERE
		'2014-08-11' <= time_stamp AND time_stamp <= '2014-08-16'
),

-- -------------------------------------------------------------

buyers_ranking AS
(
	SELECT
		mediator_name,
		round(SUM(total) * 100.0 / (SELECT SUM(total) FROM enterprise_stocks_in_time_range), 2) as contribution
	FROM
		enterprise_stocks_in_time_range JOIN mediators ON (buyer_id = mediator_id)
	GROUP BY
		mediator_name
	ORDER BY
		contribution DESC
	LIMIT 4				-- getting top 4 only
),

-- -------------------------------------------------------------

sellers_ranking AS
(
	SELECT
		mediator_name,
		round(SUM(total) * 100.0 / (SELECT SUM(total) FROM enterprise_stocks_in_time_range), 2) as contribution
	FROM
		enterprise_stocks_in_time_range JOIN mediators ON (seller_id = mediator_id)
	GROUP BY
		mediator_name
	ORDER BY
		contribution DESC
	LIMIT 4				-- getting top 4 only
)

-- SELECT * FROM stocks_from_enterprise;
-- SELECT * FROM enterprise_stocks_in_time_range;
-- SELECT * FROM price_total
-- SELECT * FROM buyers_ranking
-- SELECT * FROM sellers_ranking

-- -----------------------------------------------------------------------------------------------------