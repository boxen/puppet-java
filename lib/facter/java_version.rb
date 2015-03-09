# Fact: java_version
#
# Purpose: get full java version string
#
# Resolution:
#   Tests for presence of java, returns nil if not present
#   returns output of "java -version" and splits on \n + '"'
#
# Caveats:
#   none
#
# Notes:
#   None
Facter.add(:java_version) do
  # This will fail on OS X when Java hasn't been installed yet.
  next unless Kernel.system "/usr/libexec/java_home --failfast &>/dev/null"
  setcode do
    if Facter::Util::Resolution.which('java')
      Facter::Util::Resolution.exec('java -Xmx8m -version 2>&1').lines.first.split(/"/)[1].strip
    end
  end
end
