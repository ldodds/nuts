require 'rubygems'
require 'rake'
require 'rake/clean'
require 'pho'

BASE_URL="http://www.ons.gov.uk/about-statistics/geography/products/geog-products-area/names-codes/eurostat"
BASE_DIR="data"

CACHE_DIR="#{BASE_DIR}/cache"
DATA_DIR="#{BASE_DIR}/out"
ETC_DIR="etc"

CLEAN.include ["#{DATA_DIR}/*/*.nt", "#{DATA_DIR}/*/*.nq", "#{DATA_DIR}/*/*.ttl", "#{DATA_DIR}/*.tar.gz"]

task :init do
  sh %{mkdir -p #{CACHE_DIR} }
  sh %{mkdir -p #{DATA_DIR}/to_load}
  sh %{mkdir -p #{DATA_DIR}/schema}
  sh %{mkdir -p #{DATA_DIR}/data}  
end

task :cache => [:init] do
  sh %{curl #{BASE_URL}/nuts--level-1.zip -o #{CACHE_DIR}/nuts--level-1.zip}
  sh %{curl #{BASE_URL}/nuts--level-2.zip -o #{CACHE_DIR}/nuts--level-2.zip}
  sh %{curl #{BASE_URL}/nuts--level-3.zip -o #{CACHE_DIR}/nuts--level-3.zip}
  sh %{curl #{BASE_URL}/lau--level-1.zip -o #{CACHE_DIR}/lau--level-1.zip}
  sh %{curl #{BASE_URL}/lau--level-2.zip -o #{CACHE_DIR}/lau--level-2.zip}
end

task :ntriples => [:init] do
  sh %{ruby bin/nuts.rb > #{DATA_DIR}/data/nuts.nt}
end

task :nquads => [:init] do
  sh %{ruby bin/nuts-quads.rb > #{DATA_DIR}/data/nuts.nq}
end

task :convert => [:ntriples, :nquads]
  
task :static => [:init] do
 sh %{cp #{ETC_DIR}/nuts-schema.ttl #{DATA_DIR}/schema/nuts-schema.ttl}
 sh %{cp #{ETC_DIR}/void.ttl #{DATA_DIR}/void.ttl}
 sh %{cp #{ETC_DIR}/uriset.ttl #{DATA_DIR}/uriset.ttl}
end

task :prepare => [:convert, :static] do
  sh %{rapper -i turtle -o ntriples #{ETC_DIR}/nuts-schema.ttl >#{DATA_DIR}/to_load/nuts-schema.nt}
  sh %{rapper -i turtle -o ntriples #{ETC_DIR}/void.ttl >#{DATA_DIR}/to_load/void.nt}
  sh %{rapper -i turtle -o ntriples #{ETC_DIR}/uriset.ttl >#{DATA_DIR}/to_load/uriset.nt}
  sh %{cp #{DATA_DIR}/data/nuts.nt #{DATA_DIR}/to_load/nuts.nt}   
  sh %{cp #{DATA_DIR}/data/nuts.nq #{DATA_DIR}/to_load/nuts.nq}
end

task :package => [:prepare] do
 sh %{tar -C #{DATA_DIR} -c -z -f #{DATA_DIR}/nuts.tar.gz data schema to_load uriset.ttl void.ttl}
end

