# Fact: java_jre_version
#
# Purpose: store java jre versions in the config DB
#
# Resolution:
#   Tests for presence of java jre, returns nil if not present
#   returns output of "java -version" and splits on \n + '"'
#
# Caveats:
#   none
#
# Notes:
#   None
Facter.add(:java_jre_version) do
  setcode do
    java_jre = "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin/java"
    next unless File.exist? java_jre
    t_java_jre = Facter::Util::Resolution.exec("'#{java_jre}' -version 2>&1")
    next unless t_java_jre_line = t_java_jre.to_s.lines.first
    next unless t_java_jre_version_section = t_java_jre_line.strip.split(/version/)[1]
    java_jre_version = t_java_jre_version_section.gsub(/"/, "").strip
  end
end
