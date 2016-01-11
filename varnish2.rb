require 'formula'

class Varnish < Formula
  url 'http://repo.varnish-cache.org/source/varnish-2.1.5.tar.gz'
  head 'http://repo.varnish-cache.org/source/varnish-3.0.0-beta1.tar.gz'
  homepage 'http://www.varnish-cache.org/'
  sha1 '2d8049be14ada035d0e3a54c2b519143af40d03d917763cf72d53d8188e5ef83'

  # if ARGV.build_head?
  #   md5 'c4dbd66ac6795c6c9d1c143ef2a47d38'
  # else
  #   md5 '2d2f227da36a2a240c475304c717b8e3'
  # end

  depends_on 'pkg-config' => :build
  depends_on 'pcre'

  # Do not strip varnish binaries: Otherwise, the magic string end pointer isn't found.
  skip_clean :all

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make install"
    (var+'varnish').mkpath
  end

  def plist; <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/varnishd</string>
          <string>-n</string>
          <string>#{var}/varnish</string>
          <string>-f</string>
          <string>#{etc}/varnish/default.vcl</string>
          <string>-s</string>
          <string>malloc,1G</string>
          <string>-T</string>
          <string>localhost:6082</string>
          <string>-a</string>
          <string>:6081</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/varnish/varnish.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/varnish/varnish.log</string>
      </dict>
      </plist>
    EOS
  end
end
