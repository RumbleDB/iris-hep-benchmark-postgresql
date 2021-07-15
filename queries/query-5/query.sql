SELECT HISTOGRAM((
    SELECT array_agg((MET).pt)
    FROM %(input_table)s AS e
    WHERE EXISTS(
      SELECT *
      FROM (SELECT (m).*, ROW_NUMBER() OVER () AS idx FROM UNNEST(Muon) AS m) AS m1,
           (SELECT (m).*, ROW_NUMBER() OVER () AS idx FROM UNNEST(Muon) AS m) AS m2
      WHERE
        m1.idx < m2.idx AND
        m1.charge != m2.charge AND
        INVARIANT_MASS(m1, m2) BETWEEN 60 AND 120)),
  0, 2000, 100);
