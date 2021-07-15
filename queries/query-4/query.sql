SELECT HISTOGRAM((
    SELECT array_agg((MET).pt)
    FROM %(input_table)s
    WHERE
      (SELECT COUNT(*) FROM UNNEST(Jet) AS j
       WHERE (j).pt > 40) > 1),
  0, 2000, 100);
