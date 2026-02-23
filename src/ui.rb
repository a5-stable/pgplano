require "js"
require "json"

$document = JS.global[:document]
$output = $document.getElementById("output")
$input_area = $document.getElementById("input-area")
$btn = $document.getElementById("parse-btn")

def parse_and_render
  input = $input_area[:value].to_s
  $output[:innerHTML] = "<div class='loading'>Parsing...</div>"

  JS.global.fetch("/parse", {
    method: "POST",
    body: input
  }.to_js).then do |res|
    res.text.then do |text|
      JS.global.renderTreeFromJSON(text.to_s)
    end
  end.catch do |e|
    $output[:innerHTML] = "<div class='empty-state'><p>Error: #{e}</p></div>"
  end
end

# Sample data
$input_area[:value] = <<~SQL
Hash Join  (cost=1.07..2.19 rows=5 width=72) (actual time=0.035..0.038 rows=5 loops=1)
   Hash Cond: (posts.user_id = users.id)
   ->  Seq Scan on posts  (cost=0.00..1.05 rows=5 width=36) (actual time=0.007..0.008 rows=5 loops=1)
   ->  Hash  (cost=1.04..1.04 rows=4 width=36) (actual time=0.015..0.015 rows=4 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 9kB
         ->  Seq Scan on users  (cost=0.00..1.04 rows=4 width=36) (actual time=0.004..0.005 rows=4 loops=1)
SQL

$btn.addEventListener("click") { parse_and_render }
