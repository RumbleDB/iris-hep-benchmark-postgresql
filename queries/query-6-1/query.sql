SELECT HISTOGRAM((
    WITH EventsWithTriJet AS (
      SELECT *, (
       SELECT ADD_PT_ETA_PHI_M3(j1, j2, j3) AS j123
            FROM (SELECT (j).*, ROW_NUMBER() OVER () AS idx FROM UNNEST(Jet) as j) AS j1,
                 (SELECT (j).*, ROW_NUMBER() OVER () AS idx FROM UNNEST(Jet) as j) AS j2,
                 (SELECT (j).*, ROW_NUMBER() OVER () AS idx FROM UNNEST(Jet) as j) AS j3
            WHERE j1.idx < j2.idx AND j2.idx < j3.idx
            ORDER BY ABS((ADD_PT_ETA_PHI_M3(j1, j2, j3)).mass - 172.5) ASC LIMIT 1) AS triJet
      FROM %(input_table)s
    )
    SELECT array_agg((e.triJet).pt)
    FROM EventsWithTriJet AS e
    WHERE triJet IS NOT NULL),
  15, 40, 100);