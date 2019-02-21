require 'hcl/checker'

hcl = File.read("./variables.tf")
parsed = HCL::Checker.parse(hcl)["variable"]

def get_type(str)
    return "string" if str.nil?
    return "map" if str.end_with? "}"
    return "list" if str.end_with? "]"
    return "string"
end

def print_wiki(hash)
    print "| #{hash['name']} | #{hash['description']} | #{hash['type']} | #{hash['default']} | #{hash['required']} | \n"
end

required_arr = []
non_required_arr = []

parsed.each do |k, v|
    name = k
    description = v["description"]
    type = get_type(v["type"])
    default = v["default"] == "" ? "\"\"" : v["default"]
    required = v["default"] ? "No" : "Yes"

    h = {
        'name' => name,
        'description' => description,
        'type' => type,
        'default' => default,
        'required' => required
    }

    v["default"] ? non_required_arr.push(h) : required_arr.push(h)
end

print_wiki({'name' => 'Name', 'description' => 'Description', 'type' => 'Type', 'default' => 'Default', 'required' => 'Required'})
print_wiki({'name' => '------', 'description' => '------', 'type' => '------', 'default' => '------', 'required' => '------'})
required_arr.map {|h| print_wiki(h)}
non_required_arr.map {|h| print_wiki(h)}


