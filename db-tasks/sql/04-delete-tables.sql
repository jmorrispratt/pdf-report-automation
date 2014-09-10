-- removing tables with no dependencies
DROP TABLE IF EXISTS infosel_stock_actions;
DROP TABLE IF EXISTS yahoo_stock_actions;

-- removing the rest of the tables
DROP TABLE IF EXISTS mediators;
DROP TABLE IF EXISTS enterprises;