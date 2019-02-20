require 'hcl/checker'

hcl = File.read("./variables.tf")
parsed = HCL::Checker.parse(hcl)["variable"]

def get_type(str)
    return "string" if str.nil?
    return "map" if str.end_with? "}"
    return "list" if str.end_with? "]"
    return "string"
end

parsed.each do |k, v|
    name = k
    description = v["description"]
    type = get_type(v["type"])
    default = v["default"]
    required = v["default"] ? "No" : "Yes"
    print "| #{name} | #{description} | #{type} | #{default} | #{required} | \n"
end


