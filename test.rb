require_relative "scanner"
sql = <<~SQL
  Nested Loop  (cost=0.29..16.37 rows=1 width=72) (actual time=0.025..0.027 rows=1 loops=1)
  ->  Index Scan using users_pkey on users  (cost=0.15..8.17 rows=1 width=36) (actual time=0.012..0.013 rows=1 loops=1)
        Index Cond: (id = 1)
  ->  Seq Scan on tasks  (cost=0.00..1.05 rows=5 width=36) (actual time=0.010..0.011 rows=5 loops=1)
        Filter: (status = 1)
        Rows Removed by Filter: 2
SQL

Scanner.new(sql).scan
