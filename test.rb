require_relative "scanners/scanner"
require_relative "parser"

sql = <<~SQL
Hash Join  (cost=1.07..2.19 rows=5 width=72) (actual time=0.035..0.038 rows=5 loops=1)
   Hash Cond: (posts.user_id = users.id)
   ->  Seq Scan on posts  (cost=0.00..1.05 rows=5 width=36) (actual time=0.007..0.008 rows=5 loops=1)
   ->  Hash  (cost=1.04..1.04 rows=4 width=36) (actual time=0.015..0.015 rows=4 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 9kB
         ->  Seq Scan on users  (cost=0.00..1.04 rows=4 width=36) (actual time=0.004..0.005 rows=4 loops=1)
SQL

lines = Scanner.new(sql).scan
Parser.new(lines).parse
