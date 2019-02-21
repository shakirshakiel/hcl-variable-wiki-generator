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

def print_wiki(hash)
    print "| #{hash['name']} | #{hash['description']} | #{hash['type']} | #{hash['default']} | #{hash['required']} | \n"
end

hcl = File.read(ARGV[0])
parsed = HCL::Checker.parse(hcl)["variable"]

required_arr = []
non_required_arr = []

parsed.each do |k, v|
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

print_wiki({'name' => 'Name', 'description' => 'Description', 'type' => 'Type', 'default' => 'Default', 'required' => 'Required'})
print_wiki({'name' => '------', 'description' => '------', 'type' => '------', 'default' => '------', 'required' => '------'})
required_arr.map {|h| print_wiki(h)}
non_required_arr.map {|h| print_wiki(h)}


