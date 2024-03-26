#!/usr/bin/env ruby

require 'yaml'

POD_NAME='vxtest'

CHART_FILE = "charts/#{POD_NAME}/Chart.yaml"

fc_chart = File.read(CHART_FILE)

chart = YAML.load(fc_chart)

ver = chart["version"]

if /(\d+\.\d+\.)(\d+)/.match(ver) then
  puts "found version #{$1}<#{$2}>"

  rev_new = $2.to_i + 1

  newver = "#{$1}#{rev_new}"

  chart["version"] = newver
  chart["appVersion"] = newver

  fc_chart = YAML.dump(chart)

  File.open(CHART_FILE, 'w') { |f| f.write(fc_chart) }

  system <<SYSCOMMANDS

helm package -d charts/docs --version #{newver} charts/#{POD_NAME}
helm repo index charts
git add charts/docs/#{POD_NAME}-#{newver}.tgz
git commit -a -m "Increment to version #{newver}"
git push

SYSCOMMANDS
  
end



