require 'net/ssh'

threads = []
output = Hash.new
1.upto 182 do |m|
  t = Thread.new do
    begin
      Net::SSH.start("10.1.0.#{m}", "root", :password => "root", :auth_methods => ['password']) do |ssh|
        out = ssh.exec!("killall minerd")
        output[m] = out
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
  puts "#{m} #{output[m]}"
end
