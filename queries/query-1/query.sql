SELECT HISTOGRAM(
  (SELECT array_agg((MET).pt) FROM %(input_table)s),
  0, 
  2000,
  100);