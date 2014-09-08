COMMENT ON DATABASE stock_data
  IS 'This is the database for the ''bmv'' stock data';

-- creating the 'companies' table
CREATE TABLE companies
(
		company_id 		serial,
		company_name	VARCHAR(50) NOT NULL UNIQUE,	-- i guess 50 characters are enough

		-- primary key constraints
		CONSTRAINT companies_pk PRIMARY KEY(company_id)
);

-- creating the 'data_sources' table
CREATE TABLE data_sources
(
		data_src_id		serial,
		data_src_name	VARCHAR(50) NOT NULL UNIQUE,	-- i guess 50 characters are enough

		-- primary key constraints
		CONSTRAINT data_sources_pk PRIMARY KEY(data_src_id)
);

-- creating the 'stock_actions' table
CREATE TABLE stock_actions
(
		action_id			serial,
		buyer_id			INT NOT NULL,
		seller_id			INT NOT NULL,
		volume				INT NOT NULL,
		price					NUMERIC(5,2) NOT NULL,		-- upper bound of 1000
		total					NUMERIC(10,2) NOT NULL ,	-- upper bound of 100 millions
		time_stamp		TIMESTAMP NOT NULL ,
		data_src_id		INT NOT NULL,

		-- column constraints
		CONSTRAINT volume_can_not_be_negative CHECK(volume >= 0),
		CONSTRAINT price_can_not_be_negative CHECK(price >= 0.0),
		CONSTRAINT total_should_be_volume_times_price CHECK (total = volume * price),
		CONSTRAINT timestamp_must_be_after_y2k CHECK(time_stamp > '2000-01-01'),		-- stock action after y2k

		-- primary key constraints
		CONSTRAINT stock_actions_pk PRIMARY KEY(action_id),

		-- foreign key constraints
		CONSTRAINT stock_actions_buyer_id_fk FOREIGN KEY(buyer_id) REFERENCES
			companies(company_id) ON UPDATE CASCADE ON DELETE CASCADE,
		CONSTRAINT stock_actions_seller_id_fk FOREIGN KEY(seller_id) REFERENCES
			companies(company_id) ON UPDATE CASCADE ON DELETE CASCADE,
		CONSTRAINT stock_actions_data_src_id_fk FOREIGN KEY(data_src_id) REFERENCES
			data_sources(data_src_id) ON UPDATE CASCADE ON DELETE CASCADE
);