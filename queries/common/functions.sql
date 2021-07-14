CREATE OR REPLACE FUNCTION HISTOGRAM_BIN(IN v DOUBLE PRECISION, IN lo DOUBLE PRECISION,
  IN hi DOUBLE PRECISION, IN bin_width DOUBLE PRECISION)
RETURNS DOUBLE PRECISION AS $$
BEGIN
  RETURN FLOOR((
    CASE
      WHEN v < lo THEN lo - bin_width / 4
      WHEN v > hi THEN hi + bin_width / 4
      ELSE v
    END - MOD(lo, bin_width)) / bin_width) * bin_width + bin_width / 2 
      + MOD(lo, bin_width);
END; 
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION HISTOGRAM(IN vals DOUBLE PRECISION [], IN lo DOUBLE PRECISION, 
  IN hi DOUBLE PRECISION, IN num_bins int = 100)
RETURNS TABLE (x DOUBLE PRECISION, y BIGINT) AS $$
BEGIN
  RETURN QUERY
    SELECT HISTOGRAM_BIN(v, lo, hi, (hi - lo) / num_bins) AS x, COUNT(*) AS y
    FROM (SELECT UNNEST(vals)) as tmp (v)
    GROUP BY x
    ORDER BY x;
END;
$$ LANGUAGE plpgsql;