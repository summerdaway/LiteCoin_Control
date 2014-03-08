require 'net/ssh'

threads = []
state_list = Hash.new

1.upto 182 do |m|
  t = Thread.new do
    begin
      Net::SSH.start("10.1.0.#{m}", "root", :password => "root", :auth_methods => ['password']) do |ssh|
        out = ssh.exec!("ps -e |grep minerd")
        state_list[m] = out
      end
    rescue
      puts "failed on #{m}"
    end
  end
  threads << t
end

threads.each do |t|
  t.join(30)
end

1.upto 182 do |m|
  puts "#{m} #{state_list[m]}"
end
