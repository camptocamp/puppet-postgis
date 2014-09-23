# Don't edit this file directly:
#
# Puppet 3.6 has deprecated the Modulefile in favor of metadata.json
# Unfortunately we are using Puppet 3.4.3 which won't function without
# this file. Rather than editing two files, make all changes in the
# metadata.json file and then allow this file to be filled in programatically.

require 'json'
metadata = JSON.parse File.read(File.expand_path('../metadata.json', __FILE__))

name    metadata['name']
version metadata['version']
author  metadata['author']
license metadata['license']
summary metadata['summary']
source  metadata['source']
metadata['dependencies'].each do |d|
  dependency(d['name'], d['version_requirement'])
end
