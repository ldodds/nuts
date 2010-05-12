require 'rubygems'
require 'zip/zip'
require 'csv'
require 'cgi'

graph = "<http://statistics.data.gov.uk/data/ons-nuts/2008/authoritative>"

#Now serialize contains/containedBy
contains = "<http://data.ordnancesurvey.co.uk/ontology/spatialrelations/contains>"
contained_by = "<http://data.ordnancesurvey.co.uk/ontology/spatialrelations/containedBy>"

#Level 1
Zip::ZipFile.open("data/cache/nuts--level-1.zip") do |zipfile|
  entry = zipfile.get_entry("data/NUTS1_JAN_2008_UK_NC.csv")
  zipfile.get_input_stream(entry) do |stream|
      header = true
      CSV.parse(stream.read) do |row|        
        if header == false
          id = "<http://statistics.data.gov.uk/id/nuts-region/#{row[0]}>"
          label = row[1]
          puts "#{id} <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://statistics.data.gov.uk/def/nuts-geography/NUTSLevel1> #{graph}.\n"
          puts "#{id} <http://www.w3.org/2004/02/skos/core#prefLabel> \"#{label.gsub(" \(England\)", "")}\" #{graph}.\n"            
          puts "#{id} <http://www.w3.org/2004/02/skos/core#altLabel> \"#{label}\" #{graph}.\n"
          puts "#{id} <http://www.w3.org/2000/01/rdf-schema#label> \"#{label.gsub(" \(England\)", "")}\" #{graph}.\n"
          puts "#{id} <http://www.w3.org/2004/02/skos/core#notation> \"#{row[0]}\"^^<http://statistics.data.gov.uk/def/nuts-geography/NUTSCode> #{graph}.\n"
          puts "<http://statistics.data.gov.uk/id/nuts-area?name=#{CGI.escape(label)}> <http://www.w3.org/2000/01/rdf-schema#seeAlso> #{id} #{graph}.\n"          
        end
        header = false
      end    
  end
end

#Level 2
Zip::ZipFile.open("data/cache/nuts--level-2.zip") do |zipfile|
  entry = zipfile.get_entry("data/NUTS2_JAN_2008_UK_NC.csv")
  zipfile.get_input_stream(entry) do |stream|
      header = true
      CSV.parse(stream.read) do |row|        
        if header == false
          id = "<http://statistics.data.gov.uk/id/nuts-region/#{row[0]}>"
          parent_id = "<http://statistics.data.gov.uk/id/nuts-region/#{row[0][0..2]}>"
          label = row[1]
          puts "#{id} <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://statistics.data.gov.uk/def/nuts-geography/NUTSLevel2> #{graph}.\n"
          puts "#{id} <http://www.w3.org/2004/02/skos/core#prefLabel> \"#{label}\" #{graph}.\n"  
          puts "#{id} <http://www.w3.org/2000/01/rdf-schema#label> \"#{label}\" #{graph}.\n"
          puts "#{id} <http://www.w3.org/2004/02/skos/core#notation> \"#{row[0]}\"^^<http://statistics.data.gov.uk/def/nuts-geography/NUTSCode> #{graph}.\n"
                  
          puts "<http://statistics.data.gov.uk/id/nuts-area?name=#{CGI.escape(label)}> <http://www.w3.org/2000/01/rdf-schema#seeAlso> #{id} #{graph}.\n"
          
          puts "#{id} <http://statistics.data.gov.uk/def/nuts-geography/regionLevel1> #{parent_id} #{graph}.\n"
          puts "#{parent_id} <http://statistics.data.gov.uk/def/nuts-geography/regionLevel2> #{id} #{graph}.\n"
                    
          puts "#{id} #{contained_by} #{parent_id} #{graph}.\n"
          puts "#{parent_id} #{contains} #{id} #{graph}.\n"
        end
        header = false
      end    
  end
end

#Level 3
Zip::ZipFile.open("data/cache/nuts--level-3.zip") do |zipfile|
  entry = zipfile.get_entry("data/NUTS3_JAN_2008_UK_NC.csv")
  zipfile.get_input_stream(entry) do |stream|
      header = true
      CSV.parse(stream.read) do |row|        
        if header == false
          id = "<http://statistics.data.gov.uk/id/nuts-region/#{row[0]}>"
          parent_id = "<http://statistics.data.gov.uk/id/nuts-region/#{row[0][0..3]}>"
          label = row[1]
          puts "#{id} <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://statistics.data.gov.uk/def/nuts-geography/NUTSLevel3> #{graph}.\n"
          puts "#{id} <http://www.w3.org/2004/02/skos/core#prefLabel> \"#{label}\" #{graph}.\n"  
          puts "#{id} <http://www.w3.org/2000/01/rdf-schema#label> \"#{label}\" #{graph}.\n"
          puts "#{id} <http://www.w3.org/2004/02/skos/core#notation> \"#{row[0]}\"^^<http://statistics.data.gov.uk/def/nuts-geography/NUTSCode> #{graph}.\n"        
          puts "<http://statistics.data.gov.uk/id/nuts-area?name=#{CGI.escape(label)}> <http://www.w3.org/2000/01/rdf-schema#seeAlso> #{id} #{graph}.\n"
          
          puts "#{id} <http://statistics.data.gov.uk/def/nuts-geography/regionLevel2> #{parent_id} #{graph}.\n"
          puts "#{parent_id} <http://statistics.data.gov.uk/def/nuts-geography/regionLevel3> #{id} #{graph}.\n"

          #immediate parent is nuts region2
          puts "#{id} #{contained_by} #{parent_id} #{graph}.\n"
          puts "#{parent_id} #{contains} #{id} #{graph}.\n"
          #add further ancestor relations
          nuts_region_1 = row[0][0..2]
          puts "#{id} #{contained_by} <http://statistics.data.gov.uk/id/nuts-region/#{nuts_region_1}> #{graph}.\n"
          puts "<http://statistics.data.gov.uk/id/nuts-region/#{nuts_region_1}> #{contains} #{id} #{graph}.\n"
                                                            
        end
        header = false
      end    
  end
end

#LAU Level 1
Zip::ZipFile.open("data/cache/lau--level-1.zip") do |zipfile|
  entry = zipfile.get_entry("data/LAU1_JAN_2005_UK_NC.csv")
  zipfile.get_input_stream(entry) do |stream|
      header = true
      CSV.parse(stream.read) do |row|        
        if header == false
          id = "<http://statistics.data.gov.uk/id/nuts-lau/#{row[0]}>"
          parent_id = "<http://statistics.data.gov.uk/id/nuts-region/#{row[0][0..4]}>"
          label = row[1]
          puts "#{id} <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://statistics.data.gov.uk/def/nuts-geography/LAULevel1> #{graph}.\n"
          puts "#{id} <http://www.w3.org/2004/02/skos/core#prefLabel> \"#{label}\" #{graph}.\n"  
          puts "#{id} <http://www.w3.org/2000/01/rdf-schema#label> \"#{label}\" #{graph}.\n"
          puts "#{id} <http://www.w3.org/2004/02/skos/core#notation> \"#{row[0]}\"^^<http://statistics.data.gov.uk/def/nuts-geography/NUTSCode> #{graph}.\n"        
          puts "<http://statistics.data.gov.uk/id/nuts-area?name=#{CGI.escape(label)}> <http://www.w3.org/2000/01/rdf-schema#seeAlso> #{id} #{graph}.\n"
          
          puts "#{id} <http://statistics.data.gov.uk/def/nuts-geography/regionLevel3> #{parent_id} #{graph}.\n"
          puts "#{parent_id} <http://statistics.data.gov.uk/def/nuts-geography/lauLevel1> #{id} #{graph}.\n"

          #immediate parent is nuts region 3
          puts "#{id} #{contained_by} #{parent_id} #{graph}.\n"
          puts "#{parent_id} #{contains} #{id} #{graph}.\n"
                             
          #add nuts region 1
          nuts_region_1 = row[0][0..2]
          puts "#{id} #{contained_by} <http://statistics.data.gov.uk/id/nuts-region/#{nuts_region_1}> #{graph}.\n"
          puts "<http://statistics.data.gov.uk/id/nuts-region/#{nuts_region_1}> #{contains} #{id} #{graph}.\n"
          
          #add nuts region 2
          nuts_region_2 = row[0][0..3]
          puts "#{id} #{contained_by} <http://statistics.data.gov.uk/id/nuts-region/#{nuts_region_2}> #{graph}.\n"
          puts "<http://statistics.data.gov.uk/id/nuts-region/#{nuts_region_2}> #{contains} #{id} #{graph}.\n"
          
        end
        header = false
      end    
  end
end

#LAU Level 2
Zip::ZipFile.open("data/cache/lau--level-2.zip") do |zipfile|
  entry = zipfile.get_entry("data/LAU2_JAN_2005_UK_NC.csv")
  zipfile.get_input_stream(entry) do |stream|
      header = true
      CSV.parse(stream.read) do |row|        
        if header == false
          id = "<http://statistics.data.gov.uk/id/nuts-lau/#{row[0]}>"
          parent_id = "<http://statistics.data.gov.uk/id/nuts-lau/#{row[0][0..6]}>"
          label = row[1]
          #HACK!
          if label.index("Felin-f") != nil
            label = "Felin-fach"
          end
          puts "#{id} <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://statistics.data.gov.uk/def/nuts-geography/LAULevel2> #{graph}.\n"
          puts "#{id} <http://www.w3.org/2004/02/skos/core#prefLabel> \"#{label}\" #{graph}.\n"  
          puts "#{id} <http://www.w3.org/2000/01/rdf-schema#label> \"#{label}\" #{graph}.\n"
          puts "#{id} <http://www.w3.org/2004/02/skos/core#notation> \"#{row[0]}\"^^<http://statistics.data.gov.uk/def/nuts-geography/NUTSCode> #{graph}.\n"        
          puts "<http://statistics.data.gov.uk/id/nuts-area?name=#{CGI.escape(label)}> <http://www.w3.org/2000/01/rdf-schema#seeAlso> #{id} #{graph}.\n"
          
          puts "#{id} <http://statistics.data.gov.uk/def/nuts-geography/lauLevel1> #{parent_id} #{graph}.\n"
          puts "#{parent_id} <http://statistics.data.gov.uk/def/nuts-geography/lauLevel2> #{id} #{graph}.\n"

          #immediate parent is lau region 1
          puts "#{id} #{contained_by} #{parent_id} #{graph}.\n"
          puts "#{parent_id} #{contains} #{id} #{graph}.\n"

          #add nuts region 1
          nuts_region_1 = row[0][0..2]
          puts "#{id} #{contained_by} <http://statistics.data.gov.uk/id/nuts-region/#{nuts_region_1}> #{graph}.\n"
          puts "<http://statistics.data.gov.uk/id/nuts-region/#{nuts_region_1}> #{contains} #{id} #{graph}.\n"
          
          #add nuts region 2
          nuts_region_2 = row[0][0..3]
          puts "#{id} #{contained_by} <http://statistics.data.gov.uk/id/nuts-region/#{nuts_region_2}> #{graph}.\n"
          puts "<http://statistics.data.gov.uk/id/nuts-region/#{nuts_region_2}> #{contains} #{id} #{graph}.\n"
          
          #add nuts region 3
          nuts_region_3 = row[0][0..4]
          puts "#{id} #{contained_by} <http://statistics.data.gov.uk/id/nuts-region/#{nuts_region_3}> #{graph}.\n"
          puts "<http://statistics.data.gov.uk/id/nuts-region/#{nuts_region_3}> #{contains} #{id} #{graph}.\n"
                                        
        end
        header = false
      end    
  end
end

