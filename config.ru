require_relative "scanners/scanner"
require_relative "parser"
require "json"
require "rack/files"

app = ->(env) {
  path = env["PATH_INFO"]

  if path == "/parse" && env["REQUEST_METHOD"] == "POST"
    body = env["rack.input"].read
    lines = Scanner.new(body).scan
    plan = Parser.new(lines).parse
    [200, { "content-type" => "application/json" }, [plan.to_json]]

  elsif path == "/"
    Rack::Files.new("public").call(env.merge("PATH_INFO" => "/index.html"))

  elsif path.start_with?("/src/")
    Rack::Files.new(".").call(env)

  else
    Rack::Files.new("public").call(env)
  end
}

run app
