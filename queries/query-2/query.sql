SELECT HISTOGRAM(
  (SELECT array_agg((j).pt) FROM %(input_table)s CROSS JOIN UNNEST(Jet) as j), 15, 60, 100);
