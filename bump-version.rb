#!/usr/bin/env ruby

require 'yaml'

CHART_FILE = "charts/vxfuel/Chart.yaml"

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

helm package -d charts/docs --version #{newver} charts/vxfuel
helm repo index charts
git add charts/docs/vxfuel-#{newver}.tgz
git commit -a -m "Increment to version #{newver}"
git push

SYSCOMMANDS
  
end



