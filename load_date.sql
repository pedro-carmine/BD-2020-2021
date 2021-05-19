CREATE TABLE d_date (
    id_date INTEGER,
    day INTEGER NOT NULL,
    week_day VARCHAR(9) NOT NULL,
    week INTEGER NOT NULL,
    month VARCHAR(9) NOT NULL,
    year INTEGER NOT NULL,
    PRIMARY KEY(id_date)
);

CREATE OR REPLACE FUNCTION load_d_date() RETURNS VOID AS
$$
DECLARE date_value TIMESTAMP;
BEGIN
    date_value := '2015-01-01 00:00:00';
    WHILE date_value < '2022-01-01 00:00:00' LOOP
        INSERT INTO d_date(
          id_date,
          day,
          week_day,
          week,
          month,
          year
) VALUES (
EXTRACT(YEAR FROM date_value) * 10000
+ EXTRACT(MONTH FROM date_value)*100
+ EXTRACT(DAY FROM date_value),
CAST(EXTRACT(DAY FROM date_value) AS INTEGER),
CASE EXTRACT(dow FROM date_value) 
WHEN 0 THEN 'Sunday'
WHEN 1 THEN 'Monday'
WHEN 2 THEN 'Tuesday'
WHEN 3 THEN 'Wednesday'
WHEN 4 THEN 'Thursday'
WHEN 5 THEN 'Friday'
WHEN 6 THEN 'Saturday'
END,
CAST(EXTRACT(WEEK FROM date_value) AS INTEGER),
CAST(EXTRACT(MONTH FROM date_value) AS INTEGER), EXTRACT(YEAR FROM date_value)
);
        date_value := date_value + INTERVAL '1 DAY';
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT load_d_date();