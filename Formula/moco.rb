class Moco < Formula
  desc "Stub server with Maven, Gradle, Scala, and shell integration"
  homepage "https://github.com/dreamhead/moco"
  url "https://search.maven.org/remotecontent?filepath=com/github/dreamhead/moco-runner/0.11.1/moco-runner-0.11.1-standalone.jar"
  version "0.11.1"
  sha256 "57f8d1cc57267218cb8aa35648b8af25bfa1c8ccf0a4cf7260e30008d946d8a0"

  bottle :unneeded

  def install
    libexec.install "moco-runner-#{version}-standalone.jar"
    bin.write_jar_script libexec/"moco-runner-#{version}-standalone.jar", "moco"
  end

  test do
    require "net/http"

    (testpath/"config.json").write <<-EOS.undent
      [
        {
          "response" :
          {
              "text" : "Hello, Moco"
          }
        }
    ]
    EOS

    port = 12306
    thread = Thread.new do
      system bin/"moco", "http", "-p", port, "-c", testpath/"config.json"
    end

    # Wait for Moco to start.
    sleep 5

    response = Net::HTTP.get URI "http://localhost:#{port}"
    assert_equal "Hello, Moco", response
    thread.exit
  end
end
