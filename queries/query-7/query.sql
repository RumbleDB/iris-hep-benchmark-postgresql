SELECT HISTOGRAM((
  WITH GoodJets AS (
    SELECT (
      SELECT array_agg(j)
      FROM UNNEST(e.Jet) AS j
      WHERE
        j.pt > 30 AND
        NOT EXISTS (SELECT p FROM UNNEST(e.Muon) AS p
                    WHERE p.pt > 10 AND DELTA_R(p.eta, p.phi, j.eta, j.phi) < 0.4) AND
        NOT EXISTS (SELECT p FROM UNNEST(e.Electron) AS p
                    WHERE p.pt > 10 AND DELTA_R(p.eta, p.phi, j.eta, j.phi) < 0.4)) AS Jet
    FROM %(input_table)s AS e
  )
  SELECT array_agg((SELECT sum(j.pt) FROM UNNEST(Jets.Jet) AS j))
  FROM GoodJets AS Jets
  WHERE array_length(Jets.Jet, 1) > 0),
  15, 200, 100);
