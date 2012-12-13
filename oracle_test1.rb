require 'OCI8'
require "Win32/Console/ANSI"
require 'colored'
require 'nokogiri'

conn = OCI8.new('cw', 'cw')
#conn = OCI8.new('scott', 'tiger', '//remote-host:1521/XE')

cursor = conn.parse("select * from cwmessagelog where rownum <= '#{ARGV[0]}'")
cursor.exec


while r = cursor.fetch()
	puts ("*"*75).blue.bold
	results = cursor.getColNames.zip(r)

	#Parse Account Number
	xml_doc = Nokogiri::XML(results.assoc("SEND_DATA")[1].read()) if results.assoc("SEND_DATA")[1]
	xml_doc.remove_namespaces!
	string = ["//*[@name=\"", ARGV[1] ,"\"]"].join("")
	string1 = ["//", ARGV[1] ,""].join("")
	

	xml_doc.xpath(string, string1).each do |node|
		puts ("#{ARGV[1]} Parsed: " + node.text).red.bold
	end
	
	puts (xml_doc)
	
	#puts results.assoc("SEND_DATA")[1]
	puts results.join(",").yellow.bold
	puts ("*"*75).blue.bold
end


conn.logoff