{  "nginxversion"         => %r{^nginx version: nginx\/(\d{1,}\.\d{1,}\.\d{1,})$},
}.each do |fact, pattern|
    Facter.add(fact) do
        setcode do
            unless defined?(@@nginxversion)
                @@nginxversion = Facter::Util::Resolution.exec('nginx -v 2>&1')
            end

            if pattern.match(@@nginxversion)
                $1
            else
                nil
            end
        end
    end
end
