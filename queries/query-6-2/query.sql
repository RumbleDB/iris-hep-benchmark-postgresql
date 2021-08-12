WITH EventsWithTriJet AS (
 SELECT *, (
  SELECT CAST(ROW(ADD_PT_ETA_PHI_M3(j1, j2, j3), (j1).btag, (j2).btag, (j3).btag) AS triJetType)
       FROM (SELECT (j).*, ROW_NUMBER() OVER () AS idx FROM UNNEST(Jet) as j) AS j1,
            (SELECT (j).*, ROW_NUMBER() OVER () AS idx FROM UNNEST(Jet) as j) AS j2,
            (SELECT (j).*, ROW_NUMBER() OVER () AS idx FROM UNNEST(Jet) as j) AS j3
       WHERE j1.idx < j2.idx AND j2.idx < j3.idx
       ORDER BY ABS((ADD_PT_ETA_PHI_M3(j1, j2, j3)).mass - 172.5) ASC LIMIT 1) AS triJet
 FROM %(input_table)s
)
SELECT HISTOGRAM_BIN(GREATEST((e.triJet).btag1, (e.triJet).btag2, (e.triJet).btag3), 0.0, 1.0, (1.0 - 0.0) / 100.0) AS x,
  COUNT(*) AS y
FROM EventsWithTriJet AS e
WHERE triJet IS NOT NULL
GROUP BY x
ORDER BY x;