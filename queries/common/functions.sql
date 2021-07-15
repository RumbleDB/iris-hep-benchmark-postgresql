CREATE OR REPLACE FUNCTION HISTOGRAM_BIN(IN v DOUBLE PRECISION, IN lo DOUBLE PRECISION,
  IN hi DOUBLE PRECISION, IN bin_width DOUBLE PRECISION)
RETURNS DOUBLE PRECISION AS $$
BEGIN
  RETURN FLOOR((
    CASE
      WHEN v < lo THEN lo - bin_width / 4
      WHEN v > hi THEN hi + bin_width / 4
      ELSE v
    END - MOD(CAST(lo AS NUMERIC), CAST(bin_width AS NUMERIC))) / bin_width) * bin_width + bin_width / 2 
      + MOD(CAST(lo AS NUMERIC), CAST(bin_width AS NUMERIC));
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

CREATE OR REPLACE FUNCTION INVARIANT_MASS(IN p1 anyelement, IN p2 anyelement)
RETURNS DOUBLE PRECISION AS $$
BEGIN
  RETURN SQRT(2 * p1.pt * p2.pt * (COSH(p1.eta - p2.eta) - COS(p1.phi - p2.phi)));
END;
$$ LANGUAGE plpgsql;
