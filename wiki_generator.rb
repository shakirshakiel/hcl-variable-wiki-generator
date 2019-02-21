require 'hcl/checker'

def get_type(hash)
    return "string" if hash["type"].nil? && hash["default"].nil?
    return "map" if hash["type"].nil? && hash["default"].instance_of?(Hash)
    return "list" if hash["type"].nil? && hash["default"].instance_of?(Array)
    return "string" unless hash["default"].nil?
    hash["type"]
end

def to_hcl_map(hash)
    arr = hash.map {|k, v| "#{k} = #{v}" }
    ["{ " , arr.join(", "), " } "].join("")
end

def get_default(hash)
    type = get_type(hash)
    return [] if type == "list" && hash.key?("default") && hash["default"].nil?
    return {} if type == "map" && hash.key?("default") && hash["default"].nil?
    return to_hcl_map(hash["default"]) if type == "map" && !hash["default"].nil?
    return "\"\"" if hash["default"] == ""
    hash["default"]
end

def print_input_wiki_line(hash)
    print "| #{hash['name']} | #{hash['description']} | #{hash['type']} | #{hash['default']} | #{hash['required']} | \n"
end

def print_input_wiki(content)
    input_parsed = HCL::Checker.parse(content)["variable"]
    required_arr = []
    non_required_arr = []
    
    input_parsed.each do |k, v|
        name = k
        description = v["description"]
        type = get_type(v)
        default = get_default(v)
        required = default ? "No" : "Yes"
    
        h = {
            'name' => name,
            'description' => description,
            'type' => type,
            'default' => default,
            'required' => required
        }
    
        default ? non_required_arr.push(h) : required_arr.push(h)
    end

    print "## Inputs\n\n"
    print_input_wiki_line({'name' => 'Name', 'description' => 'Description', 'type' => 'Type', 'default' => 'Default', 'required' => 'Required'})
    print_input_wiki_line({'name' => '------', 'description' => '------', 'type' => '------', 'default' => '------', 'required' => '------'})
    required_arr.map {|h| print_input_wiki_line(h)}
    non_required_arr.map {|h| print_input_wiki_line(h)}
    print "\n"            
end

def print_output_wiki_line(hash)
    print "| #{hash['name']} | #{hash['description']} | \n"
end

def print_output_wiki(content)
    output_parsed = HCL::Checker.parse(content)["output"]

    output_arr = []
    output_parsed.each do |k, v|
        name = k    
        description = v["description"]
        h = {
            'name' => name,
            'description' => description
        }
        output_arr.push(h)
    end
    
    print "## Outputs\n\n"
    print_output_wiki_line({'name' => 'Name', 'description' => 'Description'})
    print_output_wiki_line({'name' => '------', 'description' => '------'})
    output_arr.map {|h| print_output_wiki_line(h) }
    print "\n"    
end

input_hcl = File.read(ARGV[0])
print_input_wiki(input_hcl)

if ARGV[1]
    output_hcl = File.read(ARGV[1])
    print_output_wiki(output_hcl)
end



